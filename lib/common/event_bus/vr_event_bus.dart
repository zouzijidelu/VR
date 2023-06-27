class VREventName {
  static String KPostSaveSuccess = 'KPostSaveSuccess';
  static String kTabBarChange = 'kTabBarChange';
  static String kRefreshTab2 = 'kRefreshTab2';
}

class VREvent {
  String msg;
  int? index;
  VREvent(this.msg,{this.index});
}