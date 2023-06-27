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

class VRHouseAddressBean {
  VRHouseAddressBean({
    this.address,
    this.otheraddress,
    this.zhengzaidizhi,
    this.addressCiphertext,
    this.otheraddressCiphertext,
    this.zhengzaidizhiCiphertext
  });

  factory VRHouseAddressBean.fromJson(Map<String, dynamic> json) =>
      VRHouseAddressBean(
        address: asT<String?>(json['address']),
        otheraddress: asT<String?>(json['otheraddress']),
        zhengzaidizhi: asT<String?>(json['zhengzaidizhi']),
        addressCiphertext: asT<String?>(json['addressCiphertext']),
        otheraddressCiphertext: asT<String?>(json['otheraddressCiphertext']),
        zhengzaidizhiCiphertext: asT<String?>(json['zhengzaidizhiCiphertext'])
      );

  String? address;
  String? otheraddress;
  String? zhengzaidizhi;
  String? addressCiphertext;
  String? otheraddressCiphertext;
  String? zhengzaidizhiCiphertext;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'address': address,
    'otheraddress': otheraddress,
    'zhengzaidizhi': zhengzaidizhi,
    'addressCiphertext': addressCiphertext,
    'otheraddressCiphertext': otheraddressCiphertext,
    'zhengzaidizhiCiphertext': zhengzaidizhiCiphertext
  };

  VRHouseAddressBean copy() {
    return VRHouseAddressBean(
      address: address,
      otheraddress: otheraddress,
      zhengzaidizhi: zhengzaidizhi,
        addressCiphertext: addressCiphertext,
        otheraddressCiphertext: otheraddressCiphertext,
        zhengzaidizhiCiphertext: zhengzaidizhiCiphertext
    );
  }
}
