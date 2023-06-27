import 'dart:convert';
import 'dart:developer';

final String panoInfoNotes = 'PanoInfo';

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


class PanoInfoFields {
  static final String roomTitle= 'roomTitle';
  static final String floor= 'floor';
  static final String needMosaic= 'needMosaic';
  static final String type= 'type';
  static final String folderPath= 'folderPath';
  static final String relativePath= 'relativePath';
  static final String filePath= 'filePath';
  static final String houseId  = 'houseId';
  static final String fileName  = 'fileName';
  static final String id = 'id';

  static final List<String> values = [
    /// Add all fields
    roomTitle,
    floor,
    needMosaic,
    type,
    folderPath,
    relativePath,
    filePath,
    houseId,
    fileName,
    id
  ];

}

class PanoInfoDBBean {
  const PanoInfoDBBean({
    this.id,
    this.houseId,
    this.filePath,
    this.fileName,
    this.relativePath,
    this.folderPath,
    this.type,
    this.needMosaic,
    this.floor,
    this.roomTitle,
  });

  factory PanoInfoDBBean.fromJson(Map<String, dynamic> json) => PanoInfoDBBean(
    id: asT<int?>(json['id']),
    houseId: asT<String?>(json['houseId']),
    filePath: asT<String?>(json['filePath']),
    fileName: asT<String?>(json['fileName']),
    relativePath: asT<String?>(json['relativePath']),
    folderPath: asT<String?>(json['folderPath']),
    type: asT<String?>(json['type']),
    needMosaic: asT<int?>(json['needMosaic']),
    floor: asT<int?>(json['floor']),
    roomTitle: asT<String?>(json['roomTitle']),
  );

  final int? id;
  final String? houseId;
  final String? filePath;
  final String? relativePath;
  final String? folderPath;
  final String? type;
  final String? fileName;
  final int? needMosaic;
  final int? floor;
  final String? roomTitle;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'houseId': houseId,
    'filePath': filePath,
    'relativePath': relativePath,
    'folderPath': folderPath,
    'type': type,
    'fileName': fileName,
    'needMosaic': needMosaic,
    'floor': floor,
    'roomTitle': roomTitle,
  };

  PanoInfoDBBean copy() {
    return PanoInfoDBBean(
      id: id,
      houseId: houseId,
      filePath: filePath,
      fileName: fileName,
      relativePath: relativePath,
      folderPath: folderPath,
      type: type,
      needMosaic: needMosaic,
      floor: floor,
      roomTitle: roomTitle,
    );
  }
}
