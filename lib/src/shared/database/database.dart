import 'dart:async';

import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/root_model.dart';
import 'package:drugs_dosage_app/src/shared/providers/bootstrap_query_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../constants/constants.dart';

class DatabaseBroker {
  Future<sqflite.Database> database;
  static final Logger _logger = LogDistributor.getLoggerFor('DatabaseHandler');
  static DatabaseBroker? _instance;

  DatabaseBroker._internal() :
        database = _initDatabase();

  factory DatabaseBroker() {
    _instance ??= DatabaseBroker._internal();
    return _instance!;
  }

  factory DatabaseBroker.initialize() {
    return DatabaseBroker();
  }

  static Future<sqflite.Database> _initDatabase() async {
    String databasePath = join(await sqflite.getDatabasesPath(), Constants.databaseName);
    //TODO REMOVE database delete
    await _deleteDatabaseIfExists(databasePath);

    Future<sqflite.Database> database = sqflite.openDatabase(
      databasePath,
      onCreate: (db, version) {
        _logger.info('Database successfully created');
        return db.execute(BootstrapQueryProvider.getDatabaseBootstrapQuery());
      },
      version: 1,
    );
    return database;
  }

  static Future<void> _deleteDatabaseIfExists(String databasePath) async {

    if (await sqflite.databaseFactory.databaseExists(databasePath)) {
      _logger.info('Deleting database');
      try {
        sqflite.databaseFactory.deleteDatabase(databasePath);
      } catch(e, stackTrace) {
       _logger.severe('Failed to delete database', e, stackTrace);
      }
    }
  }

  Future<void> insert<T extends RootDatabaseModel>(T object,
      [sqflite.ConflictAlgorithm conflictAlgorithm = sqflite.ConflictAlgorithm.replace]) async {
    final db = await database;

    await db.insert(object.getDatabaseName(), object.toMap(), conflictAlgorithm: conflictAlgorithm);
  }

  Future<void> insertAll<T extends RootDatabaseModel>(List<T> objects,
      [sqflite.ConflictAlgorithm conflictAlgorithm = sqflite.ConflictAlgorithm.replace]) async {
    if (objects.isEmpty) {
      return;
    }
    final tableName = objects.first.getDatabaseName();
    final db = await database;

    sqflite.Batch batch = db.batch();
    for (var element in objects) {
      batch.insert(tableName, element.toMap(), conflictAlgorithm: conflictAlgorithm);
    }
    batch.commit();
  }

  Future<List<T>> get<T extends RootDatabaseModel>(
      String tableName, T Function(Map<String, dynamic>) constructorCallback) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => constructorCallback(maps[i]));
  }

  Future<void> update<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    final db = await database;
    object.updateTime = DateTime.now();
    await db.update(object.getDatabaseName(), object.toMap(), where: 'id = ?', whereArgs: [object.id]);
  }

  Future<void> delete<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    final db = await database;
    await db.delete(
      object.getDatabaseName(),
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }
}
