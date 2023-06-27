import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import '../../common/bean/house_edit_back_bean.dart';
import '../../common/event_bus/vr_event_bus.dart';
import '../../common/global/global.dart';
import '../../common/UI/res_color.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../common/sharedInstance/vr_shared_preferences.dart';
import '../../utils/channel/vr_boost_channel.dart';
import '../../utils/db/panoinfo_db/vr_panoinfo_bean.dart';
import '../../utils/db/vr_todo_task_bean.dart';
import '../../utils/db/vr_todo_task_db.dart';
import '../../utils/vr_utils.dart';
import '../home/bean/vr_home_plan_bean.dart';
import '../home/bean/vr_need_task_bean.dart';
import '../home/taskPage/unupload_capture_task.dart';
import 'house_edit_info.dart';
import 'house_edit_tab_pageview.dart';
import 'house_edit_title.dart';
import 'panoinfo_bean.dart';
import 'package:image/image.dart' as img;


class VRHouseEdit extends StatefulWidget {
  final VRNeedTaskListBean? bean;

  const VRHouseEdit({Key? key, this.bean}) : super(key: key);

  @override
  _house_editState createState() {
    return _house_editState();
  }
}

class _house_editState extends State<VRHouseEdit> {
  ///声明一个用来存回调的对象
  VoidCallback? trackingStateChangeListener;

  ///声明一个用来存回调的对象
  VoidCallback? panoInfoPathListener;

  ///声明一个用来存回调的对象
  VoidCallback? trackingStateNormalListener;

  ValueNotifier<bool> _isCanSave = ValueNotifier(false);

  bool isShowSave = false;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    Global.isShowSave = false;

    if (Platform.isIOS) {
      ///打开
      _openARKit();

      ///这里添加监听，原生利用'event'这个key发送过来消息的时候，下面的函数会调用，
      ///这里就是简单的在flutter上弹一个弹窗
      ///
      trackingStateChangeListener = BoostChannel.instance
          .addEventListener(ChannelKey.trackingStateChange, (key, arguments) {
        BrnToast.show('请确保设备正常连接', context);

        Future<dynamic> init() async {}
        return init();
      });

      panoInfoPathListener = BoostChannel.instance
          .addEventListener(ChannelKey.panoInfoPath, (key, arguments) {
        Map<dynamic, dynamic> arg = arguments;
        VRUserSharedInstance.instance().panoInfoPath = arg['panoInfoPath'];
        Future<dynamic> init() async {}
        return init();
      });
    }
  }

  ///播放语音提示
  Future playLocalFinish() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/shooting_finish.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(
      assetSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BrnAppBar(
        brightness: Brightness.light,
        title: '房源编辑',
        actions: [_buildAction()],
        backLeadCallback: () {
          _backCilck();
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
            color: GlobalColor.color_white,
            padding: EdgeInsets.only(
              top: 16,
            ),
            child: _buildList()),
      ),
    );
  }

  Widget _buildAction() {
    return GestureDetector(
        onTap: () {
          if (_isCanSave.value) {
            _showAlert();
          }
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: _isCanSave,
            builder: (BuildContext context, bool value, Widget? child) {
              return Container(
                margin: EdgeInsets.only(top: 10, bottom: 8),
                color: (_isCanSave.value)
                    ? GlobalColor.color_mainColor
                    : GlobalColor.color_cccccc,
                height: 30,
                width: 56,
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(
                        color: GlobalColor.color_white,
                        fontSize: 14,
                        fontWeight: GlobalFontWeight.font_medium),
                  ),
                ),
              );
            }));
  }

  void _showAlert({VRToDoTask? task, String? value}) {
    BrnDialogManager.showConfirmDialog(context,
        title: "请确认是否保存",
        cancel: '继续拍摄',
        confirm: '确认保存',
        message: "保存后暂不支持补拍，请确认此房源所有房间！", onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () {
      _saveCilck();
      Navigator.pop(context);
    });
  }

  ///连接设备
  void _openARKit() {
    if (Platform.isIOS) {

      VRSharedPreferences().getRoomlistPath(widget.bean?.houseId).then((value) {
        BoostChannel.instance
            .sendEventToNative(ChannelKey.openARKit, {"unsavedPath": value});
      });
    }
  }


  ///保存
  void _saveCilck() {
    ///点击保存到数据库
    Map<String, dynamic> bean = widget.bean!.toJson();
    VRToDoTask toDoTask = VRToDoTask.fromJson(bean);
    toDoTask.buildArea = widget.bean?.buildArea;
    toDoTask.houseType = widget.bean?.houseType;
    toDoTask.doorFace = widget.bean?.doorFace;
    toDoTask.filePath = VRUserSharedInstance.instance().panoInfoPath;
    if (editBackBean.isNotEmpty) {
      VRHouseEditBackBean editBack = editBackBean.first;
      toDoTask.coverPath = editBack.tempThumbnail;
      toDoTask.relativeCoverPath = editBack.relativeCoverPath;
      toDoTask.saveTime = (DateTime.now().microsecondsSinceEpoch).toString().substring(0,10);
      toDoTask.picPointNum = panInfoList.length ?? 1;
      toDoTask.remark = widget.bean?.remark;
      toDoTask.needMosaic = 2;
      toDoTask.homePlan = TransVRHomePlan().roomBeanList();
    }

    PanoInfoBean panoInfoBean = PanoInfoBean(
        doorFace: widget.bean?.doorFace ?? 1,
        needMosaic: 2,
        panoInfoList: panInfoList);

    if (Platform.isIOS) {
      BoostChannel.instance.sendEventToNative(ChannelKey.pauseARKit, {
        "roomJson": jsonEncode(panoInfoBean),
        "uploadParams": jsonEncode(toDoTask)
      });
    }
    _insertNotes(task: toDoTask);
  }

  ///保存
  void _backCilck() {
    if (Platform.isIOS) {
      BoostChannel.instance.sendEventToNative(
          ChannelKey.pauseARKit, {"roomJson": '', "uploadParams": ''});
    }
    Navigator.pop(context);
  }
  
  ScrollController _scrollController = ScrollController();

  Future _insertNotes({VRToDoTask? task}) async {
    VRToDoTask insterNodes =
        await NotesDatabase.instance.insert(task!).then((value) {
      BrnToast.show('保存成功', context);
      VRSharedPreferences().deleteAllRoomlist(widget.bean?.houseId);
      eventBus.fire(VREvent(VREventName.KPostSaveSuccess));
      eventBus.fire(VREvent(VREventName.kTabBarChange, index: 1));
      Navigator.pop(context);
      return value;
    });
  }

  Future _insertPanoInfoNotes({PanoInfoDBBean? task}) async {
    PanoInfoDBBean insterNodes =
        await NotesDatabase.instance.insertPano(task!).then((value) {
      // BrnToast.show(value.toString(), context);
      return value;
    });
  }

  Future _deletePanoInfoNotes({PanoInfoDBBean? task}) async {
    if (task?.id == null) {
      return;
    }
    int idnum =
        await NotesDatabase.instance.deletePano(task?.id ?? 0).then((value) {
      return value;
    });
  }

  Widget _buildList() {
    return Container(
      child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: 3,
          addRepaintBoundaries: false,
          addAutomaticKeepAlives: false,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: _isOpen ? 12 : 20,
                ),
                child: VRHouseEditInfoTitle(
                  title: widget.bean?.communityName,
                  subtitle: widget.bean?.roomInfo,
                  type: _isOpen ? VREditType.open : VREditType.down,
                  onTapClick: () {
                    if (mounted) {
                      setState(() {
                        _isOpen = !_isOpen;
                      });
                    }
                  },
                ),
              );
            }
            if (index == 1) {
              if (_isOpen == true) {
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 18),
                    decoration: BoxDecoration(
                      color: Color(0xfff7f7f7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: VRHouseEditInfo(
                      bean: widget.bean,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }
            if (index == 2) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: VRHouseEditTabPageView(
                    bean: widget.bean,
                    callBack: (res) {
                      _addPaoInfoBean(res: res);
                    },
                    deleteOnTap: (res) {
                      _deletePaoInfoBean(res: res);
                    },
                    scrollCallBack: (pixels) {
                      if (pixels < 0) {
                        _scrollController.jumpTo(0.0);
                      }
                    },
                  ));
            }
          }),
    );
  }

  List<PanoInfoList> panInfoList = [];
  List<VRHouseEditBackBean> editBackBean = [];

  void _addPaoInfoBean({Map<String, dynamic>? res}) {
    Map<String, dynamic> result = res ?? Map();
    VRHouseEditBackBean bean = VRHouseEditBackBean.fromJson(result);

    ///假如存在相同名字的图片数据 则返回
    if (_hasSamePic(bean.fileName ?? '')) {
      return;
    }
    editBackBean.add(bean);
    _isCanSave.value = editBackBean.isNotEmpty;

    panInfoList.add(PanoInfoList(
        fileName: bean.fileName,
        floor: 1,
        needMosaic: 2,
        roomTitle: bean.title));

    ///插入到panoinfo 数据
    PanoInfoDBBean panoInfoDBBean = PanoInfoDBBean(
        houseId: widget.bean?.houseId,
        fileName: bean.fileName,
        filePath: bean.tempThumbnail,
        relativePath: bean.relativeCoverPath,
        folderPath: VRUserSharedInstance.instance().panoInfoPath,
        type: 'jpg',
        needMosaic: 2,
        floor: 1,
        roomTitle: bean.title);

    try {
      if (bean.tempThumbnail != null && (panInfoList.length == 0)) {
        thumbnail(bean.tempThumbnail ?? '');
      }
    } catch (e, stack) {

      print(e.toString());
    }
    if (Platform.isIOS) {
      _insertPanoInfoNotes(task: panoInfoDBBean);
    }
  }


  @override
  Future thumbnail(String args) async {
    final path = args.isNotEmpty ? args : 'test.png';
    VRUtils.pathTothumbnail(args).then((value) async {
      File txt = File(value);
      var dir_bool = await txt.exists(); //返回真假
      if (dir_bool) {
        return;
      }
      final cmd = img.Command()
      // Decode the image file at the given path
        ..decodeImageFile(path)
      // Resize the image to a width of 64 pixels and a height that maintains the aspect ratio of the original.
        ..copyResize(width: 64)
      // Write the image to a PNG file (determined by the suffix of the file path).
        ..writeToFile(value);
      // On platforms that support Isolates, execute the image commands asynchronously on an isolate thread.
      // Otherwise, the commands will be executed synchronously.
      await cmd.executeThread().then((value) {
      });
    });
  }


  void _deletePaoInfoBean({Map<String, dynamic>? res}) {
    Map<String, dynamic> result = res ?? Map();
    VRHouseEditBackBean bean = VRHouseEditBackBean.fromJson(result);
    List<VRHouseEditBackBean> tList = [];
    editBackBean.forEach((element) {
      if (element.fileName != bean.fileName) {
        tList.add(element);
      }
    });
    editBackBean = tList;
    _isCanSave.value = editBackBean.isNotEmpty;

    List<PanoInfoList> tplist = [];
    PanoInfoList panoInfoList = PanoInfoList(
        fileName: bean.fileName,
        floor: 1,
        needMosaic: 2,
        roomTitle: bean.title);
    panInfoList.forEach((element) {
      if (element.fileName != panoInfoList.fileName) {
        tplist.add(element);
      }
    });
    panInfoList = tplist;

    ///插入到panoinfo 数据
    PanoInfoDBBean panoInfoDBBean = PanoInfoDBBean(
        houseId: widget.bean?.houseId,
        fileName: bean.fileName,
        filePath: bean.tempThumbnail,
        relativePath: bean.relativeCoverPath,
        folderPath: VRUserSharedInstance.instance().panoInfoPath,
        type: 'jpg',
        needMosaic: 2,
        floor: 1,
        roomTitle: bean.title);
    if (Platform.isIOS) {
      _deletePanoInfoNotes(task: panoInfoDBBean);
    }
  }

  bool _hasSamePic(String fileName) {
    bool same = false;
    panInfoList.forEach((element) {
      if (element.fileName == fileName) {
        same = true;
      }
    });
    return same;
  }

  @override
  void dispose() {
    trackingStateChangeListener?.call();
    panoInfoPathListener?.call();
    trackingStateNormalListener?.call();

    super.dispose();
  }
}
