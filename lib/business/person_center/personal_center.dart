import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:testt/business/person_center/person_bullet_Box.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:testt/login/login.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';

import '../../common/sharedInstance/userInstance.dart';

class PersonalCenter extends StatefulWidget {
  const PersonalCenter({super.key});

  @override
  State<PersonalCenter> createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  bool isShows = false;
  bool seeFile = false;
  bool seeSetting = false;

  // VRUserSharedInstance().userModel?.userName?.toString()??'',

  final _thetaClientFlutter = ThetaClientFlutter();
  bool _isInitTheta = false;
  bool _initializing = false;
  final String endpoint = 'http://192.168.1.1:80/';

  changeIsShow() {
    isShows = false;
    if (!mounted) return;
    setState(() {});
  }

  changSeeFile() {
    if (!mounted) return;
    setState(() {
      seeFile = false;
    });
  }

  // 相机设置返回函数
  changeseeSetting(selectedValue) {
    seeSetting = false;
    print(selectedValue);
    var config = ThetaConfig();
    if (selectedValue['selectedValue'].contains('高')) {
      config.shutterVolume = 100;
    } else if (selectedValue['selectedValue'].contains('中')) {
      config.shutterVolume = 50;
    } else if (selectedValue['selectedValue'].contains('低')) {
      config.shutterVolume = 10;
    }
    initTheta(config);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> initTheta(config) async {
    if (_initializing) {
      return;
    }
    bool isInitTheta;

    try {
      //isInitTheta = await _thetaClientFlutter.isInitialized();
      //if (!isInitTheta) {
      _initializing = true;
      await _thetaClientFlutter.initialize(endpoint, config);
      isInitTheta = true;
      BrnToast.show('设置音量成功 请重启设备', context);
      //}
    } on PlatformException catch (err) {
      if (!mounted) return;
      debugPrint('Error. init');
      BrnToast.show('未检测到相机', context);
      isInitTheta = false;
    } finally {
      _initializing = false;
    }

    if (!mounted) return;

    if (mounted) {
      setState(() {
        _isInitTheta = isInitTheta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mine_slices/background.png'),
                alignment: Alignment.topCenter, // 将图片放在顶部
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: SizedBox(
                            child: Image(
                                image: AssetImage(VRUserSharedInstance
                                                .instance()
                                            .userModel
                                            ?.gender
                                            ?.toString() ==
                                        '1'
                                    ? 'assets/images/mine_slices/headSculpture.png'
                                    : 'assets/images/mine_slices/headSculpture_woman.png')),
                          ),
                          onPressed: () {
                            goToLogin();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: SizedBox(
                          height: 64,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  VRUserSharedInstance.instance()
                                          .userModel
                                          ?.userName
                                          ?.toString() ??
                                      '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Color(0xff323233))),
                              Text(
                                VRUserSharedInstance.instance()
                                        .userModel
                                        ?.corpName
                                        ?.toString() ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xff999999)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 57),
                    child: Column(
                      children: [
                        // ListTile(
                        //   title: const Text('缓存设置 ' ' (133.34M)'),
                        //   leading: Image.asset(
                        //       'assets/images/mine_slices/' 'cache.png'),
                        //   trailing: Image.asset(
                        //       'assets/images/mine_slices/' 'icon_top.png'),
                        //   onTap: () {
                        //     print('缓存');
                        //   },
                        // ),
                        ListTile(
                          title: const Text('相机设置',
                              style: TextStyle(
                                  color: Color(0xFF323233), fontSize: 14)),
                          leading: Image.asset(
                              'assets/images/mine_slices/' 'camera.png'),
                          trailing: Image.asset(
                              'assets/images/mine_slices/' 'icon_top.png'),
                          onTap: () {
                            if (!mounted) return;

                            setState(() {
                              seeSetting = true;
                            });
                          },
                        ),
                        // ListTile(
                        //   title: const Text(
                        //     '铃声测试',
                        //     style: TextStyle(
                        //         color: Color(0xFF323233), fontSize: 14),
                        //   ),
                        //   leading: Image.asset(
                        //       'assets/images/mine_slices/' 'ringingTone.png'),
                        //   onTap: () {
                        //     playLocalFinish();
                        //     print('缓存');
                        //   },
                        // ),
                        ListTile(
                          enabled: true,
                          title: const Text('查看二维码',
                              style: TextStyle(
                                  color: Color(0xFF323233), fontSize: 14)),
                          leading: Image.asset(
                              'assets/images/mine_slices/' 'rqCode.png'),
                          trailing: Image.asset(
                              'assets/images/mine_slices/' 'icon_top.png'),
                          onTap: () {
                            if (!mounted) return;
                            setState(() {
                              isShows = true;
                              print('123');
                            });
                          },
                        ),
                        // ListTile(
                        //   title: const Text('拍摄文档',
                        //       style: TextStyle(
                        //           color: Color(0xFF323233), fontSize: 14)),
                        //   leading: Image.asset(
                        //       'assets/images/mine_slices/' 'file.png'),
                        //   trailing: Image.asset(
                        //       'assets/images/mine_slices/' 'icon_top.png'),
                        //   onTap: () {
                        //     setState(() {
                        //       seeFile = true;
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Visibility(
            visible: isShows,
            child: BulletBox(
              isShow: isShows,
              isShowChange: (selectedValue) => changeIsShow(),
            )),
        Visibility(
            visible: seeFile,
            child: BulletBox(
              isShow: seeFile,
              isShowChange: (selectedValue) => changSeeFile(),
              bulltype: 'file',
            )),
        Visibility(
            visible: seeSetting,
            child: BulletBox(
              isShow: seeSetting,
              isShowChange: (selectedValue) => changeseeSetting(selectedValue),
              bulltype: 'cameraSetting',
            ))
      ],
    );
  }

  void goToLogin() {
    VRUserSharedInstance.instance().userId = null;
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => const Login(
                isQuick: true,
              )),
    );
  }
}
