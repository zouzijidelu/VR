import 'package:flutter/cupertino.dart';

import '../UI/res_color.dart';

class VRKeepAliveWrapper extends StatefulWidget {
  final bool keepAlive;
  final Widget child;

  const VRKeepAliveWrapper(
      {Key? key, this.keepAlive = true, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VRKeepAliveWrapperState();
  }
}

class _VRKeepAliveWrapperState extends State<VRKeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(color: GlobalColor.color_white, child: widget.child);
  }

  @override
  void didUpdateWidget(covariant VRKeepAliveWrapper oldWidget) {
    //状态发生变化时调用
    if (oldWidget.keepAlive != widget.keepAlive) {
      //更新KeepAlive状态
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
