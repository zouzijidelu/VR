import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testt/common/global/global.dart';
import '../../common/common_widget/vr_keep_wrapper.dart';
import '../../common/photo_screen.dart';
import '../home/bean/vr_home_plan_bean.dart';
import '../home/bean/vr_need_task_bean.dart';
import 'package:flutter/foundation.dart';

import 'house_edit_page.dart';

class VRHouseEditTabPageView extends StatefulWidget {
  final VRNeedTaskListBean? bean;

  final HouseEditScrollCallBack? scrollCallBack;

  final PhotoScreenCallBack? callBack;

  final PhotoScreenCallBack? deleteOnTap;

  const VRHouseEditTabPageView(
      {Key? key,
      this.bean,
      this.callBack,
      this.scrollCallBack,
      this.deleteOnTap})
      : super(key: key);

  @override
  _house_edit_page_tab_pageState createState() {
    return _house_edit_page_tab_pageState();
  }
}

class _house_edit_page_tab_pageState extends State<VRHouseEditTabPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> roomList = TransVRHomePlan.roomList;

  final List<BadgeTab> tabs = <BadgeTab>[];

  @override
  void initState() {
    if ((widget.bean?.homePlan?.length ?? 0) > 0) {
      roomList = [];
      widget.bean?.homePlan?.forEach((element) {
        if (validateInput(element.name)) {
          roomList.add(element.name ?? '');
          tabs.add(BadgeTab(text: element.name));
        }
      });
    } else {
      roomList.forEach((element) {
        tabs.add(BadgeTab(text: element));
      });
    }
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color(0xfff5f5f5),
            padding: EdgeInsets.only(
              top: 10,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: BrnTabBar(
                controller: _tabController,
                //可以和TabBarView使用同一个TabController
                tabs: tabs,
                labelPadding: EdgeInsets.only(left: 0, right: 10),
                mode: BrnTabBarBadgeMode.average,
                isScroll: true,
                onTap: (state, index) {
                  state.refreshBadgeState(index);
                },
              ),
            ),
          ),
          Container(
            color: Color(0xfff5f5f5),
            padding: EdgeInsets.only(
              top: 10,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 20, left: 20, top: 23),
              child: Container(
                  child: TabBarView(
                      controller: _tabController, children: _roomsWidget())),
            ),
          )
        ],
      ),
    );
  }

  final List<Widget> listComList = [];

  List<Widget> _roomsWidget() {
    if (listComList.isNotEmpty) {
      return listComList;
    }
    int indx = 0;
    roomList.forEach((element) {
      listComList.add(VRKeepAliveWrapper(
        child: Center(
          child: VRHouseEditPage(
            title: element,
            houseID: widget.bean?.houseId,
            listBean: widget.bean,
            index: indx,
            callBack: widget.callBack,
            deleteOnTap: widget.deleteOnTap,
            scrollCallBack: widget.scrollCallBack,
          ),
        ),
      ));
      indx++;
    });
    return listComList;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
