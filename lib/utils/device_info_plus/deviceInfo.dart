import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'deviceInfo_bean.dart';

class VRDeviceInfo{
  ///获取设备信息
  static get deviceInfo async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isIOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
    } else {
      androidInfo = await deviceInfoPlugin.androidInfo;
    }
    deviceData = _readDeviceInfo(androidInfo, iosInfo);
    return deviceData;
  }

  static get deviceInfoBean async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isIOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
    } else {
      androidInfo = await deviceInfoPlugin.androidInfo;
    }
    deviceData = _readDeviceInfo(androidInfo, iosInfo);
    return VRDeviceInfoBean.fromJson(deviceData);
  }

  static _readDeviceInfo(
      AndroidDeviceInfo? androidInfo, IosDeviceInfo? iosInfo) {
    Map<String, dynamic> data = <String, dynamic>{
      //手机品牌加型号
      "brand": Platform.isIOS
          ? iosInfo?.name
          : "${androidInfo?.brand} ${androidInfo?.model}",
      //当前系统版本
      "systemVersion": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.release,
      //系统名称
      "Platform": Platform.isIOS ? iosInfo?.systemName : "Android",
      //是不是物理设备
      "isPhysicalDevice": Platform.isIOS
          ? iosInfo?.isPhysicalDevice
          : androidInfo?.isPhysicalDevice,
      //用户唯一识别码
      "uuid": Platform.isIOS
          ? iosInfo?.identifierForVendor
          : androidInfo?.isPhysicalDevice,
      //手机具体的固件型号/Ui版本
      "incremental": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.incremental,
    };
    return data;
  }

}


// {
// "brand":"",
// "systemVersion":"",
// "Platform":"",
// "isPhysicalDevice":"",
// "uuid":"",
// "incremental":""
// }