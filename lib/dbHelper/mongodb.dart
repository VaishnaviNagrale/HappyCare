import 'dart:developer';
import 'package:happycare/dbHelper/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Db? _db;
  static String connectionString = MONGO_CONN_URL;
  static Future<Db> connect() async {
    if (_db == null) {
      _db = await Db.create(connectionString);
      await _db!.open();
      inspect(_db);
    }
    return _db!;
  }

  static Db getDatabase() {
    if (_db == null) {
      throw Exception("Database not connected. Call connect() first.");
    }
    return _db!;
  }

  static Future<void> closeConnection() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
