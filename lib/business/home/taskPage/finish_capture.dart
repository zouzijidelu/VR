import 'dart:core';
import 'package:bruno/bruno.dart';
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:testt/business/home/taskPage/unupload_capture_task.dart';
import '../../../common/UI/res_color.dart';
import '../../../common/event_bus/vr_event_bus.dart';
import '../../../common/global/global.dart';
import '../../../common/global/global_theme.dart';
import '../../../common/housecard/house_card.dart';
import '../../../common/image_picker/pages/splash_page.dart';
import '../../../common/request/request_url.dart';
import '../../../common/sharedInstance/userInstance.dart';
import '../../../generated/assets.dart';
import '../../../utils/vr_request_utils.dart';
import '../../input_house/house_const.dart';
import '../bean/vr_finish_bean.dart';
import '../bean/vr_progress_bean.dart';
import '../vr_show_unupload_sheet.dart';

///
/// @date:2023-05-05 11:31:08
/// @author:bill
/// @des:${des}
///

class VRFinishCapture extends StatefulWidget {
  VRFinishCapture();

  @override
  _finish_captureState createState() => _finish_captureState();
}

class _finish_captureState extends State<VRFinishCapture> {
  late EasyRefreshController _controller;

  CancelToken? cancelToken;

  @override
  void initState() {
    request();
    super.initState();
    _controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);

    // 监听 CustomEvent 事件，刷新 UI
    eventBus.on<VREvent>().listen((event) {
      if (event.msg == VREventName.kRefreshTab2) {
        request();
      }
    });
  }

  VRFinishList? _vrFinishList;

  List<VRFinishListBean>? _taskList = [];

  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    return _buildEmptyWidget();
  }

  late Widget listWidget;

  Widget _buildEmptyWidget() {
    return Column(
      children: [
        Expanded(
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
        ),
      ],
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
                enablePageTap: true,
                isCenterVertical: true,
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
              if ((_taskList?.length ?? 0) >= (_vrFinishList?.listCount ?? 0) &&
                  (_taskList?.length != 0)) {
                _controller.finishLoad(IndicatorResult.noMore);
              }
            } else {
              _controller.finishLoad(IndicatorResult.none);
            }
          });
        },
        child: ListView.builder(
            itemCount: _taskList?.length ?? 0,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              return _buildHouseCard(bean: _taskList?[index]);
            }),
      );
    }
    return Column(
      children: [
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: listWidget,
          ),
        ),
      ],
    );
  }

  int page = 1;

  void request() {
    cancelToken = CancelToken();
    if (page != 1) {
      if ((_taskList?.length ?? 0) >= (_vrFinishList?.listCount ?? 0)) {
        return;
      }
    }
    Map<String, dynamic> params = {
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'page': page,
      'pageSize': '10'
    };

    VRDioUtil.instance
        ?.request(RequestUrl.VR_UPLOADEDTASKLIST, params: params)
        .then((value) {
      VRFinishList vrFinishList = VRFinishList.fromJson(value);
      _vrFinishList = vrFinishList;
      var beannumberlength = _vrFinishList?.list?.length ?? 0;
      if (page == 1) {
        _taskList = [];
      }
      if (beannumberlength > 0) {
        List<VRFinishListBean>? list2 = _vrFinishList?.list;
        list2?.forEach((e) {
          _taskList?.add(e);
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _quickRequest({VRFinishListBean? bean}) {
    Map<String, dynamic> params = {
      'taskId': bean?.taskId ?? '',
    };
    VRDioUtil.instance
        ?.request(RequestUrl.VR_VRMODELPROGRESS, params: params)
        .then((value) {
      VRModelProgress vrModelProgress = VRModelProgress.fromJson(value);

      BrnDialogManager.showSingleButtonDialog(context,
          label: "确定",
          title: '${vrModelProgress.processText ?? '已帮您催进度啦～'}',
          warning: '',
          message: '', onTap: () {
        Navigator.pop(context);
      });
    });
  }

  Widget _buildHouseCard({VRFinishListBean? bean}) {
    return Container(
      color: GlobalColor.color_white,
      child: VRHouseCard(
        imageURL: bean?.mainPicUrl,
        title:
            '${HouseConst.houseTypeString(type: '${bean?.houseType ?? '1'}')}/${bean?.houseTitle ?? ''}${bean?.communityName ?? ''}',
        houseId: bean?.houseId,
        listType: VRHouseTListype.finish,
        bottomSource: [
          // VRHouseCardType.upload,
          VRHouseCardType.quick,
          VRHouseCardType.more
        ],
        moreClicked: () {
          VRShowUnUploadSheet.showBottomModal(context,
              type: VRSHouseheetEnum.more, finishBean: bean);
        },
        statusTag: HouseConst.makeCaptureString(bean?.status ?? 0),
        detail: bean?.roomInfo ?? '--',
        uploadClicked: () {
          Global.inputFlies = bean?.inputFlies ?? '';
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return SplashPage();
            },
          ));
        },
        itemClicked: () {
          // goToWebView(bean?.vrModelUrl);
          // 正在制作，不可查看
          if (bean?.status == 1) {
            BrnToast.show('正在制作，不可查看', context);
          } else if (bean?.status == 2) {

          } else {
            BrnToast.show('制作失败，不可查看', context);
          }
        },
        quickClicked: () {
          _quickRequest(bean: bean);
        },
      ),
    );
  }

  void goToWebView(String? url) {
    if (url != null) {
      BoostNavigator.instance.push(
        '/web/common', //required
        withContainer: true, //optional
        arguments: {"url": url}, //optional
        opaque: true, //optional,default value is true
      );
    } else {
      BrnToast.show("数据为空", context);
    }
  }

  @override
  void deactivate() {
    if (cancelToken != null) {
      cancelToken?.cancel('dispose');
    }
    super.deactivate();
  }
}
