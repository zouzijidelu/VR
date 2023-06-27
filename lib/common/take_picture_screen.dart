import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testt/common/photo_screen.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

import 'bean/house_edit_back_bean.dart';
import 'global/global.dart';
import 'package:image/image.dart' as imageUtils;

const String assetName = 'images/start_capture.svg';
final Widget svg = SvgPicture.asset(assetName,
    width: 64,
    height: 64,
    // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
    semanticsLabel: 'Acme Logo');

class TakePictureScreen extends StatefulWidget {
  final bool fromMainPage;

  final String? titleStr;
  final PhotoScreenCallBack? callBack;
  final List<VRHouseEditBackBean>? beanList;

  const TakePictureScreen({
    Key? key,
    required this.fromMainPage,
    this.titleStr,
    this.callBack,
    this.beanList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TakePictureScreen();
  }
}

class _TakePictureScreen extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  String _platformVersion = 'Unknown';
  final _thetaClientFlutter = ThetaClientFlutter();
  bool _isInitTheta = false;
  bool _initializing = false;
  bool setTimeFlage = true;
  final String endpoint = 'http://192.168.1.1:80/';

  Uint8List frameData = Uint8List(0);
  bool previewing = false;
  bool shooting = false;
  PhotoCaptureBuilder? builder;
  PhotoCapture? photoCapture;

  // 用来在布局中显示相应的剩余时间
  int remainTime = 0;
  Timer? _timer = null;
  AudioPlayer player = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;

  //倒计时
  void startCountDown(int time) {
    // 重新计时的时候要把之前的清除掉
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
        _timer = null;
      }
    }
    setState(() {
      setTimeFlage = false;
    });
    if (time <= 0) {
      setState(() {
        setTimeFlage = true;
      });
      return;
    }

    playLocalStart();
    var countTime = time;
    const repeatPeriod = const Duration(seconds: 1);
    setState(() {
      remainTime = countTime;
    });
    _timer = Timer.periodic(repeatPeriod, (timer) {
      if (countTime <= 0) {
        timer.cancel();
        //  timer = null;
        //倒计时结束，可以在这里做相应的操作
        takePicture();
        return;
      }

      countTime--;
      {
        if (countTime == 3) {
          play3();
        }
        if (countTime == 2) {
          play2();
        }
        if (countTime == 1) {
          play1();
        }
        //倒计时判断
      }
      setState(() {
        remainTime = countTime;
      });
    });
  }

  Future playLocalStart() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/shooting_start.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(assetSource);
    play.release();
  }

  Future play3() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/3.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(assetSource);
    play.release();
  }

  Future play2() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/2.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(assetSource);
    play.release();
  }

  Future play1() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/1.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(assetSource);
    play.release();
  }

  Future playLocalFinish() async {
    AudioCache player = AudioCache();
    AssetSource assetSource = AssetSource('sounds/shooting_finish.mp3');
    AudioPlayer play = AudioPlayer();
    play.audioCache = player;
    play.play(
      assetSource,
    );
    play.release();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
        _timer = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initTheta(widget.fromMainPage);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _thetaClientFlutter.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initTheta(bool fromMainPage) async {
    if (_initializing) {
      return;
    }
    bool isInitTheta;
    try {
      isInitTheta = await _thetaClientFlutter.isInitialized();
      if (!isInitTheta) {
        _initializing = true;
        debugPrint('start initialize');
        await _thetaClientFlutter.initialize(endpoint);
        isInitTheta = true;
      }
    } on PlatformException catch (err) {
      if (!mounted) return;
      debugPrint('Error. init' + err.message.toString());
      isInitTheta = false;
    } finally {
      _initializing = false;
    }
    if (!mounted) return;
    if (isInitTheta) {
      initialize();
    } else {
      // MessageBox.show(context, '连接异常', () {
      //   BoostNavigator.instance.pop();
      // });
    }
    setState(() {
      _isInitTheta = isInitTheta;
    });
  }

  @override
  void deactivate() {
    WidgetsBinding.instance.removeObserver(this);
    stopLivePreview();
    super.deactivate();
    debugPrint('close TakePicture');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      default:
        break;
    }
  }

  void onResume() {
    debugPrint('onResume');
    _thetaClientFlutter.isInitialized().then((isInit) {
      //_toastInfo("onResume1" + isInit.toString());
      if (isInit) {
        //  startLivePreview();
      }
    });
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_SHORT);
  }

  void onPause() {
    debugPrint('onPause');
    stopLivePreview();
  }

  List timeList = ['5秒', '10秒', '15秒'];
  String delayTime = '5秒';
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.titleStr ?? '客厅'),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: const SizedBox(
                width: 20,
                height: 20,
                child: Image(
                  image: AssetImage("images/arrow-back.jpg"),
                ),
              ),
              //  tooltip: 'Increase volume by 10',
              onPressed: () {
                backScreen();
              },
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                if (setTimeFlage) {
                  setState(() {
                    _visible = !_visible;
                  });
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/kong_stopwatc.png'),
                        fit: BoxFit.cover)),
                child: Center(
                  heightFactor: 1,
                  child: Text(
                    delayTime.substring(0, delayTime.length - 1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xffffffff), fontSize: 12, height: 1.7),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          //fit: StackFit.expand,
          children: [
            Container(
              alignment: const Alignment(0, 0),
              color: Colors.black,
              child: Panorama(
                child:
                    _buildImage(), //:Image(image: AssetImage("images/arrow-back.jpg")),
              ),
            ),
            SizedBox(
              //底部背景遮挡
              height: 191,
              child: Container(
                color: Colors.black,
              ),
            ),
            //倒计时
            _buildTime(),
            GestureDetector(
              onTap: () {
                if (shooting || remainTime > 0) {
                  debugPrint(
                      'already shooting1 shooting${shooting}remainTime$remainTime');
                  return;
                }
                startCountDown(
                    int.parse(delayTime.substring(0, delayTime.length - 1)));
                //takePicture();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 29),
                // width: 35,
                // height: 35.0,
                alignment: const Alignment(0, 1),
                child: svg,
              ),
            ),
            //选择倒计时
            // _buildWatch(),
            //提示
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff4849E0),
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(
                bottom: 148,
              ),
              padding: const EdgeInsets.only(
                top: 1,
                bottom: 1,
                right: 16,
                left: 16,
              ),
              child: const Text(
                "请保持设备稳定",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
                top: 10,
                // child:  Center(
                child: Visibility(
                  visible: _visible,
                  child:
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 60,
                      //   // color: Colors.black,
                      //   decoration: const  BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomLeft,
                      //       colors: [Colors.black, Color(0xffcccccc)],
                      //       stops: [0.75, 0.25], // 前一块是黑色，后一块是灰色
                      //     ),
                      //   ),
                      //   child:
                      Center(
                    child: Container(
                        width: 340,
                        height: 48,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/blurBackground.png'),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 65, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Image.asset(
                                        'assets/images/circular.png'),
                                  ),
                                  const Center(
                                    widthFactor: 48 / 30,
                                    heightFactor: 48 / 30,
                                    child: Image(
                                        width: 30,
                                        height: 30,
                                        image: AssetImage(
                                            'assets/images/stopwatch.png')),
                                  )
                                ],
                              ),
                              for (int i = 0; i < timeList.length; i++)
                                GestureDetector(
                                  onTapUp: (TapUpDetails details) {
                                    setState(() {
                                      delayTime = timeList[i];
                                      _visible = false;
                                    });
                                  },
                                  child: Text(timeList[i],
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: delayTime == timeList[i]
                                              ? const Color(0Xff4849E0)
                                              : const Color(0xffffffff))),
                                )
                            ],
                          ),
                        )),
                  ),
                )),
            // ),
            // ),
          ],
        ),
      ),
      onWillPop: () => backButtonPress(context),
    );
  }

  Image _buildImage() {
    if (frameData.length == 0) {
      return Image(image: AssetImage('assets/images/kong_stopwatc.png'));
    } else {
      return Image.memory(
        frameData,
        color: Colors.black,
        errorBuilder: (a, b, c) {
          return Container(
            color: Colors.black,
          );
        },
        gaplessPlayback: true,
      );
    }
  }

  Future<bool> backButtonPress(BuildContext context) async {
    debugPrint('backButtonPress');
    stopLivePreview();
    return true;
  }

  void initialize() async {
    debugPrint('init TakePicture');
    // initialize PhotoCapture
    builder = _thetaClientFlutter.getPhotoCaptureBuilder();
    builder!.build().then((value) {
      photoCapture = value;
      debugPrint('Ready PhotoCapture');
      Future.delayed(const Duration(milliseconds: 500), () {}).then((value) {
        // Wait because it can fail.
        startLivePreview();
      });
    }).onError((error, stackTrace) {
      // MessageBox.show(context, 'Error PhotoCaptureBuilder', () {
      //   backScreen();
      // });
    });

    debugPrint('initializing...');
  }

  bool frameHandler(Uint8List frameData) {
    if (!mounted) return false;
    if (!shooting) {
      setState(() {
        this.frameData = frameData;
      });
    }
    return previewing;
  }

  void startLivePreview() {
    previewing = true;
    _thetaClientFlutter.getLivePreview(frameHandler).then((value) {
      debugPrint('LivePreview end.');
    }).onError((error, stackTrace) {
      debugPrint(
          'Error getLivePreview.${error.toString()}+${stackTrace.toString()}');
      // MessageBox.show(context,'Error getLivePreview${error.toString()}+${stackTrace.toString()}', () {
      //   // backScreen();
      // });
    });
    debugPrint('LivePreview starting..');
  }

  void stopLivePreview() {
    previewing = false;
  }

  void backScreen() {
    stopLivePreview();
    Future.delayed(const Duration(milliseconds: 500), () {}).then((value) {
      // Wait because it can fail.
      Navigator.pop(context);
    });
  }

  void takePicture() {
    if (shooting) {
      debugPrint('already shooting2');
      return;
    }
    shooting = true;
    SmartDialog.showLoading(msg: "拍摄中", backDismiss: true);
    photoCapture!.takePicture((fileUrl) {
      shooting = false;
      debugPrint('take picture: $fileUrl');
      if (!mounted) return;
      stopLivePreview();
      playLocalFinish();
      cacheNetworkImages(fileUrl);
    }, (exception) {
      shooting = false;
      debugPrint(exception.toString());
    });
  }

  Future<void> cacheNetworkImages(String fileUrl) async {
    NetworkImage image = NetworkImage(fileUrl);
    ImageConfiguration configuration = ImageConfiguration();
    image
        .resolve(configuration)
        .addListener(ImageStreamListener((image, synchronousCall) {
      SmartDialog.dismiss();
      // BoostNavigator.instance.pushReplacement(
      //   'PhotoScreen', //required
      //   withContainer: false, //optional
      //   arguments: {"fileUrl": fileUrl,"title":Global.title,'delayTime':delayTime}, //optional
      //   // opaque: true, //optional,default value is true
      // );

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return PhotoScreen(
            title: widget.titleStr ?? '客厅',
            fileUrl: fileUrl,
            delayTime: delayTime,
            callBack: widget.callBack!,
          );
        },
      ));
    }));
  }

  Widget _buildTime() {
    return Visibility(
      visible: true,
      child: Container(
        alignment: const Alignment(0, -0.3),
        child: Text(remainTime > 0 ? remainTime.toString() : "",
            style: const TextStyle(
                fontSize: 96,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWatch() {
    return GestureDetector(
      onTap: () {
        //  BoostNavigator.instance.pop();
      },
      child: Stack(
        alignment: const Alignment(-0.8, 0.8),
        children: [
          Positioned(
            bottom: 45,
            left: 40,
            child: SvgPicture.asset('images/stopwatch.svg',
                width: 32,
                height: 32,
                // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                semanticsLabel: 'Acme Logo'),
          ),
          const Positioned(
            bottom: 50,
            left: 52,
            child: Text(
              "5",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
