// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../UI/res_color.dart';
import '../constants/screens.dart';
import '../customs/custom_picker_page.dart';

import 'multi_assets_page.dart';
import 'single_assets_page.dart';

const Color themeColor = Color(0xff00bc56);

bool get currentIsDark =>
    Screens.mediaQuery.platformBrightness == Brightness.dark;

class HomePage extends StatefulWidget {
  HomePage({super.key,this.inputFlies});

  String? inputFlies;

  @override
  State<HomePage> createState() => _HomePageState();
}

String? packageVersion;

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(pageControllerListener);
  }

  void selectIndex(int index) {
    if (index == currentIndex) {
      return;
    }
    controller.animateToPage(
      index,
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void pageControllerListener() {
    final int? currentPage = controller.page?.round();
    if (currentPage != null && currentPage != currentIndex) {
      currentIndex = currentPage;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget header(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 30.0),
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Semantics(
                sortKey: const OrdinalSortKey(0.1),
                child: Text(
                  'Version: ${packageVersion ?? 'unknown'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalColor.color_4849E0,
          title: Text('上传户型图',style: TextStyle(fontSize: 18,color: Color(0xffffffff)),),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              header(context),
              Expanded(
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    // MultiAssetsPage(),
                    SingleAssetPage(),
                    // CustomPickersPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
