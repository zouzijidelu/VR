import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

/// /// /// /// /// /// /// /// ///
/// 创建时间: 2023/5/17 <br>
/// 作者: bill <br>
/// 描述: 用于解决flutter和native之间滚动冲突的 ScrollControl
/// 这个控制器有下面两种使用方式：
/// 1、可以在滚动布局例如：SingleChildScrollView中添加一个 SmartScrollController，不需要传入参数
/// 2、如果你的scrollview中已经有了一个ScrollController，而且没法继承这个类，那么你可以新建一个SmartScrollController对象并把你自己的controller传进来
/// /// /// /// /// /// /// /// ///
class SmartScrollController extends ScrollController {
  ///
  /// 认为是有效滚动的阈值 只有大于或者等于这个值才认为是有效滚动
  ///
  static final int SCROLL_DISTANCE = 10;

  ///
  /// 外层已有的ScrollController，如果有传入这个controller那么优先使用这个controller来做滚动的判断
  ///
  ScrollController? _controller;

  SmartScrollController({ScrollController? controller}) {
    this._controller = controller;
  }

  void initCallBack() {
    if (this._controller != null) {
      this._controller?.addListener(() {
        scrollVoidBack();
      });
    } else {
      addListener(() {
        scrollVoidBack();
      });
    }
  }

  ///
  /// 滚动到底部和顶部的判断方法
  ///
  void scrollVoidBack() {

    print(' = 滚动 666');
    if ((_controller?.position.pixels ?? 0) -
            (_controller?.position.maxScrollExtent ?? 0) >=
        SCROLL_DISTANCE) {
      // 滚动到底部
      if (Platform.isAndroid) {
      } else {
        //TODO IOS 向native发送数据
      }

      print(' = 滚动到底部');
    } else if ((_controller?.position.pixels ?? 0) -
            (_controller?.position.minScrollExtent ?? 0) <=
        SCROLL_DISTANCE) {
      // 滚动到顶部
      if (Platform.isAndroid) {
      } else {
        //TODO IOS 向native发送数据
      }
      print(' = 滚动到顶部');
    }
  }
}
