import 'dart:core';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/aes_decode/encypt_utils.dart';
import '../../../common/global/global.dart';
import '../../../common/global/global_theme.dart';
import '../../../common/UI/res_color.dart';
import '../../../common/request/request_url.dart';
import '../../../common/sharedInstance/userInstance.dart';
import '../../../utils/db/vr_todo_task_bean.dart';
import '../../../utils/vr_request_utils.dart';
import '../../input_house/house_const.dart';
import '../../input_house/vr_house_address_bean.dart';

///
/// @date:2023-05-07 11:31:08
/// @author:bill
/// @des:${des}
///

class VRMakeSureHouseInfo extends StatefulWidget {
  ///点击上传按钮
  final VoidCallback? uploadClicked;

  final bool? needMosaic;

  final VRToDoTask? bean;

  final String? saveDate;

  final String? userName;

  VRMakeSureHouseInfo({
    this.needMosaic = false,
    this.bean,
    this.saveDate,
    this.userName,
    this.uploadClicked,
  });

  @override
  _VRMakeSureHouseInfoState createState() => _VRMakeSureHouseInfoState();
}

class _VRMakeSureHouseInfoState extends State<VRMakeSureHouseInfo> {
  @override
  void initState() {
    super.initState();
    EncryptUtils.initAes(Global.aesKey);
  }

  Color _bgColor = GlobalColor.color_F7F7F7;

  @override
  Widget build(BuildContext context) {
    return _buildHouseInfo();
  }

  Widget _buildHouseInfo() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _reservationInfo();
                  }
                  if (index == 1) {
                    return _houseInfo();
                  }
                  if (index == 2) {
                    return _mosaicHouseInfo();
                  }
                }),
          ),
        ),
      ),
    );
  }

  ///预约信息
  Widget _reservationInfo() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        color: _bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget('预约信息'),
            BrnPairInfoTable(
              rowDistance: 4,
              themeData: GlobalTheme().tableConfig,
              isValueAlign: true,
              children: [
                BrnInfoModal(
                  keyPart: '拍摄人:',
                  valuePart: widget.userName ??
                      (VRUserSharedInstance.instance().userModel?.userName ??
                          ''),
                ),
                BrnInfoModal(
                  keyPart: '保存时间:',
                  valuePart: (validateInput(widget.saveDate))
                      ? widget.saveDate
                      : '${widget.bean?.appointmentDate ?? '-'} ${widget.bean?.appointmentTime ?? '-'} ',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _houseInfo() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
          color: _bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget('房源信息'),
              BrnPairInfoTable(
                rowDistance: 4,
                themeData: GlobalTheme().tableConfig,
                isValueAlign: true,
                children: [
                  BrnInfoModal(
                    keyPart: '房源编号',
                    valuePart: _buildCopyHouseId(houseID: widget.bean?.houseId),
                  ),
                  BrnInfoModal(
                    keyPart: '小区名称:',
                    valuePart: widget.bean?.communityName ?? '--',
                  ),
                  BrnInfoModal(
                    keyPart: '房源户型:',
                    valuePart: widget.bean?.roomInfo ?? '--',
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: BrnRichInfoGrid(
                  themeData: GlobalTheme().richInfoGridConfig,
                  pairInfoList: <BrnRichGridInfo>[
                    BrnRichGridInfo("房屋楼层：", widget.bean?.floor ?? '--'),
                    BrnRichGridInfo(
                        "房屋面积：",
                        (widget.bean?.buildArea == 0)
                            ? '--'
                            : widget.bean?.buildArea?.toString()),
                    BrnRichGridInfo("入户门：",
                        HouseConst.getDoorFaceName(widget.bean?.doorFace ?? 0)),
                    BrnRichGridInfo("房源类型：", HouseConst.houseTypeString(
                        type: widget.bean?.houseType.toString() ?? '1')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: BrnRichInfoGrid(
                  themeData: GlobalTheme().richInfoGridConfig,
                  pairInfoList: <BrnRichGridInfo>[
                    BrnRichGridInfo.valueLastClickInfo('详细地址', '',
                        clickTitle: "查看", clickCallback: (value) {
                      // BrnToast.show(value, context);
                      requestCheckAddress();
                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: BrnPairInfoTable(
                  themeData: GlobalTheme().tableConfig,
                  isValueAlign: true,
                  children: [
                    BrnInfoModal(
                      keyPart: '我的备注:',
                      valuePart: widget.bean?.remark ?? '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyHouseId({String? houseID}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            houseID ?? '--',
            style: TextStyle(
                fontSize: 14,
                fontWeight: GlobalFontWeight.font_regular,
                color: GlobalColor.color_323232),
          )
        ],
      ),
    );
  }

  List<String> tagList = ['需要打码', '暂不需要'];

  ///房源打码
  Widget _mosaicHouseInfo() {
    return Visibility(
      visible: widget.needMosaic ?? false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget('房源打码'),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: BrnSelectTag(
                tags: tagList,
                spacing: 12,
                tagWidth: 80,
                initTagState: [true],
                onSelect: (selectedIndexes) {
                  // BrnToast.show(selectedIndexes.toString(), context);
                }),
          ),
          Container(
            height: 100,
            color: GlobalColor.color_white,
          ),
        ],
      ),
    );
  }

  Widget _titleWidget(String title) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: GlobalFontWeight.font_medium,
            fontSize: 14,
            color: GlobalColor.color_222222),
      ),
    );
  }

  ///接口校验 地址信息
  VRHouseAddressBean? _addressBean = VRHouseAddressBean();

  void requestCheckAddress() {
    Map<String, dynamic> params = {
      'houseId': widget.bean?.houseId,
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'houseType': widget.bean?.houseType
    };

    VRDioUtil.instance
        ?.request(RequestUrl.VR_CHECK_HOUSEADDRESS, params: params)
        .then((value) {
      VRHouseAddressBean addressBean = VRHouseAddressBean.fromJson(value);
      _addressBean = addressBean;
      String _address = _addressBean?.address ?? "";
      String? _addressCiphertext = _addressBean?.addressCiphertext;
      if (_address == "" && _addressCiphertext != null) {
        _address = EncryptUtils.decryptAes(_addressCiphertext);
      }
      _showHouseAddress(address: _address);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showHouseAddress({String? address}) {
    BrnDialogManager.showSingleButtonDialog(context,
        label: "确定", title: '详细地址', warning: '', message: address, onTap: () {
      Navigator.pop(context);
    });
  }
}
