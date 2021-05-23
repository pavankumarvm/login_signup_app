import 'dart:async';
import 'dart:io' as io;
import 'package:login_signup_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper dbInstance = DatabaseHelper();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE User("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "email TEXT,"
        "password TEXT,"
        "access_token TEXT"
        ")");
    print("Table is created");
  }
}
