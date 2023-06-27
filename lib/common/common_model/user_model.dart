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

class VRUserModel {
  VRUserModel({
    this.token,
    this.userId,
    this.cityId,
    this.userName,
    this.gender,
    this.role,
    this.genderName,
    this.positionInfo,
    this.corpName,
    this.jobs,
  });

  factory VRUserModel.fromJson(Map<String, dynamic> json) {
    final List<Jobs>? jobs = json['jobs'] is List ? <Jobs>[] : null;
    if (jobs != null) {
      for (final dynamic item in json['jobs']!) {
        if (item != null) {
          tryCatch(() {
            jobs.add(Jobs.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRUserModel(
      token: asT<String?>(json['token']),
      userId: asT<int?>(json['userId']),
      cityId: asT<int?>(json['cityId']),
      userName: asT<String?>(json['userName']),
      gender: asT<int?>(json['gender']),
      role: asT<int?>(json['role']),
      genderName: asT<String?>(json['genderName']),
      positionInfo: asT<String?>(json['positionInfo']),
      corpName: asT<String?>(json['corpName']),
      jobs: jobs,
    );
  }

  String? token;
  int? userId;
  int? cityId;
  String? userName;
  int? gender;
  int? role;
  String? genderName;
  String? positionInfo;
  String? corpName;
  List<Jobs>? jobs;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'userId': userId,
    'cityId': cityId,
    'userName': userName,
    'gender': gender,
    'genderName': genderName,
    'positionInfo': positionInfo,
    'corpName': corpName,
    'role': role,
    'jobs': jobs,
  };

  VRUserModel copy() {
    return VRUserModel(
      token: token,
      userId: userId,
      cityId: cityId,
      userName: userName,
      gender: gender,
      genderName: genderName,
      role: role,
      positionInfo: positionInfo,
      corpName: corpName,
      jobs: jobs?.map((Jobs e) => e.copy()).toList(),
    );
  }
}

class Jobs {
  Jobs({
    this.companyName,
    this.jobName,
    this.cityId,
    this.cityName,
    this.postRcd,
    this.role,
    this.postRcdName,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
    companyName: asT<String?>(json['companyName']),
    jobName: asT<String?>(json['jobName']),
    cityId: asT<int?>(json['cityId']),
    cityName: asT<String?>(json['cityName']),
    postRcd: asT<int?>(json['postRcd']),
    role: asT<int?>(json['role']),
    postRcdName: asT<String?>(json['postRcdName']),
  );

  String? companyName;
  String? jobName;
  int? cityId;
  String? cityName;
  int? postRcd;
  int? role;
  String? postRcdName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'companyName': companyName,
    'jobName': jobName,
    'cityId': cityId,
    'cityName': cityName,
    'postRcd': postRcd,
    'role': role,
    'postRcdName': postRcdName,
  };

  Jobs copy() {
    return Jobs(
      companyName: companyName,
      jobName: jobName,
      cityId: cityId,
      cityName: cityName,
      postRcd: postRcd,
      role:role,
      postRcdName: postRcdName,
    );
  }
}
