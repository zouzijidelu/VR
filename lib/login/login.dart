import 'dart:io';
import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:testt/common/common_model/user_model.dart';
import 'package:testt/common/global/global.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';
import 'package:testt/utils/device_info_plus/deviceInfo_bean.dart';
import '../common/request/request_url.dart';
import 'package:testt/common/sharedInstance/vr_shared_preferences.dart';
import '../utils/device_info_plus/deviceInfo.dart';
import '../utils/vr_request_utils.dart';
import 'package:testt/business/home/home_page.dart';

class Login extends StatefulWidget {
  final bool isQuick;
  final String? hostUrl;

  const Login({super.key, this.isQuick = false, this.hostUrl});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool submitVsb = false;

  @override
  initState() {
    super.initState();

    if (true ||
        widget.hostUrl == RequestUrl.DEVHOST ||
        widget.hostUrl == RequestUrl.UATHOST) {
      WidgetsFlutterBinding.ensureInitialized();
      HttpProxy.createHttpProxy().then((value) {
        HttpOverrides.global = value;
      });
    }

    if (validateInput(widget.hostUrl)) {
      VRUserSharedInstance.instance().hosturl = widget.hostUrl;
    }

    VRDioUtil.instance;

    if (widget.isQuick == false) {
      VRSharedPreferences().getLogin().then((value) {
        VRUserModel vrUserModel = value;
        if ((vrUserModel.userId ?? 0) > 0) {
          VRUserSharedInstance.instance().userModel = vrUserModel;
          VRUserSharedInstance.instance().userId =
              vrUserModel.userId.toString();
          VRUserSharedInstance.instance().cityId =
              vrUserModel.cityId.toString();
          goToHome();
        }
      });
    }
  }

  getTime() {
    String greeting = '';
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    if (currentTime.hour >= 5 && currentTime.hour <= 10) {
      if (mounted) {
        setState(() {
          greeting = '早上好，欢迎来到 我爱我家 VR';
        });
      }
    } else if (currentTime.hour >= 11 && currentTime.hour <= 12) {
      greeting = '中午好，欢迎来到 我爱我家 VR';
    } else if (currentTime.hour >= 13 && currentTime.hour <= 18) {
      greeting = '下午好，欢迎来到 我爱我家 VR';
    } else if (currentTime.hour >= 19 || currentTime.hour <= 4) {
      greeting = '晚上好，欢迎来到 我爱我家 VR';
    }
    return greeting;
  }

  _submit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("======${packageInfo.toString()}");
    String clientFrom = 'else';
    if (Platform.isAndroid) {
      clientFrom = "Android";
    } else if (Platform.isIOS) {
      clientFrom = "IOS";
    } else {
      clientFrom = "else";
    }
    Future deviceInfo = VRDeviceInfo.deviceInfoBean;
    deviceInfo.then((deviceInfo) {
      VRDeviceInfoBean deviceInfoBean = deviceInfo;
      print('deviceInfo === ${deviceInfo}');
      var params = {
        'username': userName,
        'password': password,
        'cityId': '1',
        "phoneType": deviceInfoBean.brand ?? '',
        'clientVersion': packageInfo.version,
        'clientFrom': clientFrom
      };
      VRDioUtil.instance
          ?.request(RequestUrl.VR_LOGIN, data: params, method: DioMethod.post)
          .then((value) {
        if (value.runtimeType.toString() == '_Map<String, dynamic>') {
          VRUserModel vrUserModel = VRUserModel.fromJson(value);
          VRUserSharedInstance.instance().userModel = vrUserModel;
          VRUserSharedInstance.instance().userId =
              vrUserModel.userId.toString();
          VRUserSharedInstance.instance().cityId =
              vrUserModel.cityId.toString();
          VRSharedPreferences().setLogin(vrUserModel);
          if (mounted) {
            setState(() {
              submitVsb = false;
            });
          }
          goToHome(); // goToHome();
        } else {
          if (mounted) {
            setState(() {
              submitVsb = false;
            });
          }
        }
      });
    });
  }

  void goToHome() {
    // Navigator.push(context, 'HomePage');
    // Navigator.pushReplacementNamed(context, '');
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => VRHomePage()));
  }

  void fastlogin({required int type}) {
    if (type == 1) {
      if (!mounted) return;
      setState(() {
        submitVsb = true;
        userName = '701047';
        password = '1q2w3e4r';
      });
    } else if (type == 2) {
      if (!mounted) return;
      setState(() {
        submitVsb = true;
        userName = '515154';
        password = '1q2w3e4r';
      });
    }

    _submit();
  }

  late String userName = '';
  late String password = '';
  late bool pwObscureText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              image: AssetImage('assets/images/login/loginBg.png'),
              fit: BoxFit.cover,
              // alignment: Alignment.topCenter, // 将图片放在顶部
            ),
          ),
          child: Padding(
            // padding: const EdgeInsets.fromLTRB(32, 199, 32, 199),
            padding: const EdgeInsets.only(top: 199, left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 192,
                  child: Text(
                    getTime(),
                    style:
                        const TextStyle(fontSize: 24, color: Color(0xff333333)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: TextField(
                    style: const TextStyle(color: Color(0xff222222)),
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF0F0F0)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF0F0F0)),
                      ),
                      hintText: '请输入员工ID', // 提示文字
                      // border: InputBorder.none // 输入框边框样式
                    ),
                    onChanged: (value) {
                      // 输入框文本发生变化时的回调事件
                      if (mounted) {
                        setState(() {
                          userName = value;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    style: const TextStyle(color: Color(0xff222222)),
                    obscureText: pwObscureText,
                    decoration: InputDecoration(
                        // labelText: 'Password', // 标签文字
                        hintText: '请输入密码', // 提示文字
                        // border: InputBorder.none,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF0F0F0)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF0F0F0)),
                        ),
                        suffixIcon: SizedBox(
                          width: 16,
                          height: 16,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: InkWell(
                                child: Image(
                                    width: 16,
                                    height: 16,
                                    image: AssetImage(!pwObscureText
                                        ? 'assets/images/login/iconPreview.png'
                                        : 'assets/images/login/iconPreviewNo.png')),
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      pwObscureText = !pwObscureText;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        )

                        // 输入框边框样式
                        ),
                    // obscureText: pwObscureText, // 设置为密码框
                    onChanged: (value) {
                      // 输入框文本发生变化时的回调事件
                      if (mounted) {
                        setState(() {
                          password = value;
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: submitVsb,
                  child: const BrnPageLoading(
                    content: '登录中...',
                  ),
                ),
                if (true)
                  TextButton(
                      onPressed: () => fastlogin(type: 1),
                      child: const Text('摄影师快速登录')),
                if (true)
                  TextButton(
                      onPressed: () => fastlogin(type: 2),
                      child: const Text('经纪人快速登录')),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        if ((!password.isNotEmpty && userName.isNotEmpty)) {
                          BrnToast.show('员工ID，密码不能为空', context);
                          return;
                        }
                        if (mounted) {
                          setState(() {
                            submitVsb = true;
                            _submit();
                          });
                        }
                      },
                      child: Container(
                        width: 327,
                        height: 48,
                        // style:TextStyle(color: Colors.black),
                        decoration: BoxDecoration(
                          color: (password.isNotEmpty) && (userName.isNotEmpty)
                              ? const Color(0xFF4849E0)
                              : const Color(0xFFC0CDFF),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        // color: const  Color(0xFF4849E0),
                        child: const Center(
                          child: Text(
                            '登  录',
                            style: TextStyle(
                                color: Color(0xffffffff), fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
