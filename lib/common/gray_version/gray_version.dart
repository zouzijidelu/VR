import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
  <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class VRGrayVersionBean {
  const VRGrayVersionBean({
    this.versionId,
    this.content,
    this.displayVersion,
    this.innerVersion,
    this.url,
    this.isForce,
    this.status,
  });

  factory VRGrayVersionBean.fromJson(Map<String, dynamic> json) =>
      VRGrayVersionBean(
        versionId: asT<String?>(json['versionId']),
        content: asT<String?>(json['content']),
        displayVersion: asT<String?>(json['displayVersion']),
        innerVersion: asT<String?>(json['innerVersion']),
        url: asT<String?>(json['url']),
        isForce: asT<String?>(json['isForce']),
        status: asT<String?>(json['status']),
      );
  ///版本号
  final String? versionId;
  ///内容展示
  final String? content;
  ///当前线上最新版本
  final String? displayVersion;
  ///内部版本号 build
  final String? innerVersion;
  ///下载url
  final String? url;
  ///是否强制升级
  final String? isForce;
  ///状态
  final String? status;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'versionId': versionId,
    'content': content,
    'displayVersion': displayVersion,
    'innerVersion': innerVersion,
    'url': url,
    'isForce': isForce,
    'status': status,
  };

  VRGrayVersionBean copy() {
    return VRGrayVersionBean(
      versionId: versionId,
      content: content,
      displayVersion: displayVersion,
      innerVersion: innerVersion,
      url: url,
      isForce: isForce,
      status: status,
    );
  }
}
