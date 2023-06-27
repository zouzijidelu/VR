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

class VRHouseEditBackBean {
  VRHouseEditBackBean({
    this.position,
    this.index,
    this.path,
    this.title,
    this.relativeCoverPath,
    this.fileName,
    this.tempThumbnail,
  });

  factory VRHouseEditBackBean.fromJson(Map<String, dynamic> json) =>
      VRHouseEditBackBean(
        position: asT<int?>(json['position']),
        index: asT<int?>(json['index']),
        path: asT<String?>(json['path']),
        title: asT<String?>(json['title']),
        relativeCoverPath: asT<String?>(json['relativeCoverPath']),
        fileName: asT<String?>(json['fileName']),
        tempThumbnail: asT<String?>(json['tempThumbnail']),
      );

  int? position;
  int? index;
  String? path;
  String? title;
  String? relativeCoverPath;
  String? fileName;
  String? tempThumbnail;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'position': position,
        'index': index,
        'path': path,
        'fileName': fileName,
        'title': title,
        'relativeCoverPath': relativeCoverPath,
        'tempThumbnail': tempThumbnail,
      };

  VRHouseEditBackBean copy() {
    return VRHouseEditBackBean(
      position: position,
      index: index,
      path: path,
      fileName: fileName,
      title: title,
      relativeCoverPath: relativeCoverPath,
      tempThumbnail: tempThumbnail,
    );
  }
}
