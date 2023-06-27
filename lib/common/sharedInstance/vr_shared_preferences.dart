import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/vr_utils.dart';
import '../bean/house_edit_back_bean.dart';
import '../common_model/user_model.dart';
import 'configInstance.dart';
import 'userInstance.dart';

class VRSharedPreferences {
  ///用户信息json
  static const userKey = 'user';
  static const loginKey = 'login';
  static const baseConfigKey = 'config';
  static const cacheRoomList = 'cacheRoomList';

  ///单独获取 login 接口里面的某些单个key
  ///

  ///保存roomlist到文件 key 是house id
  Future<bool> setLogin(VRUserModel userModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userModel.userName.toString());
    prefs.setInt('cityId', userModel.cityId ?? 0);
    prefs.setInt('userId', userModel.userId ?? 0);
    prefs.setString('user', jsonEncode(userModel.toJson()));
    prefs.setString('token', userModel.token.toString());
    return true;
  }

  Future<VRUserModel> getLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String user = prefs.getString(userKey) ?? '';
      VRUserModel vrUserModel = VRUserModel.fromJson(VRUtils.JsonStringToMap(user.toString()));
      return vrUserModel;
    } catch (e, stack) {
      return VRUserModel();
    }
  }
  /// 保存搜索记录

  Future<bool> setSearch( String search) async {
    List<String> defsearch =[];
    if(search.isNotEmpty){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? searchList = prefs.getStringList('searchLists')?.reversed.toList() ?? defsearch ;
      prefs.setStringList('searchLists', searchList! );
        if(!(searchList.contains(search))){
          if(searchList.length<10){
            searchList.add(search);
            prefs.setStringList('searchLists', searchList.reversed.toList() );
          }else{
            searchList.add(search);
            prefs.setStringList('searchLists', searchList.reversed.toList().sublist(0,10) );
          }
        }else{
          late  int index =  searchList.indexOf(search);
          searchList.removeAt(index);
          searchList.add(search);
          prefs.setStringList('searchLists', searchList.reversed.toList() );
        }
      return true;
    }else{
      return false;
    }
  }

  Future<List<String>> getSearch() async {
    List<String> defsearch =[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
       List<String>? _searchList = prefs.getStringList('searchLists');
              print(_searchList);
    List<String> searchList = _searchList ?? defsearch ;
    return searchList;
  }


  Future<bool> remoSearch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> isContainKey = prefs.setStringList("searchLists",[]);
    return isContainKey;
  }
  ///获取用户信息
  Future<String> getUserData({var key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == null) {
      var userJsoen = prefs.get(userKey);
      return userJsoen.toString();
    } else {
      ///如果是别的key，则直接取
      var value = prefs.get(key);
      return value.toString();
    }
  }

  ///获取 roomlist到文件 key 是house id
  Future<List<String>?> getRoomList(String kk) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cacheRoomlist${VRUserSharedInstance.instance().userModel?.userId.toString()}${kk}';
    List<String>? userJsoen = prefs.getStringList(key);
    return userJsoen;
  }

  ///删除某个room的图片
  Future<bool> deleteRoomlist(String? kk, String? dataString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cacheRoomlist${VRUserSharedInstance.instance().userModel?.userId.toString()}${kk}';
    List<String>? getuserJson = prefs.getStringList(key) ?? [];
    VRHouseEditBackBean indexBean = VRHouseEditBackBean.fromJson(
        VRUtils.JsonStringToMap(dataString.toString()));

    List<String>? newList = [];
    getuserJson.forEach((element) {
      VRHouseEditBackBean elementBean = VRHouseEditBackBean.fromJson(
          VRUtils.JsonStringToMap(element.toString()));
      if (indexBean?.fileName != elementBean?.fileName) {
        newList.add(element);
      }
    });
    return prefs.setStringList(key, newList!);
  }

  ///删除所有roomlist的数据
  Future<bool> deleteAllRoomlist(String? kk) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cacheRoomlist${VRUserSharedInstance.instance().userModel?.userId.toString()}${kk}';
    return prefs.remove(key);
  }

  ///保存roomlist到文件 key 是house id
  Future<bool> setRoomlist(String? kk, String? dataString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cacheRoomlist${VRUserSharedInstance.instance().userModel?.userId.toString()}${kk}';
    List<String>? getuserJson = prefs.getStringList(key) ?? [];
    if (!getuserJson.contains(dataString)) {
      getuserJson?.add(dataString!);
    }
    return prefs.setStringList(key, getuserJson!);
  }

  ///保存roomlist到文件 key 是house id
  Future<String> getRoomlistPath(String? kk) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cacheRoomlist${VRUserSharedInstance.instance().userModel?.userId.toString()}${kk}';
    List<String>? getuserJson = prefs.getStringList(key) ?? [];
    if (getuserJson.isEmpty) {
      return '';
    }
    VRHouseEditBackBean indexBean = VRHouseEditBackBean.fromJson(
        VRUtils.JsonStringToMap(getuserJson.first.toString()));
    return indexBean.path ?? '';
  }

  ///获取各种信息
  Future<Map<String, dynamic>> getConfigData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var config = prefs.get(baseConfigKey).toString();
    var userJson = prefs.get(userKey).toString();
    var map1 = VRUtils.JsonStringToMap(userJson.toString());
    // var map2 = VRUtils.JsonStringToMap(json);
    print("map1" + map1.toString());
    //print("map2"+map2.toString());
    // map1[baseConfigKey] = config;
    ConfigInstance configInstance = ConfigInstance?.instanceSingleStudent();
    configInstance.api_version = config;
    return map1;
  }

  Future<bool> setCacheNetWork(String url, String dataString,
      {bool? isAllData}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'cachaNetWork${VRUserSharedInstance.instance().userModel?.userId.toString()}${url}';
    return prefs.setString(key, dataString);
  }

  ///获取缓存下来的网络信息
  Future<Map<String, dynamic>> getCacheNetWorkData(String url) async {
    String key =
        'cachaNetWork${VRUserSharedInstance.instance().userModel?.userId.toString()}${url}';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var urlData = prefs.get(key).toString();
    var map1 = VRUtils.JsonStringToMap(urlData.toString());
    return map1;
  }
}
