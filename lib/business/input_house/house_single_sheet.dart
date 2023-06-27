import 'package:bruno/bruno.dart';
import 'package:testt/common/sharedInstance/userInstance.dart';
import 'house_const.dart';

enum VRHouseSingleType{
  doorFaceList,

  otherHouseOption,

}

class VRHouseSingleDelegate implements BrnMultiDataPickerDelegate {
  int firstSelectedIndex = 0;
  int secondSelectedIndex = 0;
  int thirdSelectedIndex = 0;

  VRHouseSingleType singleType;


  VRHouseSingleDelegate(
      {this.firstSelectedIndex = 0, this.secondSelectedIndex = 0,this.singleType = VRHouseSingleType.doorFaceList});


  @override
  int numberOfComponent() {
    return 1;
  }

  List<Map<String, List>> list = HouseConst.doorFaceMaplist;

  @override
  int numberOfRowsInComponent(int component) {
    if (VRHouseSingleType.otherHouseOption == singleType) {
      list = HouseConst.roomNamesListMap(tList: VRUserSharedInstance.instance().otherHomeOption!.data);
    }
    if (0 == component) {
      return list.length;
    } else if (1 == component) {
      Map<String, List> secondMap = list[firstSelectedIndex];
      return secondMap.values.first.length;
    } else {
      Map<String, List> secondMap = list[firstSelectedIndex];
      Map<String, List> thirdMap = secondMap.values.first[secondSelectedIndex];
      return thirdMap.values.first.length;
    }
  }

  @override
  String titleForRowInComponent(int component, int index) {
    if (VRHouseSingleType.otherHouseOption == singleType) {
      list = HouseConst.roomNamesListMap(tList: VRUserSharedInstance.instance().otherHomeOption!.data);
    }

    if (0 == component) {
      return list[index].keys.first;
    } else if (1 == component) {
      Map<String, List> secondMap = list[firstSelectedIndex];
      List secondList = secondMap.values.first;
      return secondList[index].keys.first;
    } else {
      Map<String, List> secondMap = list[firstSelectedIndex];
      Map<String, List> thirdMap = secondMap.values.first[secondSelectedIndex];
      return thirdMap.values.first[index];
    }
  }

  @override
  double? rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    if (0 == component) {
      firstSelectedIndex = row;
    } else if (1 == component) {
      secondSelectedIndex = row;
    } else {
      thirdSelectedIndex = row;
      // debugPrint('_thirdSelectedIndex  is selected to $thirdSelectedIndex');
    }
  }

  @override
  int initSelectedRowForComponent(int component) {
    if (0 == component) {
      return firstSelectedIndex;
    }
    return 0;
  }
}
