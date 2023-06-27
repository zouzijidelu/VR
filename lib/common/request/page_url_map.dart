import 'package:flutter/material.dart';

typedef Widget PageBuilder(String pageName, Map params, String uniqueId);

/// 单独的页面，flutter_url 内部跳转的
var urlPageMap = <String, PageBuilder>{
  ///router header vrcapture
  // "vrcapture/book/show/speak_house": (pageName, params, _) =>
  //     BookShowSpeakHousePage(params),

};
