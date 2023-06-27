import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boost/flutter_boost.dart';
import '../../common/bean/house_edit_back_bean.dart';
import '../../common/global/global.dart';
import '../../common/photo_screen.dart';
import '../../common/UI/res_color.dart';
import '../../common/request/request_url.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../common/sharedInstance/vr_shared_preferences.dart';
import '../../common/show_panorama.dart';
import '../../utils/channel/vr_boost_channel.dart';
import '../../utils/vr_utils.dart';
import '../home/bean/vr_need_task_bean.dart';
import '../input_house/house_const.dart';
import '../input_house/house_single_sheet.dart';
import 'house_edit_ex.dart';
import 'house_edit_page_item.dart';
import 'house_edit_title.dart';

typedef HouseEditScrollCallBack = void Function(double pixels);

class VRHouseEditPage extends StatefulWidget {
  final PhotoScreenCallBack? callBack;

  final String? title;

  final String? houseID;

  final int? index;

  final HouseEditScrollCallBack? scrollCallBack;

  final PhotoScreenCallBack? deleteOnTap;

  final VRNeedTaskListBean? listBean;

  const VRHouseEditPage(
      {Key? key,
      this.callBack,
      this.title,
      this.houseID,
      this.index,
      this.deleteOnTap,
      this.listBean,
      this.scrollCallBack})
      : super(key: key);

  @override
  _house_edit_pageState createState() {
    return _house_edit_pageState();
  }
}

class _house_edit_pageState extends State<VRHouseEditPage> {
  @override

  ///声明一个用来存回调的对象
  VoidCallback? capturePreviewParamsListener;

  List<List<VRHouseEditBackBean>> roomSectionList = [];

  ///只有是其他的时候使用此数组
  List<String> otherRoomTitleList = [];

  void initState() {
    super.initState();

    if (widget.title == '其他') {
      roomSectionList = [];
    } else {
      roomSectionList =
          VRHouseEditEx.getRoomList(bean: widget.listBean, title: widget.title);
    }

    ////fix - -存储当前的图片和图片地址
    if (validateInput(widget.houseID)) {
      ///存储当前的图片和图片地址
      ///判断hoseid 不是 null
      ///获取数据

      List homePlanList = [];
      widget.listBean?.homePlan?.forEach((element) {
        homePlanList.add(element.name);
      });
      VRSharedPreferences().getRoomList(widget.houseID ?? '').then((value) {
        List<String>? roomList = value;
        if (roomList != null) {
          roomList.forEach((element) {
            Map<String, dynamic> result = VRUtils.JsonStringToMap(element);
            VRHouseEditBackBean bean = VRHouseEditBackBean.fromJson(result);
            String fullStr = homePlanList[widget.index ?? 0];
            String otherStr = bean?.title ?? '';
            if (otherStr.contains(fullStr)) {
              (_getBeanList(bean.index ?? 0)).add(bean);
              otherRoomTitleList.add(otherStr);
              if (widget.callBack != null) {
                widget.callBack!(result);
              }
            }
          });
          if (mounted) {
            setState(() {});
          }
        }
      });
    }

    if (Platform.isIOS) {
      capturePreviewParamsListener = BoostChannel.instance
          .addEventListener(ChannelKey.capturePreviewParams, (key, arguments) {
        Map<Object?, Object?> capturePreviewParams =
            arguments['capturePreviewParams'];
        Map<String, dynamic> result =
            VRUtils.JsonStringToMap(jsonEncode(capturePreviewParams));
        VRHouseEditBackBean bean = VRHouseEditBackBean.fromJson(result);

        ///fix - -存储当前的图片和图片地址
        String? kk = widget.houseID;

        print('获取到缓存数据 ${kk}');
        String? value = jsonEncode(capturePreviewParams);
        VRSharedPreferences().setRoomlist(kk, value).then((value2) {
          bool isSav = value2;
          print('获取到缓存数据 ${isSav ? '成功' : '失败'} ${value2}');
        });

        if (bean.title == _titleString) {
          int indx = bean.index ?? 0;
          (_getBeanList(indx)).insert(0,bean);
          if (widget.callBack != null) {
            widget.callBack!(result);
          }
          if (mounted) {
            setState(() {});
          }
        }
        Future<dynamic> init() async {}
        return init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  ScrollController _scrollController = ScrollController();
  String _titleString = '';
  String _title = '';

  Widget _buildListView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: NotificationListener(
                  onNotification: (not) {
                    double pixels = _scrollController.position.pixels;
                    if (pixels < 0) {
                      if (widget.scrollCallBack != null) {
                        widget.scrollCallBack!(pixels);
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: (roomSectionList.length + 1),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return VRHouseEditInfoTitle(
                            title: '房间拍摄',
                            type: VREditType.add,
                            onTapClick: () {
                              if (widget.title == '其他') {
                                _showAddHouse();
                                return;
                              }
                              List<VRHouseEditBackBean> listBean = [];
                              roomSectionList.insert(0, listBean);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          );
                        } else {
                          return _buildGrird(context, index - 1);
                        }
                      }),
                ))),
      ],
    );
  }

  @override
  Widget _buildGrird(BuildContext context, int itemIndex) {
    int crossAxisCount = 4;
    int num = (_getBeanList(itemIndex).length + 1);
    int colunm = (num / crossAxisCount).toInt();
    int other = (num % crossAxisCount).toInt();
    if (other > 0) {
      colunm = colunm + 1;
    } else {
      if (colunm == 0) {
        colunm = 1;
      }
    }

    ///字符串转换
    String character =
        VRHouseEditEx.getASIINum(num: (roomSectionList.length - itemIndex - 1));

    if (widget.title != '其他') {
      _title = widget.title ?? '';
    } else {
      if (otherRoomTitleList.isNotEmpty) {
        _title = otherRoomTitleList[itemIndex] ?? '其他';
      } else {
        _title = '其他';
      }
    }

    String titleString = '${_title}${character}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            titleString ?? '客厅',
            style: TextStyle(color: GlobalColor.color_222222),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: min((100 * colunm.toDouble()),
              MediaQuery.of(context).size.height - 64 - 56),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: crossAxisCount,
              //设置横向间距
              crossAxisSpacing: 10,
              //设置主轴间距
              mainAxisSpacing: 10,
            ),
            itemCount: num,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return VRHouseEditPageItem(
                  type: VRHouseItemType.add,
                  addOnTap: () {
                    _titleString = titleString;
                    ///TODO: 彬哥的跳转
                    var path = VRUserSharedInstance.instance().panoInfoPath;
                    Map<String, dynamic> parms = {
                      'position': index,
                      'index': itemIndex,
                      'path': path,
                      'title': titleString,
                      'relativeCoverPath': '',
                      'fileName': '',
                      'tempThumbnail': '',
                    };

                    BoostNavigator.instance.push(
                      RouterUrl.CAPTURE_PREVIEW,
                      arguments: {
                        'capturePreviewParams': parms,
                        'isPresent': true
                      },
                    );
                  },
                );
              }
              VRHouseEditBackBean tempBean =
                  _getBeanList(itemIndex)[(index - 1)];
              return VRHouseEditPageItem(
                type: VRHouseItemType.img,
                bean: tempBean,
                deleteOnTap: () {
                  _showAlert(itemIndex: itemIndex, tempBean: tempBean);
                },
                previewOnTap: () {
                  var title = "";
                  if (tempBean.title != null) {
                    title = tempBean.title!;
                  }

                  if (tempBean.tempThumbnail == null) {
                    return;
                  }
                  VRUtils.pathToRealPath(tempBean?.tempThumbnail ?? '')
                      .then((value) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ShowPanorama(
                          title: title,
                          filePath: value,
                        );
                      },
                    ));
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAlert({int? itemIndex, VRHouseEditBackBean? tempBean}) {
    BrnDialogManager.showConfirmDialog(context,
        title: "确认删除吗？",
        cancel: '取消',
        confirm: '确定',
        message: "请确认删除当前图片！", onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () {
      Navigator.pop(context);

      if (widget.deleteOnTap != null && tempBean != null) {
        widget.deleteOnTap!(tempBean.toJson());
      }

      VRSharedPreferences()
          .deleteRoomlist(widget.houseID, jsonEncode(tempBean));
      _getBeanList(itemIndex ?? 0).remove(tempBean);

      if (mounted) {
        setState(() {});
      }
    });
  }

  List<VRHouseEditBackBean> _getBeanList(int index) {
    if (index < roomSectionList.length && roomSectionList.isNotEmpty) {
      return roomSectionList[index];
    }
    return [];
  }

  void _showAddHouse() {
    BrnMultiDataPicker(
      context: context,
      title: '添加房间',
      delegate: VRHouseSingleDelegate(
        singleType: VRHouseSingleType.otherHouseOption,
        firstSelectedIndex: 0,
      ),
      confirmClick: (list) {
        ///获取对应的数据源信息
        List<String>? tlist =
            VRUserSharedInstance.instance().otherHomeOption!.data;
        if (tlist!.isEmpty) {
          tlist = HouseConst.roomNamesList;
        }
        _title = tlist![list.first];
        otherRoomTitleList.insert(0, _title);
        List<VRHouseEditBackBean> listBean = [];
        roomSectionList.insert(0, listBean);

        if (mounted) {
          setState(() {});
        }
      },
    ).show();
  }

  @override
  void dispose() {
    super.dispose();
    capturePreviewParamsListener?.call();
  }
}
