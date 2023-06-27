import 'dart:convert';
import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter/services.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';
import 'package:testt/utils/time_stamp/time_stamp.dart';
import 'package:testt/utils/vr_utils.dart';

import '../../common/housecard/common_title.dart';
import '../../utils/channel/vr_boost_channel.dart';
import '../../utils/db/vr_todo_task_bean.dart';
import 'bean/vr_finish_bean.dart';
import 'taskPage/make_sure_house_info.dart';

enum VRSHouseheetEnum {
  ///更多信息
  more,

  ///确认房源信息
  makesure
}

typedef VRShowUnUploadSheetCallBack = void Function(Map value);

class VRShowUnUploadSheet {
  static showBottomModal(BuildContext context,
      {VRSHouseheetEnum? type,
      VRToDoTask? taskbean,
      VRFinishListBean? finishBean,
      VRShowUnUploadSheetCallBack? callback}) {
    Container innerContainer(IconData icon, String title, Function() action) {
      return Container(
        width: 110,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          borderRadius: BorderRadiusDirectional.all(Radius.circular(5)),
        ),
        child: GestureDetector(
          onTap: action,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF000057)),
              Text(
                title,
                style: TextStyle(),
              )
            ],
          ),
        ),
      );
    }

    String _title = (type == VRSHouseheetEnum.more) ? '更多信息' : '确认房源信息';
    bool _visible = (type == VRSHouseheetEnum.more) ? false : true;

    VRToDoTask? _tempToTask = taskbean;
    if (taskbean == null) {
      Map<String, dynamic> json =
          finishBean?.toJson() ?? Map<String, dynamic>();
      _tempToTask = VRToDoTask.fromJson(json);
    }

// 这里是showModalBottomSheet的本体，对其成员shape进行操作，可以将其改编为一个圆角弹窗
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(5))),
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                height: 400,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      VRCommonTitle(
                        title: _title,
                        closeClicked: () {
                          Navigator.pop(context);
                        },
                      ),
                      VRMakeSureHouseInfo(
                        bean: taskbean ?? _tempToTask,
                        userName: finishBean?.userName ??
                            (VRUserSharedInstance.instance()
                                    .userModel
                                    ?.userName ??
                                '--'),
                        saveDate: (taskbean != null)
                            ? VRTimeStamp()
                                .dateToString(taskbean.saveTime ?? '')
                            : finishBean?.saveDate,
                        needMosaic: (type == VRSHouseheetEnum.makesure),
                      )
                    ]),
              ),
              Visibility(
                visible: _visible,
                child: Container(
                  child: Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.red,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: BrnBottomButtonPanel(
                        mainButtonName: '确认上传',
                        mainButtonOnTap: () {
                          VChannel().getWifiName().then((value) {
                            if ((value.toString().contains('THETA'))) {
                              BrnToast.show('目前连接的是相机WIFI，请切换网络', context);
                              return;
                            }
                          });

                          if (kDebugMode) {
                            print("flutter${jsonEncode(_tempToTask)}");
                          }

                          ///-1 失败（失效） 0 没传  1成功
                          ////此处安卓需要对接一下
                          if (Platform.isAndroid) {
                            BoostNavigator.instance
                                .push("/main/upload",
                                    arguments: {
                                      "toDoTaskItem": jsonEncode(_tempToTask)
                                    },
                                    withContainer: true,
                                    opaque: true)
                                .then((value) {
                              String sValue = value.toString();
                              if (sValue.contains('-1')) {
                                // BrnToast.show('该房源已失效', context);
                                if (callback != null) {
                                  callback({'state': '-1'});
                                }
                              } else if (sValue.contains('1')) {
                                if (callback != null) {
                                  callback({'state': '1'});
                                }
                              }
                            });
                          } else if (Platform.isIOS) {
                            ///保存
                            if (callback != null) {
                              callback({});
                            }
                            // mainPicUrl
                            if (Platform.isIOS) {
                              Map<String, dynamic> taskbeanMap = taskbean!.toJson();
                              taskbeanMap.addAll({'mainPicUrl':taskbean.relativeCoverPath});
                              BoostChannel.instance.sendEventToNative(
                                  ChannelKey.uploadOBS,
                                  {"uploadOBS": jsonEncode(taskbeanMap)});
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
