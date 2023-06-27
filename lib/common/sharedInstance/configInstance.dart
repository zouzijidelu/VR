import '../common_model/user_model.dart';

class ConfigInstance {
  ///数据模型
  //VRUserModel? userModel;

  String? api_version;


  ///构造方法
  ConfigInstance({this.api_version});

  /// 单例方法
  static ConfigInstance? _configInstance;

  static ConfigInstance instanceSingleStudent() {
    if (_configInstance == null) {
      _configInstance = ConfigInstance();
    }
    return _configInstance!;
  }
}
