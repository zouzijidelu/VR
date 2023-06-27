import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testt/utils/vr_utils.dart';
import '../common/global/global.dart';
import '../common/sharedInstance/configInstance.dart';
import '../common/sharedInstance/userInstance.dart';
import 'caller.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';

/// 请求方法
enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}

class VRDioUtil {
  /// 单例模式
  static VRDioUtil? _instance;

  factory VRDioUtil() => _instance ?? VRDioUtil._internal();

  static VRDioUtil? get instance => _instance ?? VRDioUtil._internal();

  /// 连接超时时间
  static const Duration connectTimeout = Duration(milliseconds: 60 * 1000);

  /// 响应超时时间
  static const Duration receiveTimeout = Duration(milliseconds: 60 * 1000);

  /// Dio实例
  static late Dio _dio;

  static const String baseUrl = 'https://sit-app-vr.5i5j.com/';
  static const v = 'vr/v1';

  late CacheStore cacheStore;
  late CacheOptions cacheOptions;
  late Caller caller;

  /// 初始化
  ///
  VRDioUtil._internal() {
    //cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    // getTemporaryDirectory().then((value) =>       )
    getTemporaryDirectory().then((dir) {
      cacheStore = FileCacheStore(dir.path);
      cacheOptions = CacheOptions(
        store: cacheStore,
        // Default.
        policy: CachePolicy.refreshForceCache,
        hitCacheOnErrorExcept: [], // for offline behaviour
      );

      // 初始化基本选项
      BaseOptions options = BaseOptions(
          baseUrl: '',
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout);
      _instance = this;
      // 初始化dio
      _dio = Dio(options);

      setCommonQuerParameters();
      // 添加拦截器
      _dio.interceptors.add(InterceptorsWrapper(
          onRequest: _onRequest, onResponse: _onResponse, onError: _onError));

      _dio.interceptors.add(
        DioCacheInterceptor(options: cacheOptions),
      );

      caller = Caller(
        cacheStore: cacheStore,
        cacheOptions: cacheOptions,
        dio: _dio,
      );
    });
  }

  void setCommonQuerParameters() {
    _dio.options.queryParameters["cityId"] =
        VRUserSharedInstance.instance().userModel?.cityId ?? '1';
    _dio.options.queryParameters["userId"] =
        VRUserSharedInstance.instance().userModel?.userId ?? '';

    if (Platform.isAndroid) {
      _dio.options.queryParameters["clientFrom"] = "Android";
    } else if (Platform.isIOS) {
      _dio.options.queryParameters["clientFrom"] = "IOS";
    } else {
      _dio.options.queryParameters["clientFrom"] = "else";
    }

    _dio.options.queryParameters["api_version"] =
        ConfigInstance.instanceSingleStudent().api_version.toString();
  }

  ///设置代理
  void setupProxy() async {
    // HttpProxy proxy = await HttpProxy.createHttpProxy();
    // debugPrint("PROXY=${proxy.host}");
    // if (proxy.host != null) {
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (HttpClient client) {
    //     client.idleTimeout = const Duration(seconds: 5);
    //     client.findProxy = (uri) {
    //       return "PROXY ${proxy.host}:${proxy.port}";
    //     };
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return null;
    //   };
    // }
  }

  /// 请求拦截器
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 对非open的接口的请求参数全部增加userId
    ///统一参数增加
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }

    // 头部添加token
    options.headers["token"] =
        VRUserSharedInstance.instance().userModel?.token.toString() ?? '';
    // 更多业务需求
    handler.next(options);
    // super.onRequest(options, handler);
  }

  /// 相应拦截器
  void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
      // ....
    } else {
      // var cacheResponse = VRUtils.JsonStringToMap(VRSharedPreferences().getCacheNetWorkData(path).toString());
      // response.data = cacheResponse;
    }
    if (response.requestOptions.baseUrl.contains("???????")) {
      // 对某些单独的url返回数据做特殊处理
    }
    handler.next(response);
  }

  /// 错误处理
  void _onError(DioError error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  /// 请求类
  Future<T> request<T>(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,

    ///是否返回的展示 默认只返回data里面的数据
    bool? showAllData = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const _methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };
    if (!(path.startsWith('https://') || path.startsWith('http://'))) {
      if (validateInput(VRUserSharedInstance.instance().hosturl)) {
        path = VRUserSharedInstance.instance().hosturl.toString() + v + path;
      } else {
        path = baseUrl + v + path;
      }
    }
    print('get flie path  path =  ${path}');
    options ??= Options(method: _methodValues[method]);
    try {
      Response response;
      response = await _dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      if (response.data?['status'] == 'failed') {
        String msg = (response.data?['message']!).toString();
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (showAllData == true) {
        return response.data;
      } else {
        return response.data?['data'];
      }
    } on DioError catch (e) {
      String msg = e.toString();
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }

  /// 开启日志打印
  /// 需要打印日志的接口在接口请求前 VRDioUtil.instance?.openLog();
  void openLog() {
    _dio.interceptors
        .add(LogInterceptor(responseHeader: false, responseBody: true));
  }
}
