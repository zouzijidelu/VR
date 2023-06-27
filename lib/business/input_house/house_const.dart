class HouseConst {
  static Map houseTypeMap = {'1': '二手房', '2': '普租', '3': '新房', '4': '相寓'};

  static String houseTypeString({String? type}) {
    int num = (int.parse(type ?? '0') ?? 0);
    if (num < 5) {
      return houseTypeMap[num.toString()] ?? '二手房';
    }
    return '二手房';
  }

  static List<String> roomNamesList = [
    "杂物间",
    "儿童房",
    "门厅",
    "阳光房",
    "露台",
    "花园",
    "车库",
    "茶室",
    "棋牌室",
    "健身房",
    "影音室",
    "设备间",
    "起居室",
    "酒窖",
    "桑拿房",
    "老人房",
    "保姆房",
    "洗衣房",
    "休闲区",
    "玄关",
    "书房",
    "储物室",
    "衣帽间"
  ];

  static List<Map<String, List>> roomNamesListMap({List? tList}) {
    int index = 0;
    List? tmlist = tList;
    List<Map<String, List>> list = [];
    if (tmlist!.isEmpty) {
      tmlist = HouseConst.roomNamesList;
    }

    tmlist.forEach((element) {
      list.add({
        element: ['${index}']
      });
      index++;
    });
    return list;
  }

  ///入户门常量
  static const List<String> doorFaceList = [
    '东',
    '南',
    '西',
    '北',
    '东南',
    '东北',
    '西南',
    '西北'
  ];

  static const List<Map<String, List>> doorFaceMaplist = [
    {
      '东': ['1']
    },
    {
      '南': ['2']
    },
    {
      '西': ['3']
    },
    {
      '北': ['4']
    },
    {
      '东南': ['5']
    },
    {
      '东北': ['6']
    },
    {
      '西南': ['7']
    },
    {
      '西北': ['8']
    },
  ];

  static Map<String, String> doorFaceBean(String key) {
    List listValue = [];

    doorFaceMaplist.forEach((e) {
      if (e[key] != null && e[key] != []) {
        listValue = e[key]!;
      }
    });
    return {'name': key, 'value': listValue.first.toString()};
  }

  static String doorFaceString(String key) {
    List listValue = [];

    doorFaceMaplist.forEach((e) {
      if (e[key] != null && e[key] != []) {
        listValue = e[key]!;
      }
    });
    return listValue.first.toString();
  }

  ///视频制作
  static String getDoorFaceName(int doorFace) {
    if (doorFace > 0) {
      return doorFaceList[(doorFace - 1)];
    } else {
      return '';
    }
  }

  ///视频制作
  static String makeCaptureString(int status) {
    if (status == 1) {
      return '正在制作';
    } else if (status == 2) {
      return '制作成功';
    } else if (status == 2) {
      return '制作失败';
    } else {
      return '';
    }
  }

  static String quickString = "" +
      "{\n" +
      "    \"communityName\": \"天通苑西三区\", \n" +
      "    \"roomInfo\": \"3室0厅1厨1卫0阳\", \n" +
      "    \"accompanyUserName\": \"-\", \n" +
      "    \"appointmentTime\": \"-\", \n" +
      "    \"appointmentDate\": \"-\", \n" +
      "    \"floor\": \"-\", \n" +
      "    \"houseType\": 4, \n" +
      "    \"buildArea\": \"81平方米\", \n" +
      "    \"houseId\": \"FY1000542339\", \n" +
      "    \"orderNo\": \"SKDD2022110911181058\", \n" +
      "    \"homePlan\": [\n" +
      "        {\n" +
      "            \"name\": \"客厅\", \n" +
      "            \"weight\": \"1\", \n" +
      "            \"label\": \"living_room\", \n" +
      "            \"num\": 1\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"厨房\", \n" +
      "            \"weight\": \"2\", \n" +
      "            \"label\": \"kitchen\", \n" +
      "            \"num\": 1\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"卫生间\", \n" +
      "            \"weight\": \"3\", \n" +
      "            \"label\": \"toilet\", \n" +
      "            \"num\": 1\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"卧室\", \n" +
      "            \"weight\": \"5\", \n" +
      "            \"label\": \"bedroom\", \n" +
      "            \"num\": 3\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"过道\", \n" +
      "            \"weight\": \"6\", \n" +
      "            \"label\": \"corridor\", \n" +
      "            \"num\": 1\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"其他\", \n" +
      "            \"weight\": \"7\", \n" +
      "            \"label\": \"other_room\", \n" +
      "            \"num\": 0\n" +
      "        }, \n" +
      "        {\n" +
      "            \"name\": \"阳台\", \n" +
      "            \"weight\": 11, \n" +
      "            \"label\": \"balcony\", \n" +
      "            \"num\": 0\n" +
      "        }\n" +
      "    ], \n" +
      "    \"address\": \"天通苑西三区35号楼5单元1102号房\"\n" +
      "}";

}
