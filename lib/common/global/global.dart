// // 提供五套可选主题色
// const _themes = <MaterialColor>[
//   Colors.blue,
//   Colors.cyan,
//   Colors.teal,
//   Colors.green,
//   Colors.red,
// ];
bool validateInput(String? input) {
  return input?.isNotEmpty ?? false;
}

bool validateEmpty(String? input) {
  return !(input?.isNotEmpty ?? false);
}
class Global {
  static int position = 0;
  static int index = 0;
  static String title = "";
  static String hosturl = "";
  static String fileUrl = "";
  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static bool isShowSave = false;

  static String inputFlies = '';
  static String aesKey = 'kjqWCVpgkD1npgHG';
// static SharedPreferences _prefs;
// static Profile profile = Profile();
//
// // 网络缓存对象
// static NetCache netCache = NetCache();
//
// // 可选的主题列表
// static List<MaterialColor> get themes => _themes;
//

//
// //初始化全局信息，会在APP启动时执行
// static Future init() async {
//   _prefs = await SharedPreferences.getInstance();
//   var _profile = _prefs.getString("profile");
//   if (_profile != null) {
//     try {
//       profile = Profile.fromJson(jsonDecode(_profile));
//     } catch (e) {
//       print(e);
//     }
//   }
//   // 如果没有缓存策略，设置默认缓存策略
//   profile.cache = profile.cache ?? CacheConfig()
//     ..enable = true
//     ..maxAge = 3600
//     ..maxCount = 100;
//   //初始化网络请求相关配置
//   Git.init();
// }
//
// // 持久化Profile信息
// static saveProfile() =>
//     _prefs.setString("profile", jsonEncode(profile.toJson()));
}
