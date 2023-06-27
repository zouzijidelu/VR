import 'package:bruno/bruno.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../UI/res_color.dart';

class GlobalTheme {
  ///全局主题
  BrnAllThemeConfig allThemeConfig = BrnAllThemeConfig(
      commonConfig: BrnCommonConfig(brandPrimary: GlobalColor.color_mainColor));

  ///
  BrnPairInfoTableConfig tableConfig = BrnPairInfoTableConfig(
    rowSpacing: 4,
    itemSpacing: 10,
    keyTextStyle: BrnTextStyle(color: GlobalColor.color_999999, fontSize: 14),
    valueTextStyle: BrnTextStyle(color: GlobalColor.color_222222, fontSize: 14),
  );
  /// 搜索页面文字正常样式
  TextStyle searchConvention =TextStyle(color: GlobalColor.color_222222, fontSize: 14);
  /// 搜索页面文字选中加粗样
  TextStyle searchConventionBole = TextStyle(color: GlobalColor.color_222222, fontSize: 14,fontWeight: FontWeight.bold);


  BrnPairRichInfoGridConfig richInfoGridConfig = BrnPairRichInfoGridConfig(
    rowSpacing: 4,
    itemSpacing: 10,
    keyTextStyle: BrnTextStyle(color: GlobalColor.color_999999, fontSize: 14),
      valueTextStyle: BrnTextStyle(color: GlobalColor.color_222222, fontSize: 14),
  );

  ClassicHeader classicHeader = ClassicHeader(
      dragText: '下拉刷新',
      armedText: '即将刷新',
      readyText: '刷新中',
      processedText: '刷新完成',
      noMoreText: '没有更多',
      failedText: '加载完成',
      messageText: '最后更新时间 %T',
      backgroundColor:const Color(0xFFF8F8F8),
      textStyle: TextStyle(color: GlobalColor.color_666666),
      messageStyle: TextStyle(color: GlobalColor.color_666666));
  ClassicFooter classicFooter = ClassicFooter(
      dragText: '上拉加载',
      armedText: '即将加载',
      readyText: '加载中',
      processedText: '加载完成',
      noMoreText: '没有更多',
      failedText: '加载完成',
      messageText: '最后更新时间 %T',
      textStyle: TextStyle(color: GlobalColor.color_666666),
      messageStyle: TextStyle(color: GlobalColor.color_666666));
}
