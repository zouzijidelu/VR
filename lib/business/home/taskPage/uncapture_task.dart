import 'dart:core';
import 'package:bruno/bruno.dart';
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import '../../../common/UI/res_color.dart';
import '../../../common/global/global_theme.dart';
import '../../../common/housecard/house_card.dart';
import '../../../common/housecard/photographer_house_card.dart';
import '../../../common/request/request_url.dart';
import '../../../common/sharedInstance/userInstance.dart';
import '../../../generated/assets.dart';
import '../../../utils/vr_request_utils.dart';
import '../../input_house/house_const.dart';
import '../../input_house/input_house.dart';
import '../bean/vr_need_task_bean.dart';
import '../bean/vr_other_home_bean.dart';
import '../task_page_bullet_box.dart';
import 'dart:ui';

///
/// @date:2023-05-05 11:31:08
/// @author:bill
/// @des:${des}
///
///

class VRUncaptureTask extends StatefulWidget {
  VRUncaptureTask();

  @override
  _uncapture_taskState createState() => _uncapture_taskState();
}

class _uncapture_taskState extends State<VRUncaptureTask> {
  @override
  List<ItemEntity> items = [];
  late int houseRange = 4;
  late List roomNum = [];
  late List houseArea = [];
  late String houseRangeName = '我的店组';
  VRNeedTaskBean? _vrNeedTaskBean;
  List<VRNeedTaskListBean>? _taskList = [];
  late Map<String, dynamic> dataList = {};

  late EasyRefreshController _controller;

  CancelToken? cancelToken;

  void initState() {

    super.initState();
    cancelToken = CancelToken();

    page = 1;
    request();

    _controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    _requestConfig();
  }

  int page = 1;

  void request() {
    Map<String, dynamic> params = {
      'dateType': 3,
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'page': page,
      'pageSize': '10',
    };

    /// role 1 摄影师  2经纪人
    String? url = RequestUrl.VR_NEED_TAKEPHOTO_LIST;
    if ((VRUserSharedInstance.instance().userModel?.role == 2)) {
      url = RequestUrl.VR_UNFILMEDHOUSE;
      params = {
        'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
        'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
        'page': page,
        'pageSize': '10',
        'houseRange': '1'
      };

      params['houseRange'] = houseRange;
      params['roomNum'] = roomNum.isNotEmpty ? roomNum.join(",") : '';
      params['houseArea'] = houseArea.isNotEmpty ? houseArea.join(",") : '';
      // }
    }

    VRDioUtil.instance?.request(url, params: params,cancelToken: cancelToken).then((value) {
      VRNeedTaskBean vrUploadTaskBean = VRNeedTaskBean.fromJson(value);
      _vrNeedTaskBean = vrUploadTaskBean;
      var beannumberlength = _vrNeedTaskBean?.list?.length ?? 0;
      if (page == 1) {
        _taskList = [];
      }

      if (beannumberlength > 0) {
        List<VRNeedTaskListBean>? list2 = _vrNeedTaskBean?.list;
        list2?.forEach((e) {
          _taskList?.add(e);
        });
      }
      if (mounted) {
        setState(() {
        });
      }
    });
  }

  void _requestConfig() {
    VRDioUtil.instance
        ?.request(RequestUrl.VR_OTHERHOMEOPTION, params: {}, showAllData: true,cancelToken: cancelToken)
        .then((value) {
      VROtherHomeOption vrOtherHomeOption = VROtherHomeOption.fromJson(value);
      VRUserSharedInstance.instance().otherHomeOption = vrOtherHomeOption;
    });
  }

  hide() {
    if (mounted) {
      setState(() {
        isShow = false;
      });
    }
  }

  late int action_nav = 1;
  late bool isShow = false;
  bool _isLoad = false;
  String text = '';

  late BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Stack(
      children: [
        Column(
          children: [
            Visibility(
                visible: !(VRUserSharedInstance.instance()
                        .userModel
                        ?.jobs![0]
                        ?.jobName ==
                    '实勘拍摄专员'),
                child:_select(),
                 ),
            _buildEmptyWidget(),
          ],
        ),
        Visibility(
            visible: isShow,
            child: TaskBulletBox(
                hideFunc: () => hide(),
                isShowChange: (value) => isShowChange(value),
                isShow: isShow,
                actionNav: action_nav,
                houseRange: houseRange,
                roomNum: roomNum,
                houseArea: houseArea,
                houseRangeName: houseRangeName)),
        Positioned(
          bottom: 40,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return VRInputHouse(type: VRInputHouseEnum.edit);
                },
              ));
            },
            child: Container(
              width: 100,
              height: 40,
              child: Center(
                child: Text(
                  '添加房源',
                  style: TextStyle(
                      color: GlobalColor.color_mainColor,
                      fontWeight: GlobalFontWeight.font_medium,
                      fontSize: 14),
                ),
              ),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 阴影的颜色
                      offset: Offset(0, 1), // 阴影与容器的距离
                      blurRadius: 4, // 高斯的标准偏差与盒子的形状卷积。
                      spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
                    ),
                  ],
                  color: GlobalColor.color_white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
            ),
          ),
        )
      ],
    );
  }

  Widget _select() {
    List<Map<String, dynamic>> arr = [
      {'title': '$houseRangeName ', 'id': 1},
      {'title': '房型 ', 'id': 2}
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < arr.length; i++)
            GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // border: Border(
                    //   top: BorderSide(
                    //     width: 0.5, //宽度
                    //     color: Color(0xFFF0F0F0), //边框颜色
                    //   ),
                    // ),
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          arr[i]['title'],
                          style: const TextStyle(
                              color: Color(0xFF222222), fontSize: 14),
                        ),
                        const Image(
                            width: 6,
                            height: 6,
                            image: AssetImage('assets/icons/icon-bottom.png'))
                      ]),
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      print(isShow);
                      isShow = true;
                      action_nav = arr[i]['id'];
                    });
                  }
                })
        ],
      ),
    );
  }

  void isShowChange(value) {
    print('进入');

    if (mounted) {
      setState(() {
        page = 1;
        isShow = false;
        roomNum = value['roomNum'];
        houseArea = value['houseArea'];
        houseRange = value['houseRange'];
        houseRange = value['houseRange'];
        houseRangeName = value['houseRangeName'];
      });
    }
    page = 1;
    request();
  }

  late Widget listWidget;

  Widget _buildEmptyWidget() {
    return Expanded(
      flex: 1,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Listener(
            onPointerDown: (p) {
              if (!mounted) return;
              setState(() {
                _isLoad = true;
              });
            },
            child: _easyRefresh()),
      ),
    );
  }

  Widget _easyRefresh() {
    if (_taskList?.length == 0) {
      listWidget = EasyRefresh(
        header: GlobalTheme().classicHeader,
        footer: GlobalTheme().classicFooter,
        onRefresh: () async {
          page = 1;
          request();
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
    } else {
      listWidget = EasyRefresh(
          header: GlobalTheme().classicHeader,
          footer: GlobalTheme().classicFooter,
          onRefresh: () async {
            page = 1;
            request();
            _controller.finishRefresh(IndicatorResult.success);
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 0), () {
              if (_isLoad) {
                _isLoad = false;
                if (mounted) {
                  setState(() {
                    page += 1;
                  });
                }
                request();
                if ((_taskList?.length ?? 0) >=
                        (_vrNeedTaskBean?.listCount ?? 0) &&
                    (_taskList?.length != 0)) {
                  _controller.finishLoad(IndicatorResult.noMore);
                }
              } else {
                _controller.finishLoad(IndicatorResult.none);
              }
            });
          },
          child: Stack(
            children: [
              Visibility(
                  visible: !(VRUserSharedInstance.instance()
                      .userModel
                      ?.jobs![0]
                      ?.jobName ==
                      '实勘拍摄专员'),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xfff8f8f8),
                        height: 10,
                      )
                    ],
                  )),
              ListView.builder(
                  itemCount: _taskList?.length ?? 0,
                  addRepaintBoundaries: false,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    return _buildHouseCard(bean: _taskList?[index]);
                  }),
            ],
          ));
    }
    return listWidget;
  }

//此处修改为不显示isFooter
  void loadingBottomControl() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
      });
    });
  }

  Widget _buildHouseCard({VRNeedTaskListBean? bean}) {
    /// role 1 摄影师  2经纪人
    ///

    if ((VRUserSharedInstance.instance().userModel?.role == 1)) {
      return PhotographerVRHouseCard(
        imageURL: '',
        title:
            '${HouseConst.houseTypeString(type: '${bean?.houseType ?? '1'}')}/${bean?.houseTitle ?? '${bean?.communityName ?? ''}'}',
        detail: bean?.roomInfo,
        bean: bean,
        itemClicked: () {
          bean?.doorFaceName = null;
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return VRInputHouse(
                type: VRInputHouseEnum.uncapture,
                taskListBean: bean,
              );
            },
          ));
        },
      );
    }

    return Container(
      child: VRHouseCard(
        imageURL: '',
        title:
            '${HouseConst.houseTypeString(type: '${bean?.houseType ?? '1'}')}/${bean?.houseTitle ?? '${bean?.communityName ?? ''}'}',
        detail: bean?.roomInfo,
        houseId: bean?.houseId,
        listType: VRHouseTListype.uncap,
        itemClicked: () {
          bean?.doorFaceName = null;
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return VRInputHouse(
                type: VRInputHouseEnum.uncapture,
                taskListBean: bean,
              );
            },
          ));
        },
      ),
    );
  }
  @override
  void deactivate() {
    if (cancelToken != null) {
      cancelToken?.cancel('dispose');
    }
    super.deactivate();
  }
}
