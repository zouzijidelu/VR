import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testt/business/home/bean/vr_need_task_bean.dart';
import 'package:testt/generated/l10n.dart';
import 'package:testt/utils/db/panoinfo_db/vr_panoinfo_bean.dart';
import 'package:testt/utils/vr_utils.dart';
import 'vr_todo_task_bean.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    final boolType = 'BOOLEAN';
    final integerType = 'INTEGER';
    final String primarykeyauto =
        'INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE';
    //'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER)');
    var str =
        '''CREATE TABLE $tableNotes (${VRToDoTaskFields.id} $primarykeyauto,${VRToDoTaskFields.communityName} $textType,${VRToDoTaskFields.saveTime} $textType,${VRToDoTaskFields.uploadTime} $textType,${VRToDoTaskFields.roomInfo} $textType,${VRToDoTaskFields.accompanyUserName} $textType,${VRToDoTaskFields.appointmentTime} $textType,${VRToDoTaskFields.appointmentDate} $textType,${VRToDoTaskFields.floor} $textType,${VRToDoTaskFields.houseType} $integerType, ${VRToDoTaskFields.buildArea} $textType,${VRToDoTaskFields.houseId} $textType,${VRToDoTaskFields.cityId} $integerType,${VRToDoTaskFields.estateId} $textType,${VRToDoTaskFields.houseTypeId} $textType,${VRToDoTaskFields.orderNo} $textType,${VRToDoTaskFields.address} $textType,${VRToDoTaskFields.uploadState} $integerType,${VRToDoTaskFields.doorFace} $integerType,${VRToDoTaskFields.remark} $textType,${VRToDoTaskFields.needMosaic} $integerType,${VRToDoTaskFields.picPointNum} $integerType,${VRToDoTaskFields.filePath} $textType,${VRToDoTaskFields.coverPath} $textType,${VRToDoTaskFields.relativeCoverPath} $textType,${VRToDoTaskFields.homePlan} $textType);''';
    await db.execute(str);
    var str2 =
        '''CREATE TABLE $panoInfoNotes (${PanoInfoFields.id} $primarykeyauto,${PanoInfoFields.houseId} $textType,${PanoInfoFields.fileName} $textType,${PanoInfoFields.filePath} $textType,${PanoInfoFields.relativePath} $textType,${PanoInfoFields.folderPath} $textType,${PanoInfoFields.type} $textType,${PanoInfoFields.floor} $integerType,${PanoInfoFields.needMosaic} $integerType, ${PanoInfoFields.roomTitle} $textType);''';
    await db.execute(str2);
  }

  Future<VRToDoTask> create(VRToDoTask note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy();
  }

  Future<VRToDoTask> insert(VRToDoTask note) async {
    final db = await instance.database;
    Map<String, dynamic> map = note.toJson();
    map.remove('id');
    map['homePlan'] = note.homePlan.toString();
    final id = await db.insert(tableNotes, map);
    return note.copy();
  }

  Future<VRToDoTask> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: VRToDoTaskFields.values,
      where: '${VRToDoTaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return VRToDoTask.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<VRToDoTask>> readAllNotes({bool? asc}) async {
    final db = await instance.database;
    String as = (asc == true)  ? 'ASC' : 'DESC';
    final orderBy = '${VRToDoTaskFields.id} ${as}';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    List<VRToDoTask> tasks = [];
    result.forEach((e) {
      VRToDoTask task = VRToDoTask.fromJson(e);
      String homePlanString = e['homePlan'].toString();
      List homePlans = jsonDecode(homePlanString);
      print('===  ${homePlans.toString()}');
      List<VRNeedTaskListHomePlan> homePlans2 = [];
      homePlans.forEach((element) {
        VRNeedTaskListHomePlan vrNeedTaskListHomePlan =
            VRNeedTaskListHomePlan.fromJson(element);
        homePlans2.add(vrNeedTaskListHomePlan);
      });
      task.homePlan = homePlans2;
      tasks.add(task);
    });
    return tasks.toList();
  }

  Future<int> update(VRToDoTask note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${VRToDoTaskFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> updateHouseId(VRToDoTask note) async {
    Map<String, Object?> map = note.toJson();
    map[VRToDoTaskFields.homePlan] = jsonEncode(note.homePlan);
    final db = await instance.database;
    return db.update(
      tableNotes,
      map,
      where: '${VRToDoTaskFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${VRToDoTaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHouseId(String houseId) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${VRToDoTaskFields.houseId} = ?',
      whereArgs: [houseId],
    );
  }

  ///pano info

  Future<PanoInfoDBBean> createPano(PanoInfoDBBean note) async {
    final db = await instance.database;
    final id = await db.insert(panoInfoNotes, note.toJson());
    return note.copy();
  }

  Future<PanoInfoDBBean> insertPano(PanoInfoDBBean note) async {
    final db = await instance.database;

    Map<String, dynamic> map = note.toJson();
    map.remove('id');
    final id = await db.insert(panoInfoNotes, map);
    return note.copy();
  }

  Future<PanoInfoDBBean> readNotePano(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      panoInfoNotes,
      columns: PanoInfoFields.values,
      where: '${PanoInfoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PanoInfoDBBean.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<PanoInfoDBBean>> readAllNotesPano(
      String houseId, String folderPath) async {
    final db = await instance.database;
    List<Object> whereArgs = [
      houseId,
      folderPath,
    ];
    final maps = await db.query(
      panoInfoNotes,
      columns: PanoInfoFields.values,
      where:
          '${PanoInfoFields.houseId} = ? AND  ${PanoInfoFields.folderPath} = ? ',
      whereArgs: whereArgs,
    );

    return maps.map((json) => PanoInfoDBBean.fromJson(json)).toList();
  }

  Future<int> updatePano(PanoInfoDBBean note) async {
    final db = await instance.database;

    return db.update(
      panoInfoNotes,
      note.toJson(),
      where: '${PanoInfoFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> updateHouseIdPano(PanoInfoDBBean note) async {
    final db = await instance.database;

    return db.update(
      panoInfoNotes,
      note.toJson(),
      where: '${PanoInfoFields.houseId} = ?',
      whereArgs: [note.houseId],
    );
  }

  Future<int> deletePano(int id) async {
    final db = await instance.database;

    return await db.delete(
      panoInfoNotes,
      where: '${PanoInfoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHouseIdPano(String houseId) async {
    final db = await instance.database;

    return await db.delete(
      panoInfoNotes,
      where: '${PanoInfoFields.houseId} = ?',
      whereArgs: [houseId],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
