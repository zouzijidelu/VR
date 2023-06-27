import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../UI/res_color.dart';
import 'gray_version.dart';

class GrayVersionWidget {
  static bool showVersionView(PackageInfo info, VRGrayVersionBean versionBean) {
    List<String> onlineversionList =
        (versionBean.versionId.toString()).split('.');
    List<String> currentBeanList = info.version.split('.');

    ///假如版本号相同，则不升级
    if (versionBean.versionId == info.version) {
      return false;
    }

    ///版本号不相同
    for (int index = 0; index < 3; index++) {
      String currIndex = currentBeanList[index];
      String onIndex = onlineversionList[index];
      if (int.parse(onIndex) > int.parse(currIndex)) {
        return true;
      }
    }

    return false;
  }

  static showGrayVerSion(BuildContext context,
      {VRGrayVersionBean? versionBean}) {
    BrnDialogManager.showConfirmDialog(
      context,
      title: "新版本升级",
      cancel: '取消',
      confirm: '确定',
      barrierDismissible: false,
      message: versionBean?.content ?? '',
      cancelWidget: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(
            child: Text('取消',
                style: TextStyle(
                    color: GlobalColor.color_323232,
                    fontSize: 16,
                    fontWeight: GlobalFontWeight.font_semibold))),
        onTap: () {
          if (versionBean?.isForce == 'false' || kDebugMode || versionBean?.isForce == false) {
            Navigator.pop(context);
          }
        },
      ),
      conformWidget: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(
            child: Text(
          '去升级',
          style: TextStyle(
              color: GlobalColor.color_mainColor,
              fontSize: 16,
              fontWeight: GlobalFontWeight.font_semibold),
        )),
        onTap: () async {
          if (versionBean?.isForce == 'false' || kDebugMode|| versionBean?.isForce == false) {
            Navigator.pop(context);
          }
          Uri _url = Uri.parse(versionBean?.url ?? '');
          if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
            throw Exception('Could not launch $_url');
          }
        },
      ),
    );
  }
}
