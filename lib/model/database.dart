import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DataHelper {
  static Future<Database> getDatabase() async {
    final databasePath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(databasePath, 'image_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE images(id INTEGER PRIMARY KEY, title TEXT, image TEXT)',
        );
      },
      version: 1,
    );
  }


  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DataHelper.getDatabase();

    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DataHelper.getDatabase();

    return await db.query(table);

    
  }
  static Future<void> deleteImage(String table,int id) async {
    final db = await DataHelper.getDatabase();

    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
