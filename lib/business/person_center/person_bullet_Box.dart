// import 'dart:ffi';
// import 'dart:math';
import 'package:bruno/bruno.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BulletBox extends StatefulWidget {
  final bool isShow;
  final String bulltype;
  final Function(Map<String, dynamic>) isShowChange;
  const BulletBox(
      {super.key,
      this.isShow = true,
      required this.isShowChange,
      this.bulltype = 'rqCode'});
  @override
  State<BulletBox> createState() => _BulletBoxState();
}

class MyIcon extends StatelessWidget {
  const MyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _MyIconPainter(),
      ),
    );
  }
}

class _MyIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //外圆画笔
    Paint circlePaint = Paint()
      //画笔颜色
      ..color = Colors.white
      //画笔实线
      ..style = PaintingStyle.stroke
      //画笔线宽(粗细)
      ..strokeWidth = 1.5;
    //叉号画笔
    Paint crossPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    double radius = size.width / 2;
    canvas.drawCircle(Offset(radius, radius), radius, circlePaint);
    canvas.drawLine(Offset(radius - radius / 3, radius - radius / 3),
        Offset(radius + radius / 3, radius + radius / 3), crossPaint);
    canvas.drawLine(Offset(radius + radius / 3, radius - radius / 3),
        Offset(radius - radius / 3, radius + radius / 3), crossPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _BulletBoxState extends State<BulletBox> {
  late bool Visibilitys = true;
  late PackageInfo? packageInfo = null;
  late BrnPortraitRadioGroupOption selectedValue =
      BrnPortraitRadioGroupOption();
  late bool initiallyExpandedBool = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Visibilitys = widget.isShow;
    print(Visibilitys);
    initDate();
  }

  initDate() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    print(_packageInfo);
    if (mounted) {
      setState(() {
        packageInfo = _packageInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: Visibilitys,
        child: Stack(
          children: [
            Opacity(
                opacity: .4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                )),
            widget.bulltype == 'rqCode'
                ? Center(
                    child: Container(
                    width: 335,
                    height: 500,
                    child: Column(
                      children: [
                        Container(
                          width: 335,
                          height: 444,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: const Text(
                                  '查看二维码',
                                  style: TextStyle(
                                    color: Color(0xFF323233),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 23, 0, 0),
                                  width: 166,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '版本号:   ${packageInfo?.version}',
                                        style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '版本名称: ${packageInfo?.appName}',
                                        style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )),
                              GestureDetector(
                                  child: const Image(
                                    height: 302,
                                    width: 302,
                                    image: AssetImage(
                                        'assets/images/mine_slices/rqCodeimg.png'),
                                  ),
                                  onLongPress: () {}),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: GestureDetector(
                            child: MyIcon(),
                            onTap: () {
                              if (!mounted) return;
                              setState(() {
                                Visibilitys = false;
                                widget.isShowChange({});
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ))
                : widget.bulltype == 'file'
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '禁止外传',
                                      style: TextStyle(
                                        fontSize: 40,
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: const Text("关闭"),
                                      onPressed: () {
                                        widget.isShowChange({});
                                      },
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: SizedBox(
                                    child: Image(
                                        width: 330,
                                        height: 600,
                                        image: NetworkImage(
                                            'https://img1.baidu.com/it/u=1055722934,4080178832&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750')),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : widget.bulltype == 'cameraSetting'
                        ? Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 500,
                                color: Colors.white,
                                child: Scaffold(
                                    appBar: AppBar(
                                      title: Text('相机设置'),
                                      centerTitle: true,
                                      leading: Text(''),
                                    ),
                                    body: Column(children: [
                                      BrnExpandableGroup(
                                        title: "音量设置",
                                        initiallyExpanded:
                                            initiallyExpandedBool,
                                        children: [
                                          BrnPortraitRadioGroup.withSimpleList(
                                            options: const [
                                              '低',
                                              '中',
                                              '高',
                                            ],
                                            selectedOption:
                                                selectedValue?.title ?? '低',
                                            onChanged: (old, newList) {
                                              // BrnToast.show(
                                              //     newList.title ?? '', context);

                                              setState(() {
                                                selectedValue = newList;
                                                initiallyExpandedBool = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ]),
                                    bottomNavigationBar: GestureDetector(
                                      child: Container(
                                        height: 50,
                                        color: Colors.blue,
                                        child: const Center(
                                          child: Text(
                                            '保存',
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ),
                                      onTap: () => {
                                        widget.isShowChange({
                                          'selectedValue':
                                              selectedValue.title ?? '低'
                                        })
                                      },
                                    ))
                                ),
                          )
                        : const Center(
                            child: Text('缓存设置'),
                          )
          ],
        ));
  }
}
