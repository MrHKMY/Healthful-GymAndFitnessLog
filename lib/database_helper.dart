import 'package:calendar/model/progress.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calendar/model/activities.dart';
import 'package:calendar/model/nutrition.dart';

import 'model/userInfo.dart';


class DatabaseHelper {

  static final columnDate = "Date";

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "calendar.db"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE workout (id INTEGER PRIMARY KEY, Activity TEXT, Focus TEXT, SetCount INTEGER, $columnDate TIMESTAMP DEFAULT (datetime('now','localtime')))",
        );
        await db.execute(
          "CREATE TABLE progress (id INTEGER PRIMARY KEY, BodyPart TEXT, Center REAL, Left REAL, Right REAL, $columnDate TIMESTAMP DEFAULT (datetime('now','localtime')))",
        );
        await db.execute(
          "CREATE TABLE userInfo (id INTEGER PRIMARY KEY, Name TEXT, Gender TEXT, Age INTEGER, Height REAL, Goals TEXT, WorkoutCount INTEGER, WaterCount INTEGER, SupplementCount INTEGER)",
        );
        await db.execute(
          "CREATE TABLE water (id INTEGER PRIMARY KEY, Litre INTEGER, Date TIMESTAMP DEFAULT (datetime('now','localtime')))",
        );
        await db.execute(
          "CREATE TABLE calorie (id INTEGER PRIMARY KEY, Food TEXT, Calorie REAL, Date TIMESTAMP DEFAULT (datetime('now','localtime')))",
        );
        await db.execute(
          "CREATE TABLE supplement (id INTEGER PRIMARY KEY, Supplement TEXT, PostPre TEXT, Date TIMESTAMP DEFAULT (datetime('now','localtime')))",
        );
        return db;
      },
      version: 1,
    );
  }

  Future<int> insertActivity(Activities activities) async {
    int actID = 0;
    Database _db = await database();
    await _db.insert("workout", activities.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      actID = value;
    });
    return actID;
  }

  Future<List<Activities>> retrieveActivity() async {
    Database _db = await database();
    List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT id, Activity, SetCount, Focus, STRFTIME('%d/%m/%Y', Date) AS formattedDate FROM workout ORDER BY id DESC");
    return List.generate(activityMap.length, (index) {
      return Activities(id: activityMap[index]["id"], activity: activityMap[index]["Activity"], date: activityMap[index]["formattedDate"], setCount: activityMap[index]["SetCount"], focus: activityMap[index]["Focus"]);
    });
  }

  // Future<List<Progress>> retrieveActivityForChart( String focus) async {
  //   Database _db = await database();
  //   List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT * FROM workout WHERE Focus = '$focus' ORDER BY id DESC");
  //   return List.generate(activityMap.length, (index) {
  //     return Progress(id: activityMap[index]["id"], activity: activityMap[index]["Activity"], date: activityMap[index]["Date"], setCount: activityMap[index]["SetCount"], focus: activityMap[index]["Focus"]);
  //   });
  // }

  Future<List<Progress>> retrieveWeightForChart(String part) async {
    Database _db = await database();
    List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT id, BodyPart, Center, Left, Right, STRFTIME('%d/%m/%Y', Date) AS formattedDate FROM progress WHERE BodyPart = '$part' ORDER BY id DESC");

    return List.generate(activityMap.length, (index) {
      return Progress(id: activityMap[index]["id"], bodyPart: activityMap[index]["BodyPart"], center: activityMap[index]["Center"], left: activityMap[index]["Left"], right: activityMap[index]["Right"], date: activityMap[index]["formattedDate"]);
    });
  }

  Future<List<Progress>> retrieve2PartsForChart(String part) async {
    Database _db = await database();
    List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT * FROM progress WHERE BodyPart = '$part' ORDER BY id DESC");
    return List.generate(activityMap.length, (index) {
      return Progress(id: activityMap[index]["id"], bodyPart: activityMap[index]["BodyPart"], center: activityMap[index]["Center"], left: activityMap[index]["Left"], right: activityMap[index]["Right"]);
    });
  }


  // Future<List<Activities>> getCharts() async {
  //   var dbClient = await database;
  //   List<Map> maps = await dbClient.query("workout",
  //       columns: ['Date', 'SetCount']);
  //   // Adding the fetched data to the list to bind to the chart.
  //   List<Activities> students = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       students.add(Activities.fromMap(maps[i] as Map<String, dynamic>));
  //     }
  //   }
  //   return students;
  // }

  Future<String> retrieveFocus(String event) async {
    Database _db = await database();
    var response = await _db.rawQuery("SELECT Focus FROM workout WHERE Activity = '$event'");
    String focus;
    if(response.length > 0) {
      focus = response.last.values.toString().substring(1, response.last.values.toString().length-1);
      focus.substring(2);
    }
    return focus;
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

    String theProgress;
    Database _db = await database();
    var response = await _db.rawQuery("SELECT Center FROM progress WHERE BodyPart = '$bodypart'");
    if(response.length > 0) {
      theProgress = response.last.values.toString().substring(1, response.last.values.toString().length-1);
      theProgress.substring(2);
    }
    return theProgress;
  }

  Future<int> insertInfo(UserInfo userInfo) async {
    int infoID = 0;
    Database _db = await database();
    await _db.insert("userInfo", userInfo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      infoID = value;
    });
    return infoID;
  }

  Future<int> updateAgeInfo(int age, double height) async {
    Database _db = await database();
    // await _db.update("userInfo", userInfo.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
    // });
    
    await _db.rawUpdate("UPDATE userInfo SET Age = $age, Height = $height");
  }

  Future<void> updateGoalsInfo(String goal) async {
    Database _db = await database();
    // await _db.update("userInfo", userInfo.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
    // });

    await _db.rawUpdate("UPDATE userInfo SET Goals = '$goal'");
  }

  Future<String> retrieveUserInfo(String info) async {
    String theName;
    Database _db = await database();
    var response = await _db.rawQuery("SELECT $info FROM userInfo");
    if(response.length > 0) {
      theName = response.last.values.toString().substring(1, response.last.values.toString().length-1);
      //theName.substring(2);
    }
    return theName;
  }

  Future<String> retrieveUserInfoWorkCount() async {
    Database _db = await database();
    String workout;
    var response = await _db.rawQuery("SELECT WorkoutCount FROM userInfo");
    if(response.length > 0) {
      workout =
          response.last.values.toString().substring(1, response.last.values.toString().length - 1);
    }
    return workout;
  }

  Future<String> retrieveUserInfoWaterCount() async {
    Database _db = await database();
    String water;
    var response = await _db.rawQuery("SELECT WaterCount FROM userInfo");
    if(response.length > 0) {
      water =
          response.last.values.toString().substring(1, response.last.values.toString().length - 1);
    }
    return water;
  }

  Future<String> retrieveUserInfoSupplementCount() async {
    Database _db = await database();
    String supplement;
    var response = await _db.rawQuery("SELECT SupplementCount FROM userInfo");
    if(response.length > 0) {
      supplement =
          response.last.values.toString().substring(1, response.last.values.toString().length - 1);
    }
    return supplement;
  }

  Future<int> insertWater(Water water) async {
    int actID = 0;
    Database _db = await database();
    await _db.insert("water", water.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      actID = value;
    });
    return actID;
  }

  Future<int> insertCalorie(Calorie calorie) async {
    int actID = 0;
    Database _db = await database();
    await _db.insert("calorie", calorie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      actID = value;
    });
    return actID;
  }

  Future<int> insertSupplement(Supplement supplement) async {
    int actID = 0;
    Database _db = await database();
    await _db.insert("supplement", supplement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      actID = value;
    });
    return actID;
  }

  Future<String> retrieveWater() async {
    String theWater;
    Database _db = await database();
    var response = await _db.rawQuery("SELECT SUM (Litre) FROM water WHERE DATE(Date) = DATE('now','localtime')");
    if(response.length > 0) {
      theWater = response.last.values.toString().substring(1, response.last.values.toString().length-1);
      //theWater.substring(2);
    }
    return theWater;
  }

  Future<List<Supplement>> retrieveSupplement() async {
    Database _db = await database();
    List<Map<String, dynamic>> activityMap = await _db.rawQuery("SELECT * FROM supplement WHERE DATE(Date) = DATE('now','localtime')");
    return List.generate(activityMap.length, (index) {
      return Supplement(id: activityMap[index]["id"], supplement: activityMap[index]["Supplement"], type: activityMap[index]["PostPre"]);
    });
  }

  Future<String> retrieveSuppCount() async {
    String theSupp;
    Database _db = await database();
    var response = await _db.rawQuery("SELECT COUNT (*) FROM supplement WHERE DATE(Date) = DATE('now','localtime')");
    if(response.length > 0) {
      theSupp= response.last.values.toString().substring(1, response.last.values.toString().length-1);
      //theWater.substring(2);
    }
    return theSupp;
  }

  Future<String> retrieveWorkoutCount() async {
    String theWorkoutCount;
    Database _db = await database();
    var response = await _db.rawQuery("SELECT COUNT (*) FROM (SELECT * FROM workout GROUP BY Date) A WHERE DATE(Date) >= DATE('now', 'weekday 0', '-7 days')");
    if(response.length > 0) {
      theWorkoutCount= response.last.values.toString().substring(1, response.last.values.toString().length-1);
    }
    return theWorkoutCount;
  }

}
