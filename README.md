# vr拍摄端flutter库

# 分支
开发新需求 future/名字 
开发主分支 develop
提交到提测 release 
最终到 master 

# 路由
    //路由 最好是一级路径和二级路径都不相同
    const val ACTIVITY_MAIN: String = "/main/MainActivity"
    const val ACTIVITY_MAIN_UPLOAD: String = "/main/upload"
    
    const val ACTIVITY_CAPTURE_PREPARE: String = "/capture/prepare"
    const val ACTIVITY_CAPTURE_ROOM_INFO: String = "/capture/roominfo"
    
    const val ACTIVITY_CAPTURE_ADD: String = "/capture/add"
    const val ACTIVITY_CAPTURE_PLAY: String = "/capture/play"
    const val ACTIVITY_CAPTURE_TEST: String = "/capture/test"
    
    const val ACTIVITY_TEST: String = "/test/test"
    const val ACTIVITY_LOGIN_MAIN: String = "/login/main"
    
    const val ACTIVITY_WEB_COMMON: String = "/web/common"
    
    const val ACTIVITY_DEBUG: String = "/debug/main"


For help getting started with Flutter development, view the online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).

flutter_boost 路由相关
https://github.com/alibaba/flutter_boost/blob/master/docs/routeAPI.md

adb install /Users/ios_zs/AndroidStudioProjects/capture_flutter/build/host/outputs/apk/debug/app-debug.apk

hot reload
https://blog.csdn.net/shulianghan/article/details/119972493
实际具体操作也很简单，
1，首先以Android项目，运行起整个工程；
2，到命令行，打开 flutter_lib 目录（Flutter module工程）；
3，输入命令：flutter attach
接着你修改Dart的代码，命令行输入 r 或者 R 就会 热重载了。