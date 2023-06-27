// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'picker_home_page.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


const Color themeColor = Color(0xff00bc56);

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    AssetPicker.registerObserve();
    // Enables logging with the photo_manager.
    PhotoManager.setLog(true);

    init();
  }

  Future<void> init() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      packageVersion = info.version;
    } catch (_) {}
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => HomePage(),
          transitionsBuilder: (_, Animation<double> a, __, Widget child) {
            return FadeTransition(opacity: a, child: child);
          },
          transitionDuration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Center(
      ),
    );
  }
}
