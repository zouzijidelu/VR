import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:panorama/panorama.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';
import 'package:testt/common/take_picture_screen.dart';
import 'global/global.dart';

typedef PhotoScreenCallBack = void Function(Map<String, dynamic> res);

class PhotoScreen extends StatefulWidget {
  final String title;
  final String fileUrl;
  final String delayTime;
  final PhotoScreenCallBack callBack;

  const PhotoScreen(
      {Key? key,
      required this.title,
      required this.fileUrl,
      required this.callBack,
      this.delayTime = '5秒'})
      : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    //toast
    FToast fToast = FToast();
    fToast.init(context);
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
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

  _saveImage(String fileUrl, String saveUrl) async {
    if (saveUrl.isEmpty) {
      var appDocDir = await getTemporaryDirectory();
      if (Platform.isIOS) {
        saveUrl = VRUserSharedInstance.instance().panoInfoPath ?? appDocDir.path;
        ///假设路径为空
        if (validateEmpty(VRUserSharedInstance.instance().panoInfoPath)) {
          VRUserSharedInstance.instance().panoInfoPath = appDocDir.path;
        }
      } else if (Platform.isAndroid) {
        saveUrl = appDocDir.path;
      }
      print("saveUrl.isEmpty${appDocDir.absolute}");
    }

    var fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    var relativeCoverPath =
        '/pano_original/${fileName}';

    print("relativeCoverPath = ${relativeCoverPath}");
    var tempSaveUrl = saveUrl;
    saveUrl = saveUrl + relativeCoverPath;
    final result = await Dio().download(fileUrl, saveUrl,
        onReceiveProgress: (count, total) {
      print("${(count / total * 100).toStringAsFixed(0)}%");
    });

    //EasyLoading.dismiss();
    SmartDialog.dismiss();
    //final result = await ImageGallerySaver.saveFile(savePath);
    if (kDebugMode) {
      print(result);
      // _toastInfo("$result");
    } else {}

    Map<String, dynamic> options = {
      'position': Global.position,
      'index': Global.index,
      'path': tempSaveUrl,
      'title': widget.title,
      'relativeCoverPath': relativeCoverPath,
      'fileName': fileName,
      'tempThumbnail': saveUrl,
    };
    // if(Platform.isIOS){
    //ios相关代码
    if (widget.callBack != null) {
      widget.callBack(options);
    }

    Navigator.pop(context);

    // }else if(Platform.isAndroid){
    //   //android相关代码
    //   BoostNavigator.instance.pop(options);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            child: Center(
                child: Panorama(
              child: //widget.img!=null? RawImage(image: widget.img?.image) :
                  Image.network(
                widget.fileUrl,
                color: Colors.black,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Image(
                      image: AssetImage("images/arrow-back.jpg"));
                },
              ),
            )),
          ),
          _buildSave(),
          _buildRemake(),
          Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 75,
              child: AppBar(
                title: Text(Global.title.isEmpty ? '客厅' : Global.title),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Image(
                        image: AssetImage("images/icon-navbar-return.png"),
                      ),
                      //  tooltip: 'Increase volume by 10',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Positioned(
          //   right: 30,
          //   bottom: 80,
          //   child:    Container(
          //     // margin: const EdgeInsets.only(bottom: 80,right: 20),
          //     alignment: const Alignment(-0.8, 0.8),
          //     child: ElevatedButton(
          //       child:const Text('完成'),
          //       onPressed: (){},),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildSave() {
    return GestureDetector(
      onTap: () {
        SmartDialog.showLoading(msg: '导出中 结束将返回编辑页', backDismiss: true);
        _saveImage(widget.fileUrl, Global.fileUrl);
      },
      child: Container(
        alignment: const Alignment(0, 0.8),
        child: const SizedBox(
          width: 75,
          height: 75,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 100,
            child: Icon(
              grade: 1,
              Icons.check,
              color: Colors.black,
              size: 30,
              weight: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemake() {
    return GestureDetector(
      onTap: () {
        // BoostNavigator.instance.pushReplacement(
        //   'goToTakePicturePage', //required
        //   withContainer: false, //optional
        //   arguments: Map(), //optional
        //   // opaque: true, //optional,default value is true
        // );

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return TakePictureScreen(fromMainPage: false);
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 80, left: 20),
        alignment: const Alignment(-0.8, 0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Image(image: AssetImage("images/remake.jpg")),
            SizedBox(height: 4), //保留间距10
            Text(
              "重拍",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completeBtn() {
    return GestureDetector(
      onTap: () {
        BoostNavigator.instance.pushReplacement(
          'goToTakePicturePage', //required
          withContainer: false, //optional
          arguments: Map(), //optional
          // opaque: true, //optional,default value is true
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 80, right: 20),
        alignment: const Alignment(-0.8, 0.8),
        child: ElevatedButton(
          child: const Text('完成'),
          onPressed: () {},
        ),
      ),
    );
  }
}
