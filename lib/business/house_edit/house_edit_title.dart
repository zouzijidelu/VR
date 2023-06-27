import 'package:flutter/material.dart';
import 'package:testt/common/global/global.dart';
import 'package:testt/generated/assets.dart';
import '../../common/UI/res_color.dart';

enum VREditType {
  ///展开收起
  open,

  down,
  ///添加房源
  add
}

class VRHouseEditInfoTitle extends StatefulWidget {
  final String? title;

  final String? subtitle;

  final VoidCallback? onTapClick;

  final VREditType? type;

  const VRHouseEditInfoTitle({
    Key? key,
    this.title,
    this.subtitle,
    this.type,
    this.onTapClick,
  }) : super(key: key);

  @override
  _house_edit_titleState createState() {
    return _house_edit_titleState();
  }
}

class _house_edit_titleState extends State<VRHouseEditInfoTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTitle();
  }

  Widget _buildTitle() {
    return Container(
      height: 52,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? '',
                  style: TextStyle(
                      color: GlobalColor.color_222222,
                      fontSize: 18,
                      fontWeight: GlobalFontWeight.font_medium),
                ),
                _buildAction()
              ],
            ),
          ),
          Text(
            widget.subtitle ?? '',
            style: TextStyle(
                color: GlobalColor.color_999999,
                fontSize: 14,
                fontWeight: GlobalFontWeight.font_regular),
          )
        ],
      ),
    );
  }

  Widget _buildAction() {
    String iconTitle = '';
    String imageName = '';
    if (widget.type == VREditType.open) {
      iconTitle = '收起';
      imageName = Assets.imageHouseEditUp;
    }
    if (widget.type == VREditType.down) {
      iconTitle = '展开';
      imageName = Assets.imageHouseEditDown;
    }
    if (widget.type == VREditType.add) {
      iconTitle = '添加房间';
      return _buildOpen();
    }


    return GestureDetector(
      onTap: widget.onTapClick,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(iconTitle,
                style: TextStyle(
                    color: GlobalColor.color_999999,
                    fontSize: 14,
                    fontWeight: GlobalFontWeight.font_bold)),
            Padding(padding: EdgeInsets.only(left: 4)),
            Container(
                width: 12,
                height: 12,
                child: Image(image: AssetImage(imageName))),
          ],
        ),
      ),
    );
  }

  Widget _buildOpen() {
    return GestureDetector(
      onTap: widget.onTapClick,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 16,
                height: 16,
                child: Image(image: AssetImage(Assets.imageHouseAdd))),
            Padding(padding: EdgeInsets.only(left: 4)),
            Text(
              '添加房间',
              style: TextStyle(
                  color: GlobalColor.color_mainColor,
                  fontWeight: GlobalFontWeight.font_medium,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
