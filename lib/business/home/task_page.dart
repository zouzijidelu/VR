import 'dart:io';
import 'package:bruno/bruno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testt/common/request/request_url.dart';
import '../../common/common_widget/vr_keep_wrapper.dart';
import '../../common/UI/res_color.dart';
import '../../common/event_bus/vr_event_bus.dart';
import '../../common/gray_version/gray_version.dart';
import '../../common/gray_version/gray_version_widget.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../common/sharedInstance/vr_shared_preferences.dart';
import '../../utils/vr_request_utils.dart';
import 'taskPage/finish_capture.dart';
import 'taskPage/uncapture_task.dart';
import 'taskPage/unupload_capture_task.dart';
import 'task_page_search.dart';

///
/// @date:2023-05-04 16:36:16
/// @author:bill
/// @des:TAB类型案例
///
class VRTaskPage extends StatefulWidget {
  @override
  _task_pageState createState() {
    return _task_pageState();
  }
}

class _task_pageState extends State<VRTaskPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late String searchValue = '';

  VoidCallback? removeListener;

  ValueNotifier<int> changeIndexValueNotifier = ValueNotifier(0);
  ValueNotifier<int> changeNumValueNotifier = ValueNotifier(0);

  CancelToken? cancelToken;
  static String uncap =
      !(VRUserSharedInstance.instance().userModel?.jobs![0]?.jobName ==
              '实勘拍摄专员')
          ? '待拍摄'
          : '未拍摄';

  String unuploadcap = '未上传';
  static String fincap = '已上传';

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      removeListener = BoostChannel.instance
          .addEventListener(VREventName.kTabBarChange, (key, arguments) {
        int argIndex = arguments['index'];
        controller.animateTo(argIndex ?? 1);
        eventBus.fire(VREvent(VREventName.KPostSaveSuccess));
        Future<dynamic> init() async {}
        return init();
      });
    }

    //initialIndex初始选中第几个
    controller = TabController(initialIndex: 0, length: 3, vsync: this);
    controller.addListener(() {
      if (changeIndexValueNotifier.value != controller.index) {
        changeIndexValueNotifier.value = controller.index;
      }
    });

    // 监听 CustomEvent 事件，刷新 UI
    eventBus.on<VREvent>().listen((event) {
      print('${event.msg} ===  event');
      if (event.msg == VREventName.kTabBarChange) {
        controller.animateTo(event.index ?? 0);
        if (event.index == 2) {
          eventBus.fire(VREvent(VREventName.kRefreshTab2));
        }
      }
    });

    _getHttp();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statusesstorage =
        await [Permission.storage].request();
    Map<Permission, PermissionStatus> statuseslocation =
        await [Permission.location].request();
    Map<Permission, PermissionStatus> statusesnearbyWifiDevices =
        await [Permission.nearbyWifiDevices].request();
    Map<Permission, PermissionStatus> statusescamera =
        await [Permission.camera].request();

    final info = {
      'storage': statusesstorage[Permission.storage].toString(),
      'location': statuseslocation[Permission.location].toString(),
      'nearbyWifiDevices':
          statusesnearbyWifiDevices[Permission.nearbyWifiDevices].toString(),
      'camera': statusescamera[Permission.camera].toString(),
    }.toString();
    if (kDebugMode) {
      print(info);
      // _toastInfo(info);
    }
  }

  bool _isShowGray = false;

  void _getHttp() async {
    cancelToken = CancelToken();
    String url = RequestUrl.VR_MOBILE_CONFIG;
    if (Platform.isIOS) {
      url = url + '/versioniOS.json';
    } else if (Platform.isAndroid) {
      url = url + '/versionAndroid.json';
    }

    request(url);
  }

  void request(String url) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    VRDioUtil.instance?.request(url, cancelToken: cancelToken).then((value) {
      VRGrayVersionBean versionBean = VRGrayVersionBean.fromJson(value);
      bool isUp = GrayVersionWidget.showVersionView(packageInfo, versionBean);
      if (isUp) {
        if (VRUserSharedInstance.instance().isShowUpVersion == false) {
          VRUserSharedInstance.instance().isShowUpVersion = true;
        } else {
          return;
        }
        _showGrayVerson(context, versionBean);
      }
    });
  }

  void _showGrayVerson(BuildContext context, VRGrayVersionBean? versionBean) {
    if (_isShowGray == true) {
      return;
    }
    _isShowGray = true;
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      GrayVersionWidget.showGrayVerSion(context, versionBean: versionBean);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            color: GlobalColor.color_white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 40),
                ),
                Visibility(
                    visible: !(VRUserSharedInstance.instance()
                            .userModel
                            ?.jobs![0]
                            ?.jobName ==
                        '实勘拍摄专员'),
                    child: _buildSearchRow()),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5, //宽度
                        color: GlobalColor.color_F0F0F0, //边框颜色
                      ),
                    ),
                  ),
                  child: ValueListenableBuilder<int>(
                      valueListenable: changeIndexValueNotifier,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return TabBar(
                          onTap: (index) {
                            // if (index == 1) {
                            //   eventBus.fire(VREvent(VREventName.KPostSaveSuccess));
                            // }
                          },
                          controller: controller,
                          //可以和TabBarView使用同一个TabController
                          tabs: [
                            Tab(
                              child: Text(
                                uncap,
                                style: TextStyle(
                                    fontSize:
                                        (changeIndexValueNotifier.value == 0)
                                            ? 20
                                            : 16,
                                    color: (changeIndexValueNotifier.value == 0)
                                        ? Color(0xff222222)
                                        : Color(0xff9CA5BB)),
                              ),
                            ),
                            Tab(
                                child: ValueListenableBuilder<int>(
                                  valueListenable: changeNumValueNotifier,
                                  builder:
                                      (BuildContext context, int value, Widget? child) {
                                    return Text(
                                      (changeNumValueNotifier.value == 0)
                                          ? unuploadcap
                                          : '${unuploadcap}(${changeNumValueNotifier.value})',
                                      style: TextStyle(
                                          fontSize: (changeIndexValueNotifier.value == 1) ? 20 : 16,
                                          color: (changeIndexValueNotifier.value == 1)
                                              ? Color(0xff222222)
                                              : Color(0xff9CA5BB)),
                                    );
                                  },
                                )),
                            Tab(
                              child: Text(
                                fincap,
                                style: TextStyle(
                                    fontSize:
                                        (changeIndexValueNotifier.value == 2)
                                            ? 20
                                            : 16,
                                    color: (changeIndexValueNotifier.value == 2)
                                        ? Color(0xff222222)
                                        : Color(0xff9CA5BB)),
                              ),
                            )
                          ],
                          isScrollable: true,
                          indicator: const BoxDecoration(),
                        );
                      }),
                ),
                Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: TabBarView(controller: controller, children: [
                        VRKeepAliveWrapper(child: VRUncaptureTask()),
                        VRKeepAliveWrapper(child: VRUnuploadCaptureTask(
                          callback: (num) {
                            changeIndexValueNotifier.value = 1;
                            changeNumValueNotifier.value = num;
                          },
                        )),
                        VRKeepAliveWrapper(child: VRFinishCapture()),
                      ])),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final FocusNode _focusNode = FocusNode();

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: BrnSearchText(
        innerPadding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        maxHeight: 60,
        hintText: '请输入房源编号',
        innerColor: const Color(0xfff3f3f3),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        normalBorder: Border.all(
            color: const Color(0xFFF0F0F0), width: 1, style: BorderStyle.solid),
        activeBorder: Border.all(
            color: const Color(0xFFf3f3f3), width: 1, style: BorderStyle.solid),
        onTextClear: () {
          _focusNode.unfocus();
          return false;
        },
        autoFocus: false,
        // onActionTap: () {
        //   BrnToast.show('取消', context);
        // },
        onTextCommit: (text) {
          if (mounted) {
            setState(() {
              searchValue = text;
            });
          }
          VRSharedPreferences().setSearch(text);
          // BrnToast.show('提交内容 : $text', context);
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return TaskSearch(value: text);
            },
          ));
        },
        onTextChange: (text) {
          if (mounted) {
            setState(() {
              searchValue = text;
            });
          }
          // BrnToast.show('输入内容 : $text', context);
        },
      ),
    );
  }

  Widget _buildSearchRow() {
    return Container(
      color: GlobalColor.color_white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildSearchBar(), _buildButton()],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        late String text = searchValue;
        // print('点击功能使用');
        VRSharedPreferences().setSearch(text);
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return TaskSearch(value: text);
          },
        ));
      },
      child: Container(
        height: 24,
        child: const Text(
          '搜索',
          style: TextStyle(
              color: Color(0xff222222),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TabController>('controller', controller));
  }

  @override
  void deactivate() {
    if (cancelToken != null) {
      cancelToken?.cancel('dispose');
    }
    removeListener?.call();
    super.deactivate();
  }
}
