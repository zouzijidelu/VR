import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:testt/business/home/home_page.dart';
import 'package:testt/common/aes_decode/encypt_utils.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';
import '../../common/global/global.dart';
import '../../common/request/request_url.dart';
import '../../common/UI/res_color.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../utils/channel/vr_boost_channel.dart';
import '../../utils/vr_request_utils.dart';
import '../../utils/vr_utils.dart';
import '../home/bean/vr_need_task_bean.dart';
import '../house_edit/house_edit.dart';
import 'house_const.dart';
import 'house_single_sheet.dart';
import 'vr_house_address_bean.dart';
import 'dart:convert';

///
/// @date:2023-05-05 18:36:16
/// @author:bill
///

enum VRInputHouseEnum {
  ///什么数据都没有 - 需要从新填写的数据
  edit,

  ///未拍摄带过来的数据
  uncapture,
}

class VRInputHouse extends StatefulWidget {
  ///未拍摄房源信息需要展示的内容
  final VRNeedTaskListBean? taskListBean;

  final VRInputHouseEnum? type;

  const VRInputHouse({
    Key? key,
    this.taskListBean,
    required this.type,
  }) : super(key: key);

  @override
  _input_houseState createState() {
    return _input_houseState();
  }
}

class _input_houseState extends State<VRInputHouse> {
  String jsonToDoTaskItem = HouseConst.quickString;
  String _platformVersion = 'Unknown';
  final _thetaClientFlutter = ThetaClientFlutter();
  bool _isInitTheta = false;
  bool _initializing = false;
  String? _remrak = '';
  late ThetaInfo _thetaInfo;
  String? _estateId = '';
  String? _houseTypeId = '';
  String _doorFaceString = '';
  int _doorFaceValue = 0;

  /// 输入框焦点
  FocusNode focusNode = FocusNode();

  final String endpoint = 'http://192.168.1.1:80/';

  back_home() {
    Navigator.pop(context);
  }

  notesChange(newValue) {
    print(newValue);
    _remrak = newValue;
    _commitTaskBean?.remark = _remrak;
  }

  ///声明一个用来存回调的对象
  VoidCallback? get360CameraStatusListener;

  bool isPush = false;

  @override
  void initState() {
    super.initState();
    EncryptUtils.initAes(Global.aesKey);
    _commitTaskBean = VRNeedTaskListBean();
    _initializing = false;
    isPush = false;
    get360CameraStatusListener = BoostChannel.instance
        .addEventListener(ChannelKey.get360CameraStatus, (key, arguments) {
      if (true == arguments['status']) {
        if (isPush == false) {
          isPush = true;
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return VRHouseEdit(
                bean: _commitTaskBean,
              );
            },
          ));
        }
      }
      Future<dynamic> init() async {}
      return init();
    });
  }

  @override
  Widget build(BuildContext context) {
    ///获取屏幕高度
    final double screenHeight = MediaQuery.of(context).size.height;

    /// 获取appbar高度
    final double appBarHeight = AppBar().preferredSize.height;

    ///屏幕高度 -appbar高度减去差值
    final double availableHeight = screenHeight - appBarHeight;
    return Scaffold(

        ///键盘弹出后开启重新计算高度
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: back_home,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                ),
                Image.asset(
                  'assets/icons/icon_nav_back.png',
                  scale: 3.0,
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),
          title: Text(
            '拍摄新房源',
            style: TextStyle(color: Color(0xff222222), fontSize: 18),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },

          ///使用Listview进行包裹，然后对立面的内容设置为屏幕高度
          child: Container(
            child: Stack(
              children: [
                Container(
                  height: availableHeight,
                  child: _buildFrom(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 114,
          width: MediaQuery.of(context).size.width,
          child: BrnBottomButtonPanel(
            enableMainButton: _checkAllInput(),
            mainButtonName: '连接相机',
            mainButtonOnTap: () {
              // if (kDebugMode) {
              _showConnectCam();
              // } else {
              //
              //   _checkHouseRequest();
              // }
            },
          ),
        ));
  }

  void _connentInfo() {
    _thetaClientFlutter.getThetaInfo().then((value) {
      _thetaInfo = value;
    });
  }

  void _showConnectCam() {
    BrnDialogManager.showConfirmDialog(context,
        title: "检查相机",
        cancel: '已经连接去拍摄',
        confirm: '去连接相机',
        message: "请连接相机,如不能拍摄请关闭流量", onCancel: () {
      Navigator.pop(context);
      if (Platform.isIOS) {
        ///是否连接相机
        BoostChannel.instance
            .sendEventToNative(ChannelKey.get360CameraStatus, {});
      }

      VChannel().getWifiName().then((value) {
        if ((value.toString().contains('THETA'))) {
          if (_commitTaskBean == null) {
            return;
          }
          if (Platform.isAndroid) {
            ///已经连接成功
            _commitTaskBean?.appointmentTime =
                _commitTaskBean?.appointmentTime ?? '-';
            _commitTaskBean?.appointmentDate =
                _commitTaskBean?.appointmentDate ?? '-';
            BoostNavigator.instance.pushReplacement(
              '/capture/roominfo', //required
              withContainer: true, //optional
              arguments: {
                'toDoTaskItem': json.encode(_commitTaskBean?.toJson()),
                'remarks': _remrak ?? '',
                'selectTowardNumber': _doorFaceValue ?? '',
              }, //optional
            ).then((value) => {});
          } else if (Platform.isIOS) {
            if (isPush == false) {
              isPush = true;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return VRHouseEdit(
                    bean: _commitTaskBean,
                  );
                },
              ));
            }
          } else {}
        } else {
          BrnToast.show('未检测相机,请检查权限和相机wifi', context);
        }
      });
    }, onConfirm: () {
      Navigator.pop(context);
      AppSettings.openWIFISettings();
    });
  }

  Future<void> initTheta() async {
    if (_initializing) {
      return;
    }
    bool isInitTheta;

    try {
      isInitTheta = await _thetaClientFlutter.isInitialized();
      if (!isInitTheta) {
        _initializing = true;
        await _thetaClientFlutter.initialize(endpoint);
        isInitTheta = true;
      }
    } on PlatformException catch (err) {
      if (!mounted) return;
      debugPrint('Error. init');
      isInitTheta = false;
    } finally {
      _initializing = false;
    }

    if (!mounted) return;

    if (mounted) {
      setState(() {
        _isInitTheta = isInitTheta;
      });
    }
  }

  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Widget _buildFrom() {
    bool isEdit = (widget.type == VRInputHouseEnum.edit) ? true : false;
    String operationLabel = '查询';
    if (widget.taskListBean != null) {
      operationLabel = '';
    } else {
      if (validateInput(_commitTaskBean?.houseId)) {
        operationLabel = '查询';
      }
    }
    return Container(
      color: GlobalColor.color_F8F8F8,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 0.5, //宽度
                    color: Color(0xffff0f0f0), //边框颜色
                  ),
                ),
              ),
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '房源信息',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff222222),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            BrnBaseTitle(
              title: "房源类型",
              subTitle: "",
              isRequire: true,
              onTip: () {},
            ),
            _buildTypeSelect(),
            _buildHouseNumer(),
            BrnTitleFormItem(
              error: "",
              title: "ID信息",
              subTitle: "",
              tipLabel: null,
              operationLabel: operationLabel,
              onTap: () {
                requestCheckHouseInfo();
              },
            ),
            _buildHouseInfo(),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 0.5, //宽度
                    color: Color(0xffff0f0f0), //边框颜色
                  ),
                ),
              ),
              child: BrnTextSelectFormItem(
                prefixIconType: BrnPrefixIconType.normal,
                isRequire: true,
                error: "",
                title: "入户门",
                subTitle: "",
                hint: (_doorFaceString == '') ? '请选择' : _doorFaceString,
                tipLabel: "门内向外看方向",
                onTap: () {
                  _showHouseToword();
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '备注',
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 14),
                      child: TextField(
                        minLines: 3,
                        maxLines: 10,
                        maxLength: 30,
                        textInputAction: TextInputAction.done,
                        controller: controller,
                        style: const TextStyle(color: Color(0xff222222)),
                        onChanged: (newValue) => notesChange(newValue),
                        onTap: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent, //滚动到底部
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                          );
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: '请输入30字以内',
                          hintStyle:
                              TextStyle(color: Color(0xffcccccc), fontSize: 16),
                          fillColor: Color(0xfff8f8f8),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: GestureDetector(
                child: Container(
                    width: 100,
                    height: 40,
                    color: Colors.yellow,
                    child: Text('快速跳转')),
                onTap: () {
                  _quickPush();
                },
              ),
            ),
            // Container(
            //   height: 200,
            //   color: GlobalColor.color_white,
            // )
          ],
        ),
      ),
    );
  }

  void _quickPush() {
    if (Platform.isAndroid) {
      ///已经连接成功
      BoostNavigator.instance.pushReplacement(
        '/capture/roominfo', //required
        withContainer: true, //optional
        arguments: {
          'toDoTaskItem': jsonToDoTaskItem,
          'remarks': _remrak ?? '',
          'selectTowardNumber': _doorFaceValue ?? '',
        }, //optional
      ).then((value) => {});
    } else if (Platform.isIOS) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return VRHouseEdit(
            bean: VRNeedTaskListBean.fromJson(
                VRUtils.JsonStringToMap(jsonToDoTaskItem)),
          );
        },
      ));
    }
  }

  String tempHouseId = '';

  Widget _buildHouseNumer() {
    bool isEdit = (widget.type == VRInputHouseEnum.edit) ? true : false;

    TextEditingController houseController = TextEditingController()
      ..text = (widget.taskListBean?.houseId ??
          (_commitTaskBean?.houseId ?? ''));

    if (_singleSelectedIndex == 3) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrnTextInputFormItem(
              controller: houseController,
              title: "新房楼盘编号",
              unit: "",
              hint: "请输入",
              isEdit: isEdit,
              isRequire: true,
              onChanged: (newValue) {
                _estateId = newValue;
              },
            ),
            BrnTextInputFormItem(
              controller: TextEditingController()..text = "",
              title: "户型编号",
              unit: "",
              hint: "请输入",
              isEdit: isEdit,
              isRequire: true,
              onChanged: (newValue) {
                _houseTypeId = newValue;
              },
            ),
          ],
        ),
      );
    }
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: BrnTextInputFormItem(
          controller: TextEditingController()
            ..text = (widget.taskListBean?.houseId ??
                (_commitTaskBean?.houseId ?? '')),
          title: "房源编号",
          unit: "",
          hint: isEdit ? "请输入" : '',
          isEdit: isEdit,
          isRequire: true,
          onChanged: (newValue) {
            if (tempHouseId != newValue) {
              tempHouseId = newValue;
            } else {
              return;
            }
            _commitTaskBean?.houseId = newValue;
          },
        ),
      ),
    );
  }

  int? _singleSelectedIndex = 1;

//1二手房 2普租 3新房 4相寓
  final List houseTypes = ['二手房', '普租', '新房'];

  Widget _buildTypeSelect() {
    if (widget.type == VRInputHouseEnum.uncapture) {
      _singleSelectedIndex = widget.taskListBean?.houseType;
      _commitTaskBean = widget.taskListBean;
      _isInfoVisible = true;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5, //宽度
                color: Color(0xffff0f0f0), //边框颜色
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildRadioItem(value: 1, name: houseTypes[0], leftWidth: 5),
                _buildRadioItem(value: 2, name: houseTypes[1], leftWidth: 20),
                _buildRadioItem(value: 3, name: houseTypes[2], leftWidth: 20),
                // _buildRadioItem(value: 4, name: houseTypes[3], leftWidth: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioItem({double? leftWidth, int? value, String? name}) {
    return Container(
        padding: EdgeInsets.only(right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            BrnRadioButton(
              radioIndex: value ?? 1,
              isSelected: _singleSelectedIndex == value,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  name ?? '',
                  style: TextStyle(color: GlobalColor.color_999999),
                ),
              ),
              onValueChangedAtIndex: (index, value) {
                if (widget.type == VRInputHouseEnum.uncapture) {
                  return;
                }
                _commitTaskBean?.houseType = index;
                if (!mounted) return;
                setState(() {
                  if (widget.type == VRInputHouseEnum.edit) {
                    _singleSelectedIndex = index;
                  }
                });
              },
            ),
          ],
        ));
  }

  bool _isInfoVisible = false;

  Widget _buildHouseInfo() {
    return Visibility(
      visible: _isInfoVisible,
      child: Container(
        padding: EdgeInsets.only(left: 20, bottom: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5, //宽度
              color: Color(0xffff0f0f0), //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrnPairInfoTable(
              isValueAlign: true,
              children: [
                BrnInfoModal(
                  keyPart: '小区名称:',
                  valuePart: _commitTaskBean?.communityName ?? '',
                ),
              ],
            ),
            Container(
              // height: 52,
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: BrnRichInfoGrid(
                pairInfoList: <BrnRichGridInfo>[
                  BrnRichGridInfo("楼层：", _commitTaskBean?.floor ?? '-'),
                  BrnRichGridInfo("面积：", _commitTaskBean?.buildArea ?? '-'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 4),
              // height: 52,
              child: BrnPairInfoTable(
                isValueAlign: true,
                children: [
                  BrnInfoModal(
                    keyPart: '房源户型:',
                    valuePart: _commitTaskBean?.roomInfo ?? '-',
                  ),
                ],
              ),
            ),
            BrnRichInfoGrid(
              pairInfoList: <BrnRichGridInfo>[
                BrnRichGridInfo.valueLastClickInfo('详细地址', '', clickTitle: "查看",
                    clickCallback: (value) {
                  requestCheckAddress();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHouseToword() {
    BrnMultiDataPicker(
      context: context,
      title: '入户门朝向',
      delegate: VRHouseSingleDelegate(
        firstSelectedIndex: 0,
      ),
      confirmClick: (list) {
        focusNode.unfocus();
        String doorFaceString = HouseConst.doorFaceList[list.first];
        String doorFaceValue = HouseConst.doorFaceString(doorFaceString);
        _commitTaskBean?.doorFace = int.parse(doorFaceValue);
        _commitTaskBean?.doorFaceName = doorFaceString;
        _doorFaceValue = int.parse(doorFaceValue);

        if (mounted) {
          setState(() {
            _doorFaceString = doorFaceString;
          });
        }
      },
    ).show();
  }

  late VRNeedTaskListBean? _commitTaskBean;

  bool _checkAllInput() {
    _commitTaskBean =
        (widget.taskListBean != null) ? widget.taskListBean : _commitTaskBean;

    if (_commitTaskBean?.houseType == 0) {
      return false;
    }
    if (validateEmpty(_commitTaskBean?.houseId)) {
      return false;
    }
    if (validateEmpty(_doorFaceString)) {
      return false;
    }
    if (_isInfoVisible == false) {
      return false;
    }
    return true;
  }

  ///接口校验
  ///['二手房', '普租', '新房', '相寓'];
  void requestCheckHouseInfo() {
    _commitTaskBean?.houseType = _singleSelectedIndex;
    Map<String, dynamic> params = {
      'houseId': _commitTaskBean?.houseId,
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'houseType': _commitTaskBean?.houseType
    };

    ///3是新房
    if (_commitTaskBean?.houseType == 3) {
      // estateId	是
      // 楼盘id（新房使用）
      // houseTypeId	是
      // 户型id（新房使用）
      params.addAll({'estateId': _estateId, 'houseTypeId': _houseTypeId});
    }

    VRDioUtil.instance
        ?.request(RequestUrl.VR_CHECK_HOUSEINFO, params: params)
        .then((value) {
      VRNeedTaskListBean checkHouseInfo = VRNeedTaskListBean.fromJson(value);
      _commitTaskBean = checkHouseInfo;
      if (_commitTaskBean != null) {
        _isInfoVisible = true;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  ///接口校验 地址信息
  VRHouseAddressBean? _addressBean = VRHouseAddressBean();

  void requestCheckAddress() {
    _commitTaskBean?.houseType = _singleSelectedIndex;

    Map<String, dynamic> params = {
      'houseId': _commitTaskBean?.houseId,
      'userId': VRUserSharedInstance.instance().userId?.toString() ?? '',
      'cityId': VRUserSharedInstance.instance().cityId?.toString() ?? '1',
      'houseType': _commitTaskBean?.houseType
    };

    VRDioUtil.instance
        ?.request(RequestUrl.VR_CHECK_HOUSEADDRESS, params: params)
        .then((value) {
      VRHouseAddressBean addressBean = VRHouseAddressBean.fromJson(value);
      _addressBean = addressBean;
      widget.taskListBean?.address = _addressBean?.address ?? '';
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

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    _scrollController.dispose();
    get360CameraStatusListener?.call();
    super.dispose();
  }
}
