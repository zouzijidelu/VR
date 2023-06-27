import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../business/home/bean/vr_need_task_bean.dart';
import '../../generated/assets.dart';
import '../global/global_theme.dart';
import '../UI/res_color.dart';

/// /// /// /// /// /// /// /// /// /
/// 创建时间: 2023/05/07.
/// 作者: bill
/// 描述: 摄影师房源卡片
/// /// /// /// /// /// /// /// /// /
class PhotographerVRHouseCard extends StatefulWidget {
  // 房源图片 url
  final String? imageURL;

  //"西三旗小区
  final String? title;

  //'西三旗 100000347549234/西三旗 100000347549234'
  final String? detail;

  final String? errorMsg;

  final List? bottomSource;

  //该卡片被点击时候的回调
  final VoidCallback? itemClicked;

  //该卡片被点击时候的回调
  final VoidCallback? moreClicked;

  //该卡片被点击时候的回调
  final VoidCallback? uploadClicked;

  final VRNeedTaskListBean? bean;

  const PhotographerVRHouseCard({this.title = '',
    this.detail = '--',
    this.errorMsg = '',
    this.imageURL = '',
    this.bottomSource,
    this.itemClicked,
    this.moreClicked,
    this.bean,
    this.uploadClicked})
      : assert(null != title),
        assert(null != detail);

  @override
  PhotographerVRHouseCardState createState() => PhotographerVRHouseCardState();
}

class PhotographerVRHouseCardState extends State<PhotographerVRHouseCard> {
  @override
  Widget build(BuildContext context) {
    Container ctn = Container(
      padding: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF7F7F7),		// 阴影的颜色
              offset: Offset(0, 2),						// 阴影与容器的距离
              blurRadius: 10.0,							// 高斯的标准偏差与盒子的形状卷积。
              spreadRadius: 1.0,							// 在应用模糊之前，框应该膨胀的量。
            ),
          ],
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_buildleftImage(context), _buildRightInfo()],
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: ctn,
          onTap: () {
            if (widget.itemClicked != null) {
              widget.itemClicked!();
            }
          },
        ),
      ],
    );
  }

  ///图片位置信息
  Widget _buildleftImage(BuildContext context) {
    return Container(
      child: Stack(
        children: [_buildHouseImage(context)],
      ),
    );
  }

  Widget _buildHouseImage(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16),
        height: 146,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              _placeholder(),
              _buildTimeItem(context)
            ],
          ),
        ));
  }

  ///预约时间
  Widget _buildTimeItem(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        height: 20,
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: GlobalColor.color_21000000,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '预约时间：${widget.bean?.appointmentDate ?? '-'} ${widget.bean?.appointmentTime ?? '-'}',
            style: TextStyle(
                color: GlobalColor.color_white,
                fontSize: 12,
                fontWeight: GlobalFontWeight.font_regular),
          ),
        ),
      ),
    );
  }



  Widget _placeholder() {
    return Image(
      image: AssetImage(Assets.imageHousePlaceHolder),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }


  ///右边内容
  Widget _buildRightInfo() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16),
      child: BrnPairInfoTable(
        themeData: GlobalTheme().tableConfig,
        isValueAlign: true,
        children: [
          BrnInfoModal(
              keyPart: '小区名称',
              valuePart: widget.bean?.communityName ?? '-'
          ),
          BrnInfoModal(
            keyPart: '邀约人/陪拍人',
            valuePart: widget.bean?.accompanyUserName ?? '-',
          ),
          BrnInfoModal(
            keyPart: '房源户型',
            valuePart: widget.bean?.roomInfo ?? '-',
          ),
        ],
      ),
    );
  }
}
