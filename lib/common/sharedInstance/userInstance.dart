import 'package:package_info_plus/package_info_plus.dart';
import 'package:testt/business/home/bean/vr_task_sift_bean.dart';

import '../../business/home/bean/vr_other_home_bean.dart';
import '../common_model/user_model.dart';

class VRUserSharedInstance {
  ///数据模型
  VRUserModel? userModel;

  String? hosturl;

  String? userId;

  String? cityId;

  String? panoInfoPath;

  VROtherHomeOption? otherHomeOption;

  PackageInfo? packageInfo;

  bool? isShowUpVersion;
  Data? screenMap;

  ///构造方法
  VRUserSharedInstance(
      {this.userModel,
      this.userId,
      this.cityId,
      this.panoInfoPath,
      this.packageInfo,
      this.otherHomeOption,
      this.hosturl,
      this.screenMap});

  /// 单例方法
  static VRUserSharedInstance? _userInstance;

  static VRUserSharedInstance instance() {
    if (_userInstance == null) {
      _userInstance = VRUserSharedInstance();
    }
    return _userInstance!;
  }
}
