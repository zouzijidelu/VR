import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

const iOSPlatform = const MethodChannel("aijiaplugin");
const AndroidPlatform = const MethodChannel("com.5i5j.VRAndroid");

class ChannelKey {
  ///发送消息
  ///配对手机
  static const pauseARKit = 'pauseARKit';

  ///配对手机
  static const openARKit = 'openARKit';

  ///接收消息
  static const trackingStateChange = 'trackingStateChange';

  static const requestCompletion = 'requestCompletion';

  ///接收消息 - 获取存储的文件夹地址
  static const panoInfoPath = 'panoInfoPath';

  ///上传文件信息
  static const uploadOBS = 'uploadOBS';

  ///拍照完成返回信息
  static const capturePreviewParams = 'capturePreviewParams';

  static const get360CameraStatus = 'get360CameraStatus';

  static const getPhoneCameraStatus = 'getPhoneCameraStatus';

  ///channle 名字
  static const getWifiName = 'getWifiName';

  ///channle 名字
  static const vobsupload = 'uploadHouseImage';
}

class VChannel {
  ///获取wifi名字
  Future<String> getWifiName() async {
    var platform = iOSPlatform; //获取native 渠道
    if (Platform.isAndroid) {
      platform = AndroidPlatform;
    } else if (Platform.isIOS) {
      platform = iOSPlatform; //分析1
    }

    String result = '';
    try {
      result = await platform.invokeMethod(ChannelKey.getWifiName);
      print('wifi name $result .');
    } on PlatformException catch (e) {
      print("wifi name error'${e.message} ' .");
    }
    return result;
  }

  ///获取wifi名字
  Future<String> obsUpload(Map localParms) async {
    var platform = iOSPlatform; //获取native 渠道
    if (Platform.isAndroid) {
      platform = AndroidPlatform;
    } else if (Platform.isIOS) {
      platform = iOSPlatform; //分析1
    }

    // arguments
    String result = '';
    Map parms = localParms ?? Map();
    // localPath: String, inputPath: String,
    try {
      result = await platform.invokeMethod(ChannelKey.vobsupload,parms);
      print('localPath name $result .');
      
      Fluttertoast.showToast(
          msg: '文件上传成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    } on PlatformException catch (e) {
      print("localPath name error'${e.message} ' .");

      Fluttertoast.showToast(
          msg: '文件上传失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return result;
  }
}
