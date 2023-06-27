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

class VRFinishList {
  VRFinishList({
    this.list,
    this.listCount,
  });

  factory VRFinishList.fromJson(Map<String, dynamic> json) {
    final List<VRFinishListBean>? list =
    json['list'] is List ? <VRFinishListBean>[] : null;
    if (list != null) {
      for (final dynamic item in json['list']!) {
        if (item != null) {
          tryCatch(() {
            list.add(
                VRFinishListBean.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRFinishList(
      list: list,
      listCount: asT<int?>(json['listCount']),
    );
  }

  List<VRFinishListBean>? list;
  int? listCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'list': list,
    'listCount': listCount,
  };

  VRFinishList copy() {
    return VRFinishList(
      list: list?.map((VRFinishListBean e) => e.copy()).toList(),
      listCount: listCount,
    );
  }
}

class VRFinishListBean {
  VRFinishListBean({
    this.communityName,
    this.uploadDate,
    this.accompanyUserName,
    this.mainPicUrl,
    this.taskId,
    this.status,
    this.vrModelUrl,
    this.houseId,
    this.houseTitle,
    this.roomInfo,
    this.buildArea,
    this.floor,
    this.userName,
    this.saveDate,
    this.houseType,
    this.doorFace,
    this.remark,
    this.inputFlies,
    this.needMosaic,
  });

  factory VRFinishListBean.fromJson(Map<String, dynamic> json) =>
      VRFinishListBean(
        communityName: asT<String?>(json['communityName']),
        uploadDate: asT<String?>(json['uploadDate']),
        accompanyUserName: asT<String?>(json['accompanyUserName']),
        userName: asT<String?>(json['userName']),
        mainPicUrl: asT<String?>(json['mainPicUrl']),
        taskId: asT<int?>(json['taskId']),
        status: asT<int?>(json['status']),
        vrModelUrl: asT<String?>(json['vrModelUrl']),
        houseId: asT<String?>(json['houseId']),
        houseTitle: asT<String?>(json['houseTitle']),
        roomInfo: asT<String?>(json['roomInfo']),
        buildArea: asT<String?>(json['buildArea']),
        floor: asT<String?>(json['floor']),
        saveDate: asT<String?>(json['saveDate']),
        houseType: asT<String?>(json['houseType']),
        doorFace: asT<int?>(json['doorFace']),
        remark: asT<String?>(json['remark']),
        inputFlies: asT<String?>(json['inputFlies']),
        needMosaic: asT<int?>(json['needMosaic']),
      );

  String? communityName;
  String? uploadDate;
  String? accompanyUserName;
  String? mainPicUrl;
  int? taskId;
  int? status;
  String? vrModelUrl;
  String? houseId;
  String? houseTitle;
  String? roomInfo;
  String? buildArea;
  String? floor;
  String? userName;
  String? saveDate;
  String? houseType;
  int? doorFace;
  String? remark;
  String? inputFlies;
  int? needMosaic;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'communityName': communityName,
    'uploadDate': uploadDate,
    'accompanyUserName': accompanyUserName,
    'mainPicUrl': mainPicUrl,
    'taskId': taskId,
    'status': status,
    'vrModelUrl': vrModelUrl,
    'houseId': houseId,
    'houseTitle': houseTitle,
    'roomInfo': roomInfo,
    'buildArea': buildArea,
    'floor': floor,
    'userName': userName,
    'saveDate': saveDate,
    'houseType': houseType,
    'doorFace': doorFace,
    'remark': remark,
    'inputFlies': inputFlies,
    'needMosaic': needMosaic,
  };

  VRFinishListBean copy() {
    return VRFinishListBean(
      communityName: communityName,
      uploadDate: uploadDate,
      accompanyUserName: accompanyUserName,
      mainPicUrl: mainPicUrl,
      taskId: taskId,
      status: status,
      vrModelUrl: vrModelUrl,
      houseId: houseId,
      houseTitle: houseTitle,
      roomInfo: roomInfo,
      buildArea: buildArea,
      floor: floor,
      userName: userName,
      saveDate: saveDate,
      houseType: houseType,
      doorFace: doorFace,
      remark: remark,
      inputFlies: inputFlies,
      needMosaic: needMosaic,
    );
  }
}
