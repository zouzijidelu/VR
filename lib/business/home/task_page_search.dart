import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:testt/business/home/bean/vr_need_task_bean.dart';
import 'package:testt/business/input_house/input_house.dart';
import 'package:testt/common/global/global_theme.dart';

import '../../common/UI/res_color.dart';
import '../../common/request/request_url.dart';
import '../../common/sharedInstance/userInstance.dart';
import '../../common/sharedInstance/vr_shared_preferences.dart';
import '../../utils/vr_request_utils.dart';
import 'package:testt/common/UI/res_color.dart'
    show GlobalColor, GlobalFontWeight;
import 'home_page.dart';

class TaskSearch extends StatefulWidget {
  final String value;

  const TaskSearch({super.key, this.value = ''});

  @override
  State<TaskSearch> createState() => _TaskSearchState();
}

class _TaskSearchState extends State<TaskSearch> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDate();
    _controller.text = widget.value;
    if (!widget.value.isNotEmpty) {
      isSearch = false;
    } else {
      isSearch = true;
      searchFunc(widget.value);
    }
  }

  late List searchList = [];
  late bool isSearch = false;

  // {1: '二手房', 2: '普租', 3: '新房', 4: '相寓'};
  late Map houseTypeMap = {1: '二手房', 2: '普租', 3: '新房'};
  late VRNeedTaskListBean? searchMap = VRNeedTaskListBean();
  late String typeText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: GlobalColor.color_FFFFFFF,
      child: Column(
        children: [
          Container(
            color: GlobalColor.color_FFFFFFF,
            padding: const EdgeInsets.only(top: 40),
          ),
          _buildSearchRow(),
          Flexible(
            child: Padding(
              padding: isSearch && (searchMap?.houseId).toString().isNotEmpty
                  ? const EdgeInsets.fromLTRB(20, 0, 20, 140)
                  : const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                mainAxisAlignment: isSearch
                    ? (searchMap?.houseId).toString().isNotEmpty &&
                            searchMap?.houseId != null
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  isSearch
                      ? (searchMap?.houseId).toString().isNotEmpty &&
                              searchMap?.houseId != null
                          ? GestureDetector(
                              child: _buildHouseCard(),
                              onTap: () => {TapCar()},
                            )
                          : Column(children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  child: Image(
                                    width: 130,
                                    height: 98,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/emptyState.png'),
                                  ),
                                ),
                              ),
                              Text(
                                '暂无搜索结果',
                                style: TextStyle(
                                    color: GlobalColor.color_999999,
                                    fontSize: 14),
                              )
                            ])
                      : _defSearch()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///卡片点击
  TapCar() {
    if (typeText == '已上传') {
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return VRInputHouse(
          type: VRInputHouseEnum.uncapture,
          taskListBean: searchMap,
        );
      },
    ));
  }

  /// 获取历史搜索
  initDate() {
    VRSharedPreferences().getSearch().then((value) => {
          if (mounted)
            {
              setState(() => {searchList = value})
            }
        });
  }

  /// 头部搜索整体
  Widget _buildSearchRow() {
    return Container(
      color: GlobalColor.color_FFFFFFF,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_backButton(), _buildSearchBar(), _buildButton()],
      ),
    );
  }

  /// 返回箭头
  Widget _backButton() {
    return GestureDetector(
        child: const SizedBox(
          width: 20,
          height: 20,
          child: Image(
            image: AssetImage('assets/icons/icon_nav_back.png'),
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return VRHomePage();
            },
          ));
        });
  }

  ///删除历史搜索
  deleteSearch() {
    VRSharedPreferences().remoSearch();
    initDate();
  }

  ///搜索方法
  searchFunc(value) {
    VRSharedPreferences().setSearch(value);
    VRDioUtil.instance?.request(RequestUrl.VR_SEARCH_LIST, params: {
      'cityId': '1',
      'userId': VRUserSharedInstance.instance().userModel?.userId,
      'houseId': value
    }).then((value) {
      if (value?['unfilmedhouse'] == null && value?['uploadedhouse'] != null) {
        VRNeedTaskListBean vrNeedTaskListBean =
            VRNeedTaskListBean.fromJson(value?['uploadedhouse']);
        print('-------------------->');
        print(vrNeedTaskListBean);
        print('-------------------->');
        if (!mounted) return;
        setState(() {
          searchMap = vrNeedTaskListBean;
          typeText = '已上传';
        });
      } else if (value?['uploadedhouse'] == null &&
          value?['unfilmedhouse'] != null) {
        VRNeedTaskListBean vrNeedTaskListBean =
            VRNeedTaskListBean.fromJson(value?['unfilmedhouse']);
        print('-------------------->');
        print(value);
        print('-------------------->');
        if (!mounted) return;
        setState(() {
          searchMap = vrNeedTaskListBean;
          typeText = '待拍摄';
        });
      } else {
        if (!mounted) return;
        setState(() {
          searchMap = VRNeedTaskListBean();
        });
      }
    });
  }

  /// 搜索历史布局
  Widget _defSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '搜索历史',
              style: GlobalTheme().searchConventionBole,
            ),
            GestureDetector(
                child: const Image(
                  height: 16,
                  width: 16,
                  image: AssetImage('assets/icons/trash_can.png'),
                ),
                onTap: () {
                  deleteSearch();
                })
          ]),
        ),
        Wrap(
          direction: Axis.horizontal, //竖直排列还是水平排列
          crossAxisAlignment: WrapCrossAlignment.end, //副轴对其方式
          alignment: WrapAlignment.start, //主轴对齐方式
          children: [
            for (int i = 0; i < searchList.length; i++)
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlobalColor.color_F8F8F8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                      child: Text(
                        searchList[i],
                        style: TextStyle(color: GlobalColor.color_222222),
                      ),
                    ),
                  ),
                  onTap: () {
                    _controller.text = searchList[i];
                  })
          ],
        )
      ],
    );
  }

  /// 搜索卡片
  Widget _buildHouseCard() {
    return Container(
      color: GlobalColor.color_FFFFFFF,
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Stack(
                children: [
                  SizedBox(
                    child: Image(
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      image: NetworkImage(''),
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Image(
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            image: AssetImage('images/vr_house_placehold.png'));
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 100,
                      height: 24,
                      alignment: Alignment.center,
                      color: GlobalColor.color_000000,
                      child: Text(
                        'ID:${searchMap?.houseId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              typeText,
                              style: TextStyle(
                                  color: GlobalColor.color_222222,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "${houseTypeMap[searchMap?.houseType]} / ${searchMap?.houseTitle}",
                            style: TextStyle(
                              fontSize: 14,
                              color: GlobalColor.color_222222,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${searchMap?.roomInfo} | ${searchMap?.buildArea} | ${searchMap?.floor}',
                      style: TextStyle(
                          fontSize: 12, color: GlobalColor.color_666666),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 搜索按钮
  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        searchFunc(_controller.text);
        if (!mounted) return;
        setState(() {
          isSearch = true;
        });
      },
      child: SizedBox(
        width: 42,
        height: 24,
        child: Text(
          '搜索',
          style: TextStyle(
              color: GlobalColor.color_222222,
              fontSize: 16,
              fontWeight: GlobalFontWeight.font_medium),
        ),
      ),
    );
  }

  ///搜索输入框
  Widget _buildSearchBar() {
    return SizedBox(
      width: 300,
      child: BrnSearchText(
        innerPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        maxHeight: 60,
        controller: _controller,
        hintText: '请输入房源编号',
        innerColor: const Color(0xfff3f3f3),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        normalBorder: Border.all(
            color: const Color(0xFFF0F0F0), width: 1, style: BorderStyle.solid),
        activeBorder: Border.all(
            color: const Color(0xFFf3f3f3), width: 1, style: BorderStyle.solid),
        // borderRadius: const BorderRadius.all(Radius.circular(10)),
        // normalBorder: Border.all(
        //     color: GlobalColor.color_F0F0F0,
        //     width: 1,
        //     style: BorderStyle.solid),
        // activeBorder: Border.all(
        //     color: GlobalColor.color_0984F9,
        //     width: 1,
        //     style: BorderStyle.solid),
        onTextClear: () {
          _focusNode.unfocus();
          return false;
        },
        autoFocus: false,
        onTextCommit: (text) {
          VRSharedPreferences().setSearch(text);
          searchFunc(_controller.text);
          if (!mounted) return;
          setState(() {
            isSearch = true;
          });
        },
        onTextChange: (text) {
          if (text.isEmpty) {
            if (!mounted) return;
            setState(() {
              isSearch = false;
            });
          }
        },
      ),
    );
  }
}
