import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:testt/common/global/global.dart';
import 'package:testt/common/file_list_screen.dart';
import 'package:testt/common/message_box.dart';
import 'package:testt/business/person_center/personal_center.dart';
import 'package:testt/utils/vr_utils.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'business/home/home_page.dart';
import 'common/capture_video_screen.dart';
import 'common/global/global_theme.dart';
import 'common/photo_screen.dart';
import 'common/sharedInstance/userInstance.dart';
import 'common/show_panorama.dart';
import 'common/take_picture_screen.dart';
import 'login/login.dart';

Future<void> main() async {
  CustomFlutterBinding();
  WidgetsFlutterBinding.ensureInitialized();
  VRUserSharedInstance.instance().isShowUpVersion = false;

  ///添加全局生命周期监听类
  runApp(MyApp());
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class MyApp extends StatelessWidget {
  /// 由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
  /// 其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
  /// 那么只需要像下面这样写成 [CupertinoPageRoute] 即可
  /// (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)
  ///
  /// 注意，如果需要push的时候，两个页面都需要动的话，
  /// （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
  /// 那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
  /// 简单来说，就两个页面都是CupertinoPageRoute就好
  /// 如果用MaterialPageRoute的话同理

  Map<String, FlutterBoostRouteFactory> routerMap = {
    'mainPage': (RouteSettings settings, String? uniqueId) {
      // print('mainPage${settings.arguments as Map<String, dynamic>}');
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            // print('goToTakePicturePage${settings.arguments as Map<String, dynamic>}');
            Global.title = map['title'] as String;
            Global.fileUrl = map['path'] as String;
            Global.index = map['index'] as int;
            Global.position = map['position'] as int;
            return MainPage(
              Global.title,
              settings.arguments as Map<String, dynamic>,
              false,
            );
          });
    },
    //拍摄页面绑定
    'goToTakePicturePage': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments != null) {
              Map<String, dynamic> map =
                  settings.arguments as Map<String, dynamic>;
              if (map['title'] != null) {
                Global.title = map['title'] as String;
              }
              if (map['path'] != null) {
                Global.fileUrl = map['path'] as String;
              }
              if (map['index'] != null) {
                Global.index = map['index'] as int;
              }
              if (map['position'] != null) {
                Global.position = map['position'] as int;
              }
              return TakePictureScreen(fromMainPage: false);
            } else {
              return TakePictureScreen(fromMainPage: false);
            }
          });
    },
    //从首页等待绑定后跳转到拍摄页面
    'goToTakePicturePage_all': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments != null) {
              Map<String, dynamic> map =
                  settings.arguments as Map<String, dynamic>;
              print(
                  'goToTakePicturePage${settings.arguments as Map<String, dynamic>}');
              Global.title = map['title'] as String;
              Global.fileUrl = map['path'] as String;
              Global.index = map['index'] as int;
              Global.position = map['position'] as int;
              return MainPage(Global.title,
                  settings.arguments as Map<String, dynamic>, true);
            } else {
              return MainPage("test", const <String, dynamic>{}, true);
            }
          });
    },
    'takePicturePage': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            // Map<String, dynamic> map =
            //     settings.arguments as Map<String, dynamic>;
            // String data = map['data'] as String;
            return const TakePictureScreen(
              fromMainPage: true,
            );
          });
    },
    'fileListPage': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            String data = map['data'] as String;
            return SimplePage(
              data: data,
            );
          });
    },
    'FadeAppTest': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            // Map<String, dynamic> map =
            // settings.arguments as Map<String, dynamic>;
            // String data = map['data'] as String;
            return const FadeAppTest();
          });
    },
    'HomePage': (settings, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            // Map<String, dynamic> map =
            // settings.arguments as Map<String, dynamic>;
            // String data = map['data'] as String;
            return VRHomePage();
          });
    },
    'PhotoScreen': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            return PhotoScreen(
                callBack: (res) {},
                title: map['title'] as String,
                fileUrl: map['fileUrl'] as String);
          });
    },
    'ShowPanorama': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            return ShowPanorama(
              title: map['title'] as String,
              filePath: map['filePath'] as String,
            );
          });
    },
    'PersonalCenter': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(

          ///透明弹窗页面这个需要是false
          opaque: false,

          ///背景蒙版颜色
          barrierColor: Colors.white,
          settings: settings,
          pageBuilder: (_, __, ___) => const PersonalCenter());
    },
    'Login': (settings, uniqueId) {
      try {
        Map<String, dynamic> result =
            VRUtils.JsonStringToMap(json.encode(settings.arguments).toString());
        String host = result['hosturl'].toString();
        return PageRouteBuilder<dynamic>(
            ///透明弹窗页面这个需要是false
            opaque: false,
            ///背景蒙版颜色
            barrierColor: Colors.white,
            settings: settings,
            pageBuilder: (_, __, ___) => Login(
                  hostUrl: host,
                ));
      } catch (e, stack) {
        print('=maphost error  ${Global.hosturl}');
        return PageRouteBuilder<dynamic>(

            ///透明弹窗页面这个需要是false
            opaque: false,

            ///背景蒙版颜色
            barrierColor: Colors.white,
            settings: settings,
            pageBuilder: (_, __, ___) => const Login());
      }
    },
  };

  MyApp({super.key});

  Route? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name];
    // func ??= routerMap['Login'];
    if (func == null) {
      return null;
    }

    return FlutterSmartDialog.boostMonitor(func!(settings, uniqueId));
  }

  Widget appBuilder(Widget home) {
    final initSmartDialog = FlutterSmartDialog.init();
    BrnInitializer.register(
        // BrnPairInfoTableConfig themeData
        allThemeConfig: GlobalTheme().allThemeConfig);

    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1),
      ),
      builder: (context, child) => initSmartDialog(context, home),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boost = BoostLifecycleBinding.instance;
    if (!boost.navigatorObserverList.contains(FlutterSmartDialog.observer)) {
      boost.addNavigatorObserver(FlutterSmartDialog.observer);
    }
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
    );
  }
}

class MainPage extends StatelessWidget {
  String label = "";
  Map<String, dynamic>? params;
  bool goToTakePicture;

  MainPage(String label, Map<String, dynamic>? params, this.goToTakePicture,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: label,
      theme: ThemeData.dark(useMaterial3: true),
      home: MyHomePage(goToTakePicture, params),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({required Object data});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SimplePage')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.goToTakePicture, this.params, {super.key});

  Map<String, dynamic>? params;
  bool goToTakePicture;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  final _thetaClientFlutter = ThetaClientFlutter();
  bool _isInitTheta = false;
  bool _initializing = false;

  final String endpoint = 'http://192.168.1.1:80/';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initTheta(widget.goToTakePicture);
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _thetaClientFlutter.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (mounted) {
      setState(() {
        _platformVersion = platformVersion;
      });
    }
  }

  Future<void> initTheta(bool togoTakePicture) async {
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
      debugPrint('Error. init');
      isInitTheta = false;
      MessageBox.show(
          context, 'Initialize error.${err.message}${err.stacktrace}');
    } finally {
      _initializing = false;
    }

    if (!mounted) return;
    MessageBox.show(context, '!mounted.b{togoTakePicture}${isInitTheta}');
    if (togoTakePicture && isInitTheta) {
      BoostNavigator.instance.push(
        'takePicturePage', //required
        withContainer: false, //optional
        arguments: {"key": "value"}, //optional
        opaque: true, //optional,default value is true
      );
    }
    if (mounted) {
      setState(() {
        _isInitTheta = isInitTheta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "", //widget.params['title'],
      home: Home(
        platformVersion: _platformVersion,
        isInitialized: _isInitTheta,
        connectTheta: () => {initTheta(false)},
      ),
    );
  }
}

class FadeAppTest extends StatelessWidget {
  const FadeAppTest({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fade Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyFadeTest(title: 'Fade Demo'),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  const MyFadeTest({super.key, required this.title});

  final String title;

  @override
  State<MyFadeTest> createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FadeTransition(
          opacity: curve,
          child: const FlutterLogo(
            size: 100.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        onPressed: () {
          controller.forward();
        },
        child: const Icon(Icons.brush),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String platformVersion;
  final bool isInitialized;
  final Function connectTheta;

  const Home({
    Key? key,
    required this.platformVersion,
    required this.isInitialized,
    required this.connectTheta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String camera = isInitialized ? 'connected!' : 'disconnected';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app123'),
        ),
        body: Center(
          child: Center(
            // child: Panorama(
            //   child: Image.asset('images/1234.jpg'),
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Running on: $platformVersion\n'),
                Text('Cameraas: $camera\n'),
                TextButton(
                  onPressed: isInitialized
                      ? null
                      : () {
                          connectTheta();
                        },
                  child: const Text('Connect12'),
                ),
                TextButton(
                  onPressed: !isInitialized
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const TakePictureScreen(
                                    fromMainPage: true,
                                  )));
                        },
                  child: const Text('Take Picture'),
                ),
                TextButton(
                  onPressed: !isInitialized
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const CaptureVideoScreen()));
                        },
                  child: const Text('Capture Video'),
                ),
                TextButton(
                  onPressed: !isInitialized
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const FileListScreen()));
                        },
                  child: const Text('File List'),
                ),
              ],
            ),
          ),
        ));
  }
}
