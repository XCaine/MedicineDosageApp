import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../classes/medicine.dart';

class DatabaseHandler {
  late Future<sqflite.Database> database;
  DatabaseHandler() {
    database = initDatabase();
  }

  Future<sqflite.Database> initDatabase() async {
    //TODO REMOVE
    String databasePath = join(await sqflite.getDatabasesPath(), 'medical_app_database.db');
    if(await sqflite.databaseFactory.databaseExists(databasePath)) {
      sqflite.databaseFactory.deleteDatabase(databasePath);
    }

    return sqflite.openDatabase(
      databasePath,
      onCreate: (db, version) {

        return db.execute(
          Medicine.getCreateTableQuery(),
        );
      },
      version: 1,
    );
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;

    await db.insert(
      'medicine',
      medicine.toMap(),
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> fetchMedicine() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('medicine');

    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        productIdentifier: maps[i]['productIdentifier'],
        productName: maps[i]['productName'],
      );
    });
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;

    await db.update(
      'medicine',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete(
      'medicine',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
