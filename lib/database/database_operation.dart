import 'dart:async';
import 'package:login_signup_app/models/user.dart';
import 'database_helper.dart';

class DatabaseOperation {
  final dbInstance = DatabaseHelper.dbInstance;

  Future<int> createUser(User user) async {
    final db = await dbInstance.db;

    var result = db.insert("User", user.toDatabaseJson());
    return result;
  }

  Future<int> deleteUser(int userId) async {
    final db = await dbInstance.db;
    var result =
        await db.delete("User", where: "userId = ?", whereArgs: [userId]);
    return result;
  }

  Future<bool> checkUser(int userId) async {
    final db = await dbInstance.db;
    try {
      List<Map> users =
          await db.query("User", where: 'userId = ?', whereArgs: [userId]);
      if (users.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> hasToken(int userId) async {
    bool result = await checkUser(userId);
    return result;
  }
}
