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

class VROtherHomeOption {
  const VROtherHomeOption({
    this.code,
    this.status,
    this.data,
  });

  factory VROtherHomeOption.fromJson(Map<String, dynamic> json) {
    final List<String>? data = json['data'] is List ? <String>[] : null;
    if (data != null) {
      for (final dynamic item in json['data']!) {
        if (item != null) {
          tryCatch(() {
            data.add(asT<String>(item)!);
          });
        }
      }
    }
    return VROtherHomeOption(
      code: asT<int?>(json['code']),
      status: asT<String?>(json['status']),
      data: data,
    );
  }

  final int? code;
  final String? status;
  final List<String>? data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'status': status,
    'data': data,
  };

  VROtherHomeOption copy() {
    return VROtherHomeOption(
      code: code,
      status: status,
      data: data?.map((String e) => e).toList(),
    );
  }
}
