import 'dart:core';
import 'dart:io';
import 'package:bruno/bruno.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:testt/common/UI/res_color.dart';
import 'package:testt/utils/vr_utils.dart';
import '../../../common/event_bus/vr_event_bus.dart';
import '../../../common/global/global_theme.dart';
import '../../../common/housecard/house_card.dart';
import '../../../generated/assets.dart';
import '../../../utils/channel/vr_boost_channel.dart';
import '../../../utils/db/vr_todo_task_bean.dart';
import '../../../utils/db/vr_todo_task_db.dart';
import '../../input_house/house_const.dart';
import '../vr_show_unupload_sheet.dart';
import 'package:image/image.dart' as img;

///
/// @date:2023-05-05 11:31:08
/// @author:bill
/// @des:${des}
///

EventBus eventBus = new EventBus();

typedef UNUploadCallback = void Function(int num);

class VRUnuploadCaptureTask extends StatefulWidget {
  final UNUploadCallback? callback;

  const VRUnuploadCaptureTask({Key? key, this.callback}) : super(key: key);

  @override
  _unupload_caoture_taskState createState() => _unupload_caoture_taskState();
}

class _unupload_caoture_taskState extends State<VRUnuploadCaptureTask> {
  @override
  late List<VRToDoTask> notes;

  List<VRToDoTask> _userTasknotes = [];
  List<String> thumbnailList = [];

  late VRToDoTask? _currentTask;

  void initState() {
    // 监听 CustomEvent 事件，刷新 UI
    eventBus.on<VREvent>().listen((event) {
      if (event.msg == VREventName.KPostSaveSuccess) {
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          refreshNotes();
        });
      }
    });

    if (Platform.isIOS) {
      removeListener = BoostChannel.instance
          .addEventListener(ChannelKey.requestCompletion, (key, arguments) {
        Map<dynamic, dynamic> arg = arguments;
        String status = arg['status'] ?? '';
        if (status == "success") {
          String houseId = arg['houseId'].toString();
          if (houseId == _currentTask?.houseId) {
            _deleteNotes(task: _currentTask);
          } else {
            NotesDatabase.instance.deleteHouseId(houseId);
          }
          BrnLoadingDialog.dismiss(context);
          Navigator.pop(context);
          eventBus.fire(VREvent(VREventName.KPostSaveSuccess));
          eventBus.fire(VREvent(VREventName.kTabBarChange, index: 2));
        } else if (status == "failed") {
          ///失效状态
          Navigator.pop(context);
          _currentTask?.uploadState = -1;
          _fixHouseIDNotes(task: _currentTask, needrefresh: true);
        }
        Future<dynamic> init() async {}
        return init();
      });
    }

    refreshNotes();

    super.initState();
  }

  VoidCallback? removeListener;

  bool _isUserDataBase = false;

  Future refreshNotes() async {
    if (_isUserDataBase == true) {
      return;
    } else {
      _isUserDataBase = true;
    }
    _userTasknotes = [];
    thumbnailList = [];
    this.notes = await NotesDatabase.instance.readAllNotes(asc: false);

    if (this.notes.length == 0) {
      if (mounted) {
        setState(() {
          _isUserDataBase = false;
          BrnLoadingDialog.dismiss(context);
          if (widget.callback != null) {
            widget.callback!(_userTasknotes.length ?? 0);
          }
        });
      }
      return;
    }

    int index = 0;
    this.notes.forEach((e) {
      _userTasknotes.add(e);
      VRUtils.pathTothumbnail(e.coverPath.toString()).then((value) {
        thumbnail(e.coverPath.toString()).then((value2) {
          thumbnailList.add(value);
          index++;
          if (index == this.notes.length) {
            if (mounted) {
              setState(() {
                _isUserDataBase = false;
                BrnLoadingDialog.dismiss(context);
                if (widget.callback != null) {
                  widget.callback!(_userTasknotes.length ?? 0);
                }
              });
            }
          }
        });
      });
    });
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
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userTasknotes.length == 0) {
      return EasyRefresh(
        header: GlobalTheme().classicHeader,
        footer: GlobalTheme().classicFooter,
        onRefresh: () async {
          refreshNotes();
        },
        child: SingleChildScrollView(
          child: Container(
            height: 500,
            child: Center(
              child: BrnAbnormalStateWidget(
                isCenterVertical: true,
                enablePageTap: true,
                img: Image.asset(
                  Assets.iconsEmpty,
                  scale: 3.0,
                ),
                title: '暂无数据',
                action: (index) {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (BuildContext context) {
                  //     return VRInputHouse(type: VRInputHouseEnum.edit);
                  //   },
                  // ));
                },
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      color: GlobalColor.color_white,
      child: Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: EasyRefresh(
                header: GlobalTheme().classicHeader,
                footer: GlobalTheme().classicFooter,
                onRefresh: () async {
                  refreshNotes();
                },
                onLoad: () async {},
                child: ListView.builder(
                    itemCount: _userTasknotes.length,
                    addRepaintBoundaries: false,
                    addAutomaticKeepAlives: false,
                    itemBuilder: (context, index) {
                      return _buildHouseCard(context,
                          task: _userTasknotes[index], idx: index);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseCard(BuildContext context, {VRToDoTask? task, int? idx}) {
    List buttomlist = [
      VRHouseCardType.delete,
      VRHouseCardType.more,
      VRHouseCardType.upload
    ];
    if (kDebugMode) {
      buttomlist = [
        VRHouseCardType.fixHouseId,
        VRHouseCardType.delete,
        VRHouseCardType.more,
        VRHouseCardType.upload
      ];
    }
    return Container(
      child: VRHouseCard(
        imageURL: thumbnailList[idx ?? 0],
        houseId: task?.houseId,
        title:
            '${HouseConst.houseTypeString(type: '${task?.houseType}')}/${task?.communityName}',
        detail: task?.roomInfo,
        bottomSource: buttomlist,
        listType: VRHouseTListype.unupload,
        status: task?.uploadState.toString(),
        itemClicked: () {
          VRShowUnUploadSheet.showBottomModal(
            context,
            type: VRSHouseheetEnum.makesure,
            taskbean: task,
          );
        },
        moreClicked: () {
          Future.delayed(const Duration(milliseconds: 500), () {})
              .then((value) {
            VRShowUnUploadSheet.showBottomModal(context,
                type: VRSHouseheetEnum.more, taskbean: task);
          });
        },
        uploadClicked: () {
          VRUtils.pathCheckRoomJson(task?.coverPath ?? '').then((value) async {
            print('pathCheckRoomJson === ${value.toString()}');
            if (!value) {
              if (task != null) {
                if (task.houseId != null && task.coverPath != null) {
                  var path = await VRUtils.getTemporaryTimeSp(task.coverPath!);
                  print('pathCheckRoomJson path:' + path);
                  VRUtils.writeInRoomTxt(task.houseId!, path);
                  VRUtils.writeInConfigGson(path);
                } else {
                  print(
                      'pathCheckRoomJson task.houseId==null||task.filePath==null');
                }
              } else {
                print('pathCheckRoomJson task==null');
              }
            }
          });
          _currentTask = task;
          VRShowUnUploadSheet.showBottomModal(context,
              type: VRSHouseheetEnum.makesure,
              taskbean: task, callback: (value) {
            // BrnLoadingDialog.show(context, content: '数据上传中...');
            if (Platform.isAndroid) {
              if (value['state'] == '1') {
                Navigator.pop(context);
                refreshNotes();
                eventBus.fire(VREvent(VREventName.kTabBarChange, index: 2));
              } else if (value['state'] == '-1') {
                ///失效状态
                Future.delayed(Duration(milliseconds: 300)).then((value) {
                  Navigator.pop(context);
                  _currentTask?.uploadState = -1;
                  _fixHouseIDNotes(task: _currentTask, needrefresh: true);
                });
              }
            }
          });
        },
        deleteClicked: () {
          _currentTask = task;
          _showAlert(task: task);
        },
        fixHouseClicked: () async {
          _showFixHouseId(task: task);
        },
      ),
    );
  }

  void _showFixHouseId({VRToDoTask? task}) {
    BrnMiddleInputDialog(
        title: '修改房源ID',
        message: task?.houseId,
        hintText: task?.houseId,
        cancelText: '取消',
        confirmText: '确定',
        autoFocus: true,
        maxLength: 100,
        maxLines: 2,
        textInputAction: TextInputAction.done,
        dismissOnActionsTap: true,
        barrierDismissible: true,
        inputEditingController: TextEditingController()
          ..text = (task?.houseId) ?? '',
        onConfirm: (value) {
          task?.houseId = value.toString();
          _fixHouseIDNotes(task: task);
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        }).show(context);
  }

  void _showAlert({VRToDoTask? task, String? value}) {
    BrnDialogManager.showConfirmDialog(context,
        title: "确认删除吗？",
        cancel: '取消',
        confirm: '确定',
        message: "请确认删除当前数据！", onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () {
      Navigator.pop(context);
      BrnLoadingDialog.show(context, content: '删除数据中请勿操作      ');

      ///删除的id
      _deleteNotes(task: task);
    });
  }

  Future _deleteNotes({VRToDoTask? task, String? value}) async {
    ///删除的id
    /// TODO:
    if (task?.id == null) {
      BrnToast.show('删除数据失败，请联系工作人员', context);
      return;
    }

    await NotesDatabase.instance
        .delete(int.parse(task?.id ?? ''))
        .then((value) {
      if (_currentTask != null) {
        refreshNotes();
        if (widget.callback != null) {}
        widget.callback!(_userTasknotes.length ?? 0);
      }
      return value;
    });
  }

  Future _fixHouseIDNotes({VRToDoTask? task, bool? needrefresh}) async {
    ///删除的id
    int updateID =
        await NotesDatabase.instance.updateHouseId(task!).then((value) {
      BrnToast.show('修改成功', context);
      refreshNotes();
      return value;
    });
  }
}
