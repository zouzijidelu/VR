import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../common/bean/house_edit_back_bean.dart';
import '../home/bean/vr_need_task_bean.dart';

class VRHouseEditEx {
  static List<List<VRHouseEditBackBean>> getRoomList(
      {VRNeedTaskListBean? bean, String? title}) {
    List<List<VRHouseEditBackBean>> list = [];
    bean?.homePlan?.forEach((element) {
      if (element.name == title) {
        for (int index = 0; index < (element.num ?? 0); index++) {
          list.add([]);
        }
      }
    });
    return list;
  }

  static String getASIINum({int? num}) {
    int maxNum = 26;
    int exceedNum = ((num ?? 0)~/maxNum);
    int num2 = ((num ?? 0)%maxNum);
    if (exceedNum == 0) {
      int codeUnitsString = (65 + (num2 ?? 0));
      var listInt = [codeUnitsString];
      var int2utf8 = Uint8List.fromList(listInt);
      var character = Utf8Codec().decode(int2utf8);
      return character;
    } else {
      var character = '';
      exceedNum = exceedNum - 1;
      int codeUnitsString2 = (65 + (exceedNum ?? 0));
      var listInt2 = [codeUnitsString2];
      var int2utf82 = Uint8List.fromList(listInt2);
      character = Utf8Codec().decode(int2utf82);
      
      int codeUnitsString = (65 + (num2 ?? 0));
      var listInt = [codeUnitsString];
      var int2utf8 = Uint8List.fromList(listInt);
      character = character + Utf8Codec().decode(int2utf8);

      return character;
    }
  }
}
