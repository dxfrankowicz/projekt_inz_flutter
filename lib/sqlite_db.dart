import 'dart:io';

import 'package:path/path.dart';
import 'package:projekt_inz/model/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  List<User> testUsers = [
    User(firstName: "Adam", lastName: "Joe"),
    User(firstName: "Joe", lastName: "Smith"),
    User(firstName: "Greg", lastName: "Novak"),
    User(firstName: "Adam", lastName: "Smith"),
    User(firstName: "Sean", lastName: "Connery"),
    User(firstName: "Adam", lastName: "Joe"),
    User(firstName: "Joe", lastName: "Smith"),
    User(firstName: "Greg", lastName: "Novak"),
    User(firstName: "Adam", lastName: "Smith"),
    User(firstName: "Sean", lastName: "Connery"),
  ];

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB12.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE users (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT);");
      testUsers.forEach((user) async {
        await db.execute(
            "INSERT INTO Users (first_name, last_name) VALUES ('${user.firstName}', '${user.lastName}');");
      });
    });
  }

  //INSERT
  addUser(User newUser) async {
    final db = await database;
    var res = await db.insert("users", newUser.toJson());
    return res;
  }

  //GET
  getAllUsers() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * from users");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromJson(c)).toList() : [];
    return list;
  }

  //DELTE
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from users");
  }
}
