import 'package:testt/business/home/bean/vr_need_task_bean.dart';

class TransVRHomePlan {
  static List<String> roomList = ['客厅', '厨房', '卫生间', '阳台', '卧室', '过道', '其他'];

  static List<Map<String, dynamic>> roomMapList = [
    {"label": "living_room", "name": "客厅", "num": 1},
    {"label": "kitchen", "name": "厨房", "num": 1},
    {"label": "toilet", "name": "卫生间", "num": 2},
    {"label": "bedroom", "name": "卧室", "num": 3},
    {"label": "corridor", "name": "过道", "num": 1},
    {"label": "other_room", "name": "其他", "num": 1},
    {"label": "balcony", "name": "阳台", "num": 0}
  ];

  List<VRNeedTaskListHomePlan> roomBeanList() {
    List<VRNeedTaskListHomePlan> list = [];
    TransVRHomePlan.roomMapList.forEach((element) {
      list.add((VRNeedTaskListHomePlan.fromJson(element)));
    });
    return list;
  }

  List<VRNeedTaskListHomePlan> getHomePlane(VRNeedTaskListBean listBean) {
    List<VRNeedTaskListHomePlan> list = TransVRHomePlan().roomBeanList();
    list.forEach((element) {
      switch (element.label) {
        case 'living_room':
          {
            // element.num =
          }
          break;
        default:
          {}
          break;
      }
    });
    return list;
  }
}
