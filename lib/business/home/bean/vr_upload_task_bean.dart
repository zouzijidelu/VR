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

class VRUploadTaskBean {
  VRUploadTaskBean({
    this.listCount,
    this.list,
  });

  factory VRUploadTaskBean.fromJson(Map<String, dynamic> json) {
    final List<VRUploadTaskListBean>? list =
    json['list'] is List ? <VRUploadTaskListBean>[] : null;
    if (list != null) {
      for (final dynamic item in json['list']!) {
        if (item != null) {
          tryCatch(() {
            list.add(VRUploadTaskListBean.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VRUploadTaskBean(
      listCount: asT<int?>(json['listCount']),
      list: list,
    );
  }

  int? listCount;
  List<VRUploadTaskListBean>? list;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'listCount': listCount,
    'list': list,
  };

  VRUploadTaskBean copy() {
    return VRUploadTaskBean(
      listCount: listCount,
      list: list?.map((VRUploadTaskListBean e) => e.copy()).toList(),
    );
  }
}

class VRUploadTaskListBean {
  VRUploadTaskListBean({
    this.communityName,
    this.accompanyUserName,
    this.uploadDate,
    this.mainPicUrl,
    this.taskId,
    this.status,
    this.vrModelUrl,
  });

  factory VRUploadTaskListBean.fromJson(Map<String, dynamic> json) =>
      VRUploadTaskListBean(
        communityName: asT<String?>(json['communityName']),
        accompanyUserName: asT<String?>(json['accompanyUserName']),
        uploadDate: asT<String?>(json['uploadDate']),
        mainPicUrl: asT<String?>(json['mainPicUrl']),
        taskId: asT<int?>(json['taskId']),
        status: asT<int?>(json['status']),
        vrModelUrl: asT<String?>(json['vrModelUrl']),
      );

  String? communityName;
  String? accompanyUserName;
  String? uploadDate;
  String? mainPicUrl;
  int? taskId;
  int? status;
  String? vrModelUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'communityName': communityName,
    'accompanyUserName': accompanyUserName,
    'uploadDate': uploadDate,
    'mainPicUrl': mainPicUrl,
    'taskId': taskId,
    'status': status,
    'vrModelUrl': vrModelUrl,
  };

  VRUploadTaskListBean copy() {
    return VRUploadTaskListBean(
      communityName: communityName,
      accompanyUserName: accompanyUserName,
      uploadDate: uploadDate,
      mainPicUrl: mainPicUrl,
      taskId: taskId,
      status: status,
      vrModelUrl: vrModelUrl,
    );
  }
}
