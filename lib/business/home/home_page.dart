
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/UI/res_color.dart';
import '../../common/common_widget/vr_keep_wrapper.dart';
import '../../common/request/request_url.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../generated/assets.dart';
import '../../utils/vr_common_widget.dart';
import '../../utils/vr_request_utils.dart';
import '../person_center/personal_center.dart';
import 'bean/vr_other_home_bean.dart';
import 'task_page.dart';

///
/// @date:2023-05-04 15:03:34
/// @author:bill
/// @des:普通页面类型案例
///
class VRHomePage extends StatefulWidget {
  @override
  _home_pageState createState() {
    return _home_pageState();
  }
}

class _home_pageState extends State<VRHomePage> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _barItem = [
    BottomNavigationBarItem(
        label: '工作台',
        icon: VRUtilsUI().iconWidget(
            Assets.iconsIconWork, color: GlobalColor.color_cccccc),
        activeIcon: VRUtilsUI().iconWidget(
            Assets.iconsIconsWorkSelect, color: GlobalColor.color_mainColor)),
    BottomNavigationBarItem(
        label: '我的',
        icon: VRUtilsUI().iconWidget(
            Assets.iconsIconwMy, color: GlobalColor.color_cccccc),
        activeIcon: VRUtilsUI().iconWidget(Assets.iconsIconwMySelect,
            color: GlobalColor.color_mainColor)),
  ];

  List<Widget> _pageList = [
    VRKeepAliveWrapper(child: VRTaskPage()),
    VRKeepAliveWrapper(child: PersonalCenter())
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: _pageList[_currentIndex],
          onWillPop: () async {
            return false;
          }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        currentIndex: _currentIndex,
        items: _barItem,
        iconSize: 25,
        fixedColor: GlobalColor.color_mainColor,
        selectedFontSize: 16,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
