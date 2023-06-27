class RequestUrl {

  static const String UATHOST = 'https://uat-i-app-vr.5i5j.com/';

  static const String DEVHOST = 'https://sit-app-vr.5i5j.com/';

  static const String RELEASEHOST = 'https://app-vr.5i5j.com/';

  ///重构后的大首页
  static const String HOME_PAGE = '/papi/home/service';

  ///待拍摄列表
  static const String VR_NEED_TAKEPHOTO_LIST = '/appapi/needtakephotolist';

  ///经纪人待拍摄
  static const String VR_UNFILMEDHOUSE = '/appapi/unfilmedhouse';

  ///房源id校验
  static const String VR_CHECK_HOUSEINFO = '/appapi/houseinfo';

  ///房源详情地址
  static const String VR_CHECK_HOUSEADDRESS = '/appapi/houseaddress';

  ///已上传房源列表
  static const String VR_UPLOADEDTASKLIST = '/appapi/uploadedtasklist';

  ///获取上传进度
  static const String VR_VRMODELPROGRESS = '/appapi/vrmodelprogress';

  ///用户登录
  static const String VR_LOGIN = '/appapi/login';

  /// 经纪人未拍摄房源列表筛选项枚举
  static const String VR_ENUMERATION_ROKER = '/appapi/filterenum';

  ///经纪人房源搜索历史列表
  static const String VR_SEARCH_HISTORY = '/appapi/searchhistory';

  ///删除搜索历史
  static const String VR_SEARCH_HISTORY_DEL = '/appapi/delsearchhistory';

  /// 经纪人搜索房源列表
  static const String VR_SEARCH_LIST = '/appapi/searchhouse';

  ///校验房源是否可拍
  static const String VRCHECKHOUSE = '/appapi/checkhouse';

  ///获取房间 -
  static const String VR_OTHERHOMEOPTION = '/appapi/otherhomeoption';
  static const String VR_MOBILE_CONFIG =
      'https://huawei-vr-test.obs.cn-north-4.myhuaweicloud.com/mobile_config';

  String VR_FILE_EXT(String ex) {
    return 'https://admin-vr.5i5j.com/vr/v1/index/refreshcdn?type=1&items=${ex}&itemAction=expire';
  }
}

class RouterUrl {
  static const String CAPTURE_PREVIEW = '/capture/preview';

  /// 经纪人搜索房源列表
  static const String CAPTURE_SAVE = '/capture/save';
}
