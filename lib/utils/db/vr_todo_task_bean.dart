import 'dart:convert';
import 'dart:developer';

import '../../business/home/bean/vr_need_task_bean.dart';

final String tableNotes = 'ToDoTaskItem';

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

class VRToDoTaskFields {
  static final String communityName = 'communityName';
  static final String roomInfo = 'roomInfo';
  static final String accompanyUserName = 'accompanyUserName';
  static final String appointmentTime = 'appointmentTime';
  static final String appointmentDate = 'appointmentDate';
  static final String floor = 'floor';
  static final String houseType = 'houseType';
  static final String buildArea = 'buildArea';
  static final String houseId = 'houseId';
  static final String cityId = 'cityId';
  static final String estateId = 'estateId';
  static final String houseTypeId = 'houseTypeId';
  static final String orderNo = 'orderNo';
  static final String address = 'address';
  static final String uploadState = 'uploadState';
  static final String doorFace = 'doorFace';
  static final String saveTime = 'saveTime';
  static final String uploadTime = 'uploadTime';
  static final String remark = 'remark';
  static final String needMosaic = 'needMosaic';
  static final String picPointNum = 'picPointNum';
  static final String picPoStringNum = 'picPoStringNum';
  static final String filePath = 'filePath';
  static final String coverPath = 'coverPath';
  static final String relativeCoverPath = 'relativeCoverPath';
  static final String homePlan = 'homePlan';
  static final String id = 'id';

  static final List<String> values = [
    /// Add all fields
    communityName,
    roomInfo,
    accompanyUserName,
    appointmentTime,
    appointmentDate,
    floor,
    houseType,
    buildArea,
    houseId,
    saveTime,
    uploadTime,
    cityId,
    estateId,
    houseTypeId,
    orderNo,
    address,
    uploadState,
    doorFace,
    remark,
    needMosaic,
    picPointNum,
    filePath,
    coverPath,
    relativeCoverPath,
    homePlan,
    id
  ];
}

class VRToDoTask {
  VRToDoTask({
    this.communityName,
    this.roomInfo,
    this.accompanyUserName,
    this.appointmentTime,
    this.appointmentDate,
    this.saveTime,
    this.uploadTime,
    this.floor,
    this.houseType,
    this.buildArea,
    this.houseId,
    this.cityId,
    this.estateId,
    this.houseTypeId,
    this.orderNo,
    this.address,
    this.uploadState,
    this.doorFace,
    this.remark,
    this.needMosaic,
    this.picPointNum,
    this.filePath,
    this.coverPath,
    this.relativeCoverPath,
    this.homePlan,
    this.id,
  });

  factory VRToDoTask.fromJson(Map<String, dynamic> json) {
    final List<VRNeedTaskListHomePlan>? homePlan =
        json['homePlan'] is List ? <VRNeedTaskListHomePlan>[] : null;
    if (homePlan != null) {
      for (final dynamic item in json['homePlan']!) {
        if (item != null) {
          tryCatch(() {
            homePlan.add(VRNeedTaskListHomePlan.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRToDoTask(
      communityName: asT<String?>(json['communityName']),
      roomInfo: asT<String?>(json['roomInfo']),
      accompanyUserName: asT<String?>(json['accompanyUserName']),
      appointmentTime: asT<String?>(json['appointmentTime']),
      appointmentDate: asT<String?>(json['appointmentDate']),
      saveTime: asT<String?>(json['saveTime']),
      uploadTime: asT<String?>(json['uploadTime']),
      floor: asT<String?>(json['floor']),
      houseType: asT<int?>(json['houseType']),
      buildArea: asT<String?>(json['buildArea']),
      houseId: asT<String?>(json['houseId']),
      cityId: asT<int?>(json['cityId']),
      estateId: asT<String?>(json['estateId']),
      houseTypeId: asT<String?>(json['houseTypeId']),
      orderNo: asT<String?>(json['orderNo']),
      address: asT<String?>(json['address']),
      uploadState: asT<int?>(json['uploadState']),
      doorFace: asT<int?>(json['doorFace']),
      remark: asT<String?>(json['remark']),
      needMosaic: asT<int?>(json['needMosaic']),
      picPointNum: asT<int?>(json['picPointNum']),
      filePath: asT<String?>(json['filePath']),
      coverPath: asT<String?>(json['coverPath']),
      relativeCoverPath: asT<String?>(json['relativeCoverPath']),
      homePlan: homePlan,
      id: asT<String?>(json['id']),
    );
  }

  String? communityName;
  String? roomInfo;
  String? accompanyUserName;
  String? appointmentTime;
  String? saveTime;
  String? uploadTime;
  String? appointmentDate;
  String? floor;
  int? houseType;
  String? buildArea;
  String? houseId;
  int? cityId;
  String? estateId;
  String? houseTypeId;
  String? orderNo;
  String? address;
  int? uploadState;
  int? doorFace;
  String? remark;
  int? needMosaic;
  int? picPointNum;
  String? filePath;
  String? coverPath;
  String? relativeCoverPath;
  List<VRNeedTaskListHomePlan>? homePlan;
  String? id;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'communityName': communityName,
        'roomInfo': roomInfo,
        'accompanyUserName': accompanyUserName,
        'appointmentTime': appointmentTime,
        'saveTime': saveTime,
        'uploadTime': uploadTime,
        'appointmentDate': appointmentDate,
        'floor': floor,
        'houseType': houseType,
        'buildArea': buildArea,
        'houseId': houseId,
        'cityId': cityId,
        'estateId': estateId,
        'houseTypeId': houseTypeId,
        'orderNo': orderNo,
        'address': address,
        'uploadState': uploadState,
        'doorFace': doorFace,
        'remark': remark,
        'needMosaic': needMosaic,
        'picPointNum': picPointNum,
        'filePath': filePath,
        'coverPath': coverPath,
        'relativeCoverPath': relativeCoverPath,
        'homePlan': homePlan,
        'id': id,
      };

  VRToDoTask copy() {
    return VRToDoTask(
      communityName: communityName,
      roomInfo: roomInfo,
      accompanyUserName: accompanyUserName,
      appointmentTime: appointmentTime,
      saveTime: saveTime,
      uploadTime: uploadTime,
      appointmentDate: appointmentDate,
      floor: floor,
      houseType: houseType,
      buildArea: buildArea,
      houseId: houseId,
      cityId: cityId,
      estateId: estateId,
      houseTypeId: houseTypeId,
      orderNo: orderNo,
      address: address,
      uploadState: uploadState,
      doorFace: doorFace,
      remark: remark,
      needMosaic: needMosaic,
      picPointNum: picPointNum,
      filePath: filePath,
      coverPath: coverPath,
      relativeCoverPath: relativeCoverPath,
      homePlan: homePlan?.map((VRNeedTaskListHomePlan e) => e.copy()).toList(),
      id: id,
    );
  }
}
