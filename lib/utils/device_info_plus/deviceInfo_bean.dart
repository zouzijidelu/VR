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

class VRDeviceInfoBean {
  const VRDeviceInfoBean({
    this.brand,
    this.systemVersion,
    this.platform,
    this.isPhysicalDevice,
    this.uuid,
    this.incremental,
  });

  factory VRDeviceInfoBean.fromJson(Map<String, dynamic> json) =>
      VRDeviceInfoBean(
        brand: asT<String?>(json['brand']),
        systemVersion: asT<String?>(json['systemVersion']),
        platform: asT<String?>(json['Platform']),
        isPhysicalDevice: asT<String?>(json['isPhysicalDevice']),
        uuid: asT<String?>(json['uuid']),
        incremental: asT<String?>(json['incremental']),
      );

  final String? brand;
  final String? systemVersion;
  final String? platform;
  final String? isPhysicalDevice;
  final String? uuid;
  final String? incremental;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'brand': brand,
    'systemVersion': systemVersion,
    'Platform': platform,
    'isPhysicalDevice': isPhysicalDevice,
    'uuid': uuid,
    'incremental': incremental,
  };

  VRDeviceInfoBean copy() {
    return VRDeviceInfoBean(
      brand: brand,
      systemVersion: systemVersion,
      platform: platform,
      isPhysicalDevice: isPhysicalDevice,
      uuid: uuid,
      incremental: incremental,
    );
  }
}
