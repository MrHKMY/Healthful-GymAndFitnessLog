import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calendar/model/activities.dart';

import 'model/userInfo.dart';


class DatabaseHelper {

  static final columnDate = "Date";

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "calendar.db"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY, Activity TEXT, $columnDate TEXT)",
        );
        await db.execute(
          "CREATE TABLE progress (id INTEGER PRIMARY KEY, BodyPart TEXT, Center REAL, Left REAL, Right REAL, Date TEXT)",
        );
        await db.execute(
          "CREATE TABLE userInfo (id INTEGER PRIMARY KEY, Name TEXT, Gender INTEGER, Age INTEGER, Height REAL, Goals TEXT)",
        );
        return db;
      },
      version: 1,
    );
  }

  Future<int> insertActivity(Activities activities) async {
    int actID = 0;
    Database _db = await database();
    await _db.insert("tasks", activities.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      actID = value;
    });
    return actID;
  }

  Future<List<Activities>> retrieveActivity() async {
    Database _db = await database();
    List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT * FROM tasks ORDER BY id DESC");
    return List.generate(activityMap.length, (index) {
      return Activities(id: activityMap[index]["id"], activity: activityMap[index]["Activity"], date: activityMap[index]["Date"]);
    });
  }

  Future<int> insertProgress(Progress progress) async {
    int progressID = 0;
    Database _db = await database();
    await _db.insert("progress", progress.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      progressID = value;
    });
    return progressID;
  }

  Future<List<String>> retrieve2Part(String bodypart) async {
    Database _db = await database();
    String left, right;
    var responseLeft = await _db.rawQuery(
        "SELECT Left FROM progress WHERE BodyPart = '$bodypart'");
    if (responseLeft.length > 0) {
      left = responseLeft.last.values.toString().substring(
          1, responseLeft.last.values
          .toString()
          .length - 1);
      left.substring(2);
      //return left;
    }
    var responseRight = await _db.rawQuery(
        "SELECT Right FROM progress WHERE BodyPart = '$bodypart'");
    if (responseRight.length > 0) {
      right = responseRight.last.values.toString().substring(
          1, responseRight.last.values
          .toString()
          .length - 1);
      right.substring(2);
      //return right;
    }
    return [left, right];
  }

  Future<String> retrieve1Part(String bodypart) async {
    Database _db = await database();
    var response = await _db.rawQuery("SELECT Center FROM progress WHERE BodyPart = '$bodypart'");
    if(response.length > 0) {
      String theProgress = response.last.values.toString().substring(1, response.last.values.toString().length-1);
      theProgress.substring(2);
      return theProgress;
    }
  }

  // Future<int> insertInfo(UserInfo userInfo) async {
  //   int infoID = 0;
  //   Database _db = await database();
  //   await _db.insert("userInfo", userInfo.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
  //     infoID = value;
  //   });
  //   return infoID;
  // }

}
