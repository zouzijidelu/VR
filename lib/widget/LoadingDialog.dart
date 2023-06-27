import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//后续删除
class LoadingDialog extends Dialog {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        ///背景透明
        color: Colors.transparent,
        ///保证控件居中效果
        child: Center(
          ///弹框大小
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Container(
              ///弹框背景和圆角
              decoration: ShapeDecoration(
                color: Color(0xff000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitRing(color: Colors.white),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(
                      "加载中",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
