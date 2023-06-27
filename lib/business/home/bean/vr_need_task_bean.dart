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

class VRNeedTaskBean {
  VRNeedTaskBean({
    this.date,
    this.weekDay,
    this.listCount,
    this.list,
  });

  factory VRNeedTaskBean.fromJson(Map<String, dynamic> json) {
    final List<VRNeedTaskListBean>? list =
    json['list'] is List ? <VRNeedTaskListBean>[] : null;
    if (list != null) {
      for (final dynamic item in json['list']!) {
        if (item != null) {
          tryCatch(() {
            list.add(
                VRNeedTaskListBean.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRNeedTaskBean(
      date: asT<String?>(json['date']),
      weekDay: asT<String?>(json['weekDay']),
      listCount: asT<int?>(json['listCount']),
      list: list,
    );
  }

  String? date;
  String? weekDay;
  int? listCount;
  List<VRNeedTaskListBean>? list;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date,
    'weekDay': weekDay,
    'listCount': listCount,
    'list': list,
  };

  VRNeedTaskBean copy() {
    return VRNeedTaskBean(
      date: date,
      weekDay: weekDay,
      listCount: listCount,
      list: list?.map((VRNeedTaskListBean e) => e.copy()).toList(),
    );
  }
}

class VRNeedTaskListBean {
  VRNeedTaskListBean({
    this.communityName,
    this.houseTitle,
    this.roomInfo,
    this.accompanyUserName,
    this.userName,
    this.appointmentTime,
    this.appointmentDate,
    this.floor,
    this.houseType,
    this.buildArea,
    this.houseId,
    this.orderNo,
    this.doorFace,
    this.doorFaceName,
    this.homePlan,
    this.address,
    this.remark,
  });

  factory VRNeedTaskListBean.fromJson(Map<String, dynamic> json) {
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
    return VRNeedTaskListBean(
      communityName: asT<String?>(json['communityName']),
      houseTitle: asT<String?>(json['houseTitle']),
      roomInfo: asT<String?>(json['roomInfo']),
      accompanyUserName: asT<String?>(json['accompanyUserName']),
      userName: asT<String?>(json['userName']),
      appointmentTime: asT<String?>(json['appointmentTime']),
      appointmentDate: asT<String?>(json['appointmentDate']),
      remark: asT<String?>(json['remark']),
      floor: asT<String?>(json['floor']),
      houseType: asT<int?>(json['houseType']),
      doorFace: asT<int?>(json['houseType']),
      buildArea: asT<String?>(json['buildArea']),
      doorFaceName: asT<String?>(json['doorFaceName']),
      houseId: asT<String?>(json['houseId']),
      orderNo: asT<String?>(json['orderNo']),
      homePlan: homePlan,
      address: asT<String?>(json['address']),
    );
  }

  String? communityName;
  String? houseTitle;
  String? roomInfo;
  String? accompanyUserName;
  String? userName;
  String? appointmentTime;
  String? appointmentDate;
  String? floor;
  int? doorFace;
  int? houseType;
  String? buildArea;
  String? doorFaceName;
  String? houseId;
  String? orderNo;
  String ? remark;
  List<VRNeedTaskListHomePlan>? homePlan;
  String? address;


  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'communityName': communityName,
    'houseTitle': houseTitle,
    'roomInfo': roomInfo,
    'accompanyUserName': accompanyUserName,
    'userName': userName,
    'appointmentTime': appointmentTime,
    'appointmentDate': appointmentDate,
    'floor': floor,
    'doorFace': doorFace,
    'doorFaceName': doorFaceName,
    'houseType': houseType,
    'remark': remark,
    'buildArea': buildArea,
    'houseId': houseId,
    'orderNo': orderNo,
    'homePlan': homePlan,
    'address': address,
  };

  VRNeedTaskListBean copy() {
    return VRNeedTaskListBean(
      communityName: communityName,
      houseTitle: houseTitle,
      roomInfo: roomInfo,
      accompanyUserName: accompanyUserName,
      userName: userName,
      appointmentTime: appointmentTime,
      appointmentDate: appointmentDate,
      doorFace: doorFace,
      doorFaceName: doorFaceName,
      floor: floor,
      houseType: houseType,
      remark: remark,
      buildArea: buildArea,
      houseId: houseId,
      orderNo: orderNo,
      homePlan: homePlan?.map((VRNeedTaskListHomePlan e) => e.copy()).toList(),
      address: address,
    );
  }
}

class VRNeedTaskListHomePlan {
  VRNeedTaskListHomePlan({
    this.name,
    this.weight,
    this.label,
    this.num,
  });

  factory VRNeedTaskListHomePlan.fromJson(Map<String, dynamic> json) =>
      VRNeedTaskListHomePlan(
        name: asT<String?>(json['name']),
        weight: asT<String?>(json['weight']),
        label: asT<String?>(json['label']),
        num: asT<int?>(json['num']),
      );

  String? name;
  String? weight;
  String? label;
  int? num;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'weight': weight,
    'label': label,
    'num': num,
  };

  VRNeedTaskListHomePlan copy() {
    return VRNeedTaskListHomePlan(
      name: name,
      weight: weight,
      label: label,
      num: num,
    );
  }
}
