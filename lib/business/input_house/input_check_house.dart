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

class VRCheckHouseInfo {
  VRCheckHouseInfo({
    this.houseId,
    this.communityName,
    this.buildArea,
    this.floor,
    this.roomInfo,
    this.cityId,
    this.address,
    this.homePlan,
    this.houseTypeId,
    this.estateId,
    this.houseType,
    this.orderNo,
    this.accompanyUserName,
    this.appointmentTime,
    this.appointmentDate,
  });

  factory VRCheckHouseInfo.fromJson(Map<String, dynamic> json) {
    final List<VRCheckHouseInfoHomePlan>? homePlan =
    json['homePlan'] is List ? <VRCheckHouseInfoHomePlan>[] : null;
    if (homePlan != null) {
      for (final dynamic item in json['homePlan']!) {
        if (item != null) {
          tryCatch(() {
            homePlan.add(VRCheckHouseInfoHomePlan.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRCheckHouseInfo(
      houseId: asT<String?>(json['houseId']),
      communityName: asT<String?>(json['communityName']),
      buildArea: asT<String?>(json['buildArea']),
      floor: asT<String?>(json['floor']),
      roomInfo: asT<String?>(json['roomInfo']),
      cityId: asT<int?>(json['cityId']),
      address: asT<String?>(json['address']),
      homePlan: homePlan,
      houseTypeId: asT<String?>(json['houseTypeId']),
      estateId: asT<String?>(json['estateId']),
      houseType: asT<String?>(json['houseType']),
      orderNo: asT<String?>(json['orderNo']),
      accompanyUserName: asT<String?>(json['accompanyUserName']),
      appointmentTime: asT<String?>(json['appointmentTime']),
      appointmentDate: asT<String?>(json['appointmentDate']),
    );
  }

  String? houseId;
  String? communityName;
  String? buildArea;
  String? floor;
  String? roomInfo;
  int? cityId;
  String? address;
  List<VRCheckHouseInfoHomePlan>? homePlan;
  String? houseTypeId;
  String? estateId;
  String? houseType;
  String? orderNo;
  String? accompanyUserName;
  String? appointmentTime;
  String? appointmentDate;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'houseId': houseId,
    'communityName': communityName,
    'buildArea': buildArea,
    'floor': floor,
    'roomInfo': roomInfo,
    'cityId': cityId,
    'address': address,
    'homePlan': homePlan,
    'houseTypeId': houseTypeId,
    'estateId': estateId,
    'houseType': houseType,
    'orderNo': orderNo,
    'accompanyUserName': accompanyUserName,
    'appointmentTime': appointmentTime,
    'appointmentDate': appointmentDate,
  };

  VRCheckHouseInfo copy() {
    return VRCheckHouseInfo(
      houseId: houseId,
      communityName: communityName,
      buildArea: buildArea,
      floor: floor,
      roomInfo: roomInfo,
      cityId: cityId,
      address: address,
      homePlan:
      homePlan?.map((VRCheckHouseInfoHomePlan e) => e.copy()).toList(),
      houseTypeId: houseTypeId,
      estateId: estateId,
      houseType: houseType,
      orderNo: orderNo,
      accompanyUserName: accompanyUserName,
      appointmentTime: appointmentTime,
      appointmentDate: appointmentDate,
    );
  }
}

class VRCheckHouseInfoHomePlan {
  VRCheckHouseInfoHomePlan({
    this.name,
    this.num,
    this.label,
  });

  factory VRCheckHouseInfoHomePlan.fromJson(Map<String, dynamic> json) =>
      VRCheckHouseInfoHomePlan(
        name: asT<String?>(json['name']),
        num: asT<String?>(json['num']),
        label: asT<String?>(json['label']),
      );

  String? name;
  String? num;
  String? label;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'num': num,
    'label': label,
  };

  VRCheckHouseInfoHomePlan copy() {
    return VRCheckHouseInfoHomePlan(
      name: name,
      num: num,
      label: label,
    );
  }
}
