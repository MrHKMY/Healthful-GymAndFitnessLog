import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calendar/model/activities.dart';

class DatabaseHelper {

  static final columnDate = "Date";

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "calendar.db"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY, Activity TEXT, $columnDate TEXT)",
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
}
