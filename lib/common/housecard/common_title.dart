import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../UI/res_color.dart';

/// /// /// /// /// /// /// /// /// /
/// 创建时间: 2023/05/07.
/// 作者: bill
/// 描述: 上展示的常用 房源卡片
/// /// /// /// /// /// /// /// /// /
class VRCommonTitle extends StatelessWidget {
  // 房源图片 url
  final String? title;

  //该卡片被点击时候的回调
  final VoidCallback? closeClicked;

  const VRCommonTitle({this.title = '', this.closeClicked})
      : assert(null != title);

  @override
  Widget build(BuildContext context) {
    Container ctn = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16),
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_buildVRHouseTitle(context),_colseWidget()],
        ),
      ),
    );
    return GestureDetector(
      child: ctn,
      onTap: this.closeClicked,
    );
  }

  Widget _buildVRHouseTitle(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
          child: Text(
            this.title.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 18,
                fontWeight: GlobalFontWeight.font_medium,
                color: GlobalColor.color_222222),
          )),
    );
  }

  Widget _colseWidget(){
    return Icon(
      grade: 1,
      Icons.close,
      color: GlobalColor.color_999999,
      size: 30,
      weight: 30,
    );
  }

  ///copy内容信息
  Widget _buildCopyItem(BuildContext context) {
    return Container();
  }
}
