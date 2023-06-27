import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:testt/common/UI/res_color.dart';

import '../../common/bean/house_edit_back_bean.dart';
import '../../generated/assets.dart';
import 'house_edit_image.dart';

enum VRHouseItemType { add, img }

class VRHouseEditPageItem extends StatefulWidget {
  final VoidCallback? addOnTap;

  final VoidCallback? deleteOnTap;

  final VoidCallback? previewOnTap;

  final VRHouseItemType? type;

  final VRHouseEditBackBean? bean;

  const VRHouseEditPageItem({
    Key? key,
    this.type = VRHouseItemType.add,
    this.addOnTap,
    this.deleteOnTap,
    this.bean,
    this.previewOnTap,
  }) : super(key: key);

  @override
  _house_edit_page_itemState createState() {
    return _house_edit_page_itemState();
  }
}

class _house_edit_page_itemState extends State<VRHouseEditPageItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.addOnTap,
      child: _buildItem(),
    );
  }

  Widget _buildItem() {
    Widget wig = Container();
    if (widget.type == VRHouseItemType.add) {
      wig = _buildItemCenter();
    }
    if (widget.type == VRHouseItemType.img) {
      wig = VRHouseEditImagePage(
        bean: widget.bean,
        deleteOnTap: widget.deleteOnTap,
        previewOnTap: widget.previewOnTap,
      );
    }
    return Container(
      color: GlobalColor.color_F6F8FB,
      height: 76,
      width: 76,
      child: wig,
    );
  }

  Widget _buildItemCenter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 24,
          width: 24,
          image: AssetImage(Assets.imageHouseEditPhoto),
        ),
        Text(
          '点击拍摄',
          style: TextStyle(
              fontWeight: GlobalFontWeight.font_regular,
              fontSize: 12,
              color: GlobalColor.color_999999),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
