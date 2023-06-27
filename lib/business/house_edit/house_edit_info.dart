import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:testt/common/global/global.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';
import '../../common/aes_decode/encypt_utils.dart';
import '../../common/global/global_theme.dart';
import '../../common/UI/res_color.dart';
import '../../common/request/request_url.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../utils/vr_request_utils.dart';
import '../home/bean/vr_need_task_bean.dart';
import '../input_house/house_const.dart';
import '../input_house/vr_house_address_bean.dart';

class VRHouseEditInfo extends StatefulWidget {
  final VRNeedTaskListBean? bean;
  final String? saveDate;

  const VRHouseEditInfo({Key? key, this.bean, this.saveDate}) : super(key: key);

  @override
  _house_edit_infoState createState() {
    return _house_edit_infoState();
  }
}

class _house_edit_infoState extends State<VRHouseEditInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _reservationInfo(),
    );
  }

  ///预约信息
  Widget _reservationInfo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget('预约信息'),
          BrnPairInfoTable(
            themeData: GlobalTheme().tableConfig,
            isValueAlign: true,
            children: [
              BrnInfoModal(
                keyPart: '拍摄人:',
                valuePart: widget.bean?.userName ??
                    (VRUserSharedInstance.instance().userModel?.userName ?? ''),
              ),
              BrnInfoModal(
                keyPart: '预约时间:',
                valuePart:
                    '${widget.bean?.appointmentDate ?? '-'} ${widget.bean?.appointmentTime ?? '-'} ',
              ),
            ],
          ),
          _houseInfo()
        ],
      ),
    );
  }

  Widget _houseInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget('房源信息'),
        BrnPairInfoTable(
          themeData: GlobalTheme().tableConfig,
          isValueAlign: true,
          children: [
            BrnInfoModal(
              keyPart: '房源编号',
              valuePart: widget.bean?.houseId ?? '--',
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
        BrnRichInfoGrid(
          themeData: GlobalTheme().richInfoGridConfig,
          pairInfoList: <BrnRichGridInfo>[
            BrnRichGridInfo("房屋楼层：", widget.bean?.floor ?? '--'),
            BrnRichGridInfo(
                "房屋面积：",
                (widget.bean?.buildArea == 0)
                    ? '--'
                    : widget.bean?.buildArea?.toString()),
            BrnRichGridInfo(
                "入户门：", HouseConst.getDoorFaceName(widget.bean?.doorFace ?? 0)),
            BrnRichGridInfo(
                "房源类型：",
                HouseConst.houseTypeString(
                    type: widget.bean?.houseType.toString() ?? '1')),
          ],
        ),
        // BrnRichInfoGrid(
        //   themeData: GlobalTheme().richInfoGridConfig,
        //   pairInfoList: <BrnRichGridInfo>[
        //     BrnRichGridInfo.valueLastClickInfo('详细地址', '', clickTitle: "查看",
        //         clickCallback: (value) {
        //       // BrnToast.show(value, context);
        //       requestCheckAddress();
        //     }),
        //   ],
        // ),
        BrnPairInfoTable(
          themeData: GlobalTheme().tableConfig,
          isValueAlign: true,
          children: [
            BrnInfoModal(
              keyPart: '我的备注:',
              valuePart: widget.bean?.remark ?? '--',
            ),
          ],
        ),
      ],
    );
  }

  void requestCheckAddress() {
    var houseType = widget.bean?.houseType as int;
    Map<String, dynamic> params = {
      'houseId': widget.bean?.houseId,
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'houseType': houseType,
    };

    VRDioUtil.instance
        ?.request(RequestUrl.VR_CHECK_HOUSEADDRESS, params: params)
        .then((value) {
      VRHouseAddressBean addressBean = VRHouseAddressBean.fromJson(value);
      String _address = addressBean?.address ?? "";
      String? _addressCiphertext = addressBean?.addressCiphertext;
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

  Widget _titleWidget(String title) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: GlobalFontWeight.font_medium,
            fontSize: 14,
            color: GlobalColor.color_222222),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
