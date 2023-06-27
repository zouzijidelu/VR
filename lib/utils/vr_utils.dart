import 'dart:convert' as convert;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:testt/utils/db/panoinfo_db/vr_panoinfo_bean.dart';
import 'package:testt/utils/db/vr_todo_task_db.dart';

class VRUtils {
  static Future writeInRoomTxt(String houseId, String folderPath) async {
    print("writeInRoomTxt houseId" + houseId + " folderPath" + folderPath);
    List<PanoInfoDBBean> panoInfos =
        await NotesDatabase.instance.readAllNotesPano(houseId, folderPath);
    print("writeInRoomTxt panoInfos${convert.json.encode(panoInfos)}");
    if (panoInfos != null && !panoInfos.isEmpty) {
      var roomFile = File("$folderPath/room.txt");
      var sink = roomFile.openWrite();
      var buffer = StringBuffer();
      try {
        for (final PanoInfoDBBean panoInfo in panoInfos) {
          buffer.clear();
          buffer.write(panoInfo.fileName);
          buffer.write(" ");
          buffer.write(panoInfo.roomTitle);
          sink.write(buffer.toString());
          sink.write("\n");
          await sink.flush();
        }
        await sink.close();
      } catch (e) {
        print(e);
      }
    }else{
      print("panoInfos == null || panoInfos.isEmpty");

    }
  }

  static Future writeInConfigGson(String folderPath) async {
    var roomFile = File("$folderPath/config.json");
    var sink = roomFile.openWrite();
    var buffer = StringBuffer();
    try {
      buffer.write('{"isCheck":false,"cameraHeight":1470}');
      sink.write(buffer.toString());
      await sink.flush();
      await sink.close();
    } catch (e) {
      print(e);
    }
  }

  static Map<String, dynamic> JsonStringToMap(String jsonString) {
    Map<String, dynamic> map = convert.jsonDecode(jsonString);

    return map;
  }

  static List JsonStringToList(String jsonString) {
    List list = convert.jsonDecode(jsonString);

    return list;
  }


  ///根据数据库的路径生成 相对路径，因为ios的路径是动态变化的
  static Future<String> pathRealPath(String path) async {
    var appDocDir = await getTemporaryDirectory();
    String realPath = appDocDir.path;
    if (Platform.isAndroid) {
      realPath = realPath.replaceAll('cache', 'files');
    }
    return realPath ?? '';
  }

  ///根据数据库的路径生成 相对路径，因为ios的路径是动态变化的
  static Future<String> pathToRealPath(String path) async {
    String realPath = await pathRealPath(path);
    List<String> pathlist = path.split('/');
    for (int index = 0; index < (pathlist.length ?? 0); index++) {
      if (pathlist[index] == 'pano_original') {
        realPath =
            '${realPath}/${pathlist[(index - 1)]}/${pathlist[index]}/${pathlist[(index + 1)]}';
        break;
      }
    }
    return realPath ?? '';
  }

  static Future<String> pathTothumbnail(String path) async {
    var appDocDir = await getTemporaryDirectory();
    String realPath = appDocDir.path;
    List<String> pathlist = path.split('/');
    for (int index = 0; index < (pathlist.length ?? 0); index++) {
      if (pathlist[index] == 'pano_original') {
        realPath =
            '${realPath}/thumbnail/${pathlist[(index - 1)]}/${pathlist[index]}/thumbnail.png';
        break;
      }
    }

    return realPath ?? '';
  }

  ///获取check roomtet地址
  static Future<bool> pathCheckRoomJson(String path) async {
    String realPath = await pathRealPath(path);
    String roomtext = '/room.txt';
    String realRooomTextPath = '';
    List<String> pathlist = path.split('/');
    for (int index = 0; index < (pathlist.length ?? 0); index++) {
      if (pathlist[index] == 'pano_original') {
        realRooomTextPath = '${realPath}/${pathlist[(index - 1)]}${roomtext}';
        break;
      }
    }
    var dir_bool = await checkFile(realRooomTextPath ?? '');
    return dir_bool;
  }

  ///获取check roomjson地址
  static Future<String> getTemporaryTimeSp(String path) async {
    String realPath = await pathRealPath(path);
    List<String> pathlist = path.split('/');
    for (int index = 0; index < (pathlist.length ?? 0); index++) {
      if (pathlist[index] == 'pano_original') {
        realPath = '${realPath}/${pathlist[(index - 1)]}';
        break;
      }
    }
    return realPath;
  }

  static Future<bool> checkFile(String path) async {
    File txt = File(path);
    var dir_bool = await txt.exists(); //返回真假
    return dir_bool;
  }
}
