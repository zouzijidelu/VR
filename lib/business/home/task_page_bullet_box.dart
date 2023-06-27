// import 'dart:ffi';
// import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testt/business/home/bean/vr_task_sift_bean.dart';
import 'package:testt/common/UI/res_color.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';

import '../../common/request/request_url.dart';
import '../../utils/vr_request_utils.dart';

class TaskBulletBox extends StatefulWidget {
  final bool isShow;
  final String bulltype;
  final void Function(Map<String, dynamic>) isShowChange;
  final int actionNav;
  final Function hideFunc;
  final int houseRange;
  final List roomNum;
  final List houseArea;
  final String houseRangeName;
  const TaskBulletBox(
      {super.key,
      this.isShow = true,
      this.actionNav = 1,
      required this.roomNum,
      required this.houseArea,
      this.houseRange = 0,
      this.houseRangeName = '我的店组',
      required this.isShowChange,
      required this.hideFunc,
      this.bulltype = 'rqCode'});
  @override
  State<TaskBulletBox> createState() => _TaskBulletBoxState();
}

class _TaskBulletBoxState extends State<TaskBulletBox> {
  late bool Visibilitys = true;
  late int action_nav = 1;
  late String houseRangeName = '我的事业部';

  /// 保存枚举我的我的店组
  late List<HouseRange>? broker_enum_houseRange = [];
  late List<HouseArea>? broker_enum_houseArea = [];
  late List<RoomNum>? broker_enum_roomNum = [];

  ///房型选中列表
  late List action_houseArea = [];

  ///房型面积选中列表
  late List action_roomNum = [];

  ///选中店组
  late int action_houseRange = 3;
  late int? action_houseRange_code = 3;

  CancelToken? cancelToken;

  @override
  void initState() {
    super.initState();
    Visibilitys = widget.isShow;
    action_nav = widget.actionNav;
    action_houseRange_code = widget.houseRange;
    action_roomNum = widget.roomNum;
    action_houseArea = widget.houseArea;
    houseRangeName = widget.houseRangeName;
    print(Visibilitys);
    print('进入');
    initDate();
  }


  void initDate() {
    cancelToken = CancelToken();
    VRDioUtil.instance
        ?.request(RequestUrl.VR_ENUMERATION_ROKER,cancelToken: cancelToken,
            params: {}, method: DioMethod.get)
        .then((value) {
      if (value != null && VRUserSharedInstance.instance().screenMap?.houseRange ==null ) {
        Data _Data = Data.fromJson( value);
        VRUserSharedInstance.instance().screenMap = _Data;
            late int? _num =0;
        if (!mounted) return;
        setState(() {
          broker_enum_houseRange = _Data?.houseRange;
          broker_enum_houseArea = _Data?.houseArea;
          broker_enum_roomNum = _Data?.roomNum;
          if (action_houseRange_code == 0) {
            action_houseRange_code = _Data?.houseRange![_num].code;
          }
        });
      } else {
        late Data  _Data =  VRUserSharedInstance.instance().screenMap?? Data();
      if (!mounted) return;
      setState(() {
          broker_enum_houseRange = _Data?.houseRange;
          broker_enum_houseArea = _Data?.houseArea;
          broker_enum_roomNum = _Data?.roomNum;
          if (action_houseRange_code == 0) {
            action_houseRange_code = _Data?.houseRange![0].code;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: Visibilitys,
        child: Stack(
          children: [
            Opacity(
                opacity: .4,
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: GlobalColor.color_000000,
                  ),
                  onTap: () => {widget.hideFunc()},
                )),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: action_nav == 1 ? 350 : 500,
                color: GlobalColor.color_FFFFFFF,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      _select(),
                      action_nav == 1
                          ? Column(
                              children: [
                                for (var i = 0;
                                    i < (broker_enum_houseRange?.length  ?? 0);
                                    i++)
                                  ListTile(
                                    title: Text(
                                      broker_enum_houseRange![i].name ??'',
                                      style: TextStyle(
                                          color: action_houseRange_code ==
                                                  broker_enum_houseRange![i]
                                                      .code
                                              ? GlobalColor.color_4849E0
                                              :GlobalColor.color_222222),
                                    ),
                                    onTap: () {
                                      if (!mounted) return;
                                      setState(() {
                                        Visibilitys = false;
                                        action_houseRange_code =
                                            broker_enum_houseRange![i].code;
                                      });
                                      widget.isShowChange({
                                        'houseRange': action_houseRange_code,
                                        'roomNum': action_roomNum,
                                        'houseArea': action_houseArea,
                                        'houseRangeName': broker_enum_houseRange
                                                ?.where((element) =>
                                                    element.code ==
                                                    action_houseRange_code)
                                                .first.name??
                                            ''
                                      });
                                    },
                                  )
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 22, 20, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      '房型',
                                      style: TextStyle(
                                          color: GlobalColor.color_222222,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      for (int i = 0;
                                          i <( broker_enum_roomNum?.length ?? 0);
                                          i++)
                                        GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12, bottom: 12),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: action_roomNum.contains(
                                                            broker_enum_roomNum![
                                                                i].code)
                                                        ? const Color(
                                                            0xFFEAEAFC)
                                                        : const Color(
                                                            0xFFF8F8F8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            18, 10, 18, 10),
                                                    child: Text(
                                                      broker_enum_roomNum![i]
                                                          .name?? '',
                                                      style: TextStyle(
                                                        color: action_roomNum
                                                                .contains(
                                                                    broker_enum_roomNum![
                                                                            i].
                                                                        code)
                                                            ? const Color(
                                                                0xFF4849E0)
                                                            : const Color(
                                                                0xFF222222),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            onTap: () {
                                              if (action_roomNum.contains(
                                                  broker_enum_roomNum![i]
                                                      .code)) {
                                                if (!mounted) return;
                                                setState(() {
                                                  action_roomNum.removeWhere(
                                                      (item) =>
                                                          item ==
                                                          broker_enum_roomNum![i]
                                                              .code);
                                                });
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  action_roomNum.add(
                                                      broker_enum_roomNum![i]
                                                        .code);
                                                });
                                              }
                                            })
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      '房型面积',
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      for (int i = 0;
                                          i < (broker_enum_houseArea?.length ?? 0);
                                          i++)
                                        GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12, bottom: 12),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: action_houseArea
                                                            .contains(
                                                                broker_enum_houseArea![
                                                                    i].code)
                                                        ? const Color(
                                                            0xFFEAEAFC)
                                                        : const Color(
                                                            0xFFF8F8F8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        14, 10, 14, 10),
                                                    child: Text(
                                                      broker_enum_houseArea![i]
                                                         .name ?? '',
                                                      style: TextStyle(
                                                        color: action_houseArea
                                                                .contains(
                                                                    broker_enum_houseArea![
                                                                            i].code)
                                                            ? const Color(
                                                                0xFF4849E0)
                                                            : const Color(
                                                                0xFF222222),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            onTap: () {
                                              if (action_houseArea.contains(
                                                  broker_enum_houseArea![i]
                                                     .code)) {
                                                if (!mounted) return;
                                                setState(() {
                                                  action_houseArea.removeWhere(
                                                      (item) =>
                                                          item ==
                                                          broker_enum_houseArea![
                                                              i].code);
                                                });
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  action_houseArea.add(
                                                      broker_enum_houseArea![i]
                                                          .code);
                                                });
                                              }
                                            })
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 26),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              child: SizedBox(
                                                width: 30,
                                                height: 50,
                                                child: Column(
                                                  children: const [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/icons/icon_cap_resetting.png')),
                                                    Text(
                                                      '重置',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff222222)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (!mounted) return;
                                                setState(() {
                                                  action_roomNum = [];
                                                  action_houseArea = [];
                                                });
                                              }),
                                          SizedBox(
                                            width: 291,
                                            height: 50,
                                            child: ElevatedButton(
                                              child: Text("确定"
                                                  '(${action_houseArea.length + action_roomNum.length})'),
                                              onPressed: () {
                                                if (!mounted) return;
                                                setState(() {
                                                  Visibilitys = false;
                                                });
                                                widget.isShowChange({
                                                  'houseRange':
                                                      action_houseRange_code,
                                                  'roomNum': action_roomNum,
                                                  'houseArea': action_houseArea,
                                                  'houseRangeName':
                                                      houseRangeName
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _select() {
    List<Map<String, dynamic>> Tabarr = [
      {'title': '$houseRangeName ', 'id': 1},
      {'title': '房型 ', 'id': 2}
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color:GlobalColor.color_FFFFFFF,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < Tabarr.length; i++)
            GestureDetector(
                child: Container(
                  color: GlobalColor.color_FFFFFFF,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Tabarr[i]['title'],
                          style: TextStyle(
                              color: action_nav == Tabarr[i]['id']
                                  ? GlobalColor.color_mainColor
                                  : GlobalColor.color_222222,
                              fontSize: 14),
                        ),
                        Image(
                            width: 6,
                            height: 6,
                            image: AssetImage(action_nav == Tabarr[i]['id']
                                ? "assets/icons/icon-top-Selected.png"
                                : 'assets/icons/icon-bottom.png'))
                      ]),
                ),
                onTap: () {
                  setState(() {
                    if (action_nav == Tabarr[i]['id']) {
                      if (!mounted) return;
                      setState(() {
                        Visibilitys = false;
                      });
                      widget.isShowChange({
                        'houseRange': action_houseRange_code,
                        'roomNum': action_roomNum,
                        'houseArea': action_houseArea,
                        'houseRangeName': houseRangeName
                      });
                    } else {
                      action_nav = Tabarr[i]['id'];
                    }
                  });
                })
        ],
      ),
    );
  }
  @override
  void deactivate() {
    if (cancelToken != null) {
      cancelToken?.cancel('dispose');
    }
    super.deactivate();
  }
}
