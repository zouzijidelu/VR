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

class PanoInfoBean {
  PanoInfoBean({
    this.doorFace,
    this.needMosaic,
    this.panoInfoList,
  });

  factory PanoInfoBean.fromJson(Map<String, dynamic> json) {
    final List<PanoInfoList>? panoInfoList =
    json['panoInfoList'] is List ? <PanoInfoList>[] : null;
    if (panoInfoList != null) {
      for (final dynamic item in json['panoInfoList']!) {
        if (item != null) {
          tryCatch(() {
            panoInfoList
                .add(PanoInfoList.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return PanoInfoBean(
      doorFace: asT<int?>(json['doorFace']),
      needMosaic: asT<int?>(json['needMosaic']),
      panoInfoList: panoInfoList,
    );
  }

  int? doorFace;
  int? needMosaic;
  List<PanoInfoList>? panoInfoList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'doorFace': doorFace,
    'needMosaic': needMosaic,
    'panoInfoList': panoInfoList,
  };

  PanoInfoBean copy() {
    return PanoInfoBean(
      doorFace: doorFace,
      needMosaic: needMosaic,
      panoInfoList: panoInfoList?.map((PanoInfoList e) => e.copy()).toList(),
    );
  }
}

class PanoInfoList {
  PanoInfoList({
    this.fileName,
    this.floor,
    this.needMosaic,
    this.roomTitle,
  });

  factory PanoInfoList.fromJson(Map<String, dynamic> json) => PanoInfoList(
    fileName: asT<String?>(json['fileName']),
    floor: asT<int?>(json['floor']),
    needMosaic: asT<int?>(json['needMosaic']),
    roomTitle: asT<String?>(json['roomTitle']),
  );

  String? fileName;
  int? floor;
  int? needMosaic;
  String? roomTitle;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fileName': fileName,
    'floor': floor,
    'needMosaic': needMosaic,
    'roomTitle': roomTitle,
  };

  PanoInfoList copy() {
    return PanoInfoList(
      fileName: fileName,
      floor: floor,
      needMosaic: needMosaic,
      roomTitle: roomTitle,
    );
  }
}
