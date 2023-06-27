import 'package:flutter/material.dart';

import '../generated/assets.dart';

class VRUtilsUI {
  Widget iconWidget(String? assName, {String? name, Color? color}) {
    return Container(
      width: 24,
      height: 24,
      child: Image(
        image: AssetImage(assName ?? ''),
      ),
    );
  }
}
