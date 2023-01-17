import 'dart:async';

import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/providers/database/bootstrap_query_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../constants/constants.dart';

class DatabaseBroker {
  Future<sqflite.Database> database;
  static final Logger _logger = LogDistributor.getLoggerFor('DatabaseHandler');
  static DatabaseBroker? _instance;

  DatabaseBroker._internal() : database = _initDatabase();

  factory DatabaseBroker() {
    _instance ??= DatabaseBroker._internal();
    return _instance!;
  }

  factory DatabaseBroker.initialize() {
    return DatabaseBroker();
  }

  static Future<sqflite.Database> _initDatabase() async {
    String databasePath =
        join(await sqflite.getDatabasesPath(), Constants.databaseName);
    //TODO REMOVE database delete
    //await _dropDatabaseIfExists(databasePath);

    Future<sqflite.Database> database = sqflite.openDatabase(
      databasePath,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        _logger.info('Database successfully created');
        List<String> bootstrapQueries = BootstrapQueryProvider().provide();
        for(String query in bootstrapQueries) {
          await db.execute(query);
        }
      },
      version: 1,
    );
    return database;
  }

  static Future<void> _dropDatabaseIfExists(String databasePath) async {
    if (await sqflite.databaseFactory.databaseExists(databasePath)) {
      _logger.info('Deleting database');
      try {
        sqflite.databaseFactory.deleteDatabase(databasePath);
      } catch (e, stackTrace) {
        _logger.severe('Failed to delete database', e, stackTrace);
      }
    }
  }

  Future<void> insert<T extends RootDatabaseModel>(T object,
      [sqflite.ConflictAlgorithm conflictAlgorithm =
          sqflite.ConflictAlgorithm.replace]) async {
    final db = await database;

    await db.insert(object.getTableName(), object.toMap(),
        conflictAlgorithm: conflictAlgorithm);
  }

  Future<void> insertAll<T extends RootDatabaseModel>(List<T> objects,
      [sqflite.ConflictAlgorithm conflictAlgorithm =
          sqflite.ConflictAlgorithm.replace]) async {
    if (objects.isEmpty) {
      return;
    }
    final tableName = objects.first.getTableName();
    final db = await database;

    sqflite.Batch batch = db.batch();
    for (var element in objects) {
      batch.insert(tableName, element.toMap(),
          conflictAlgorithm: conflictAlgorithm);
    }
    batch.commit();
  }

  Future<T> get<T extends RootDatabaseModel>(String tableName,
      T Function(Map<String, dynamic>) constructorCallback, String id) async {
    final db = await database;
    final Map<String, dynamic> queryResult =
        (await db.query(tableName, where: 'id = ?', whereArgs: [id])).single;
    T instance = constructorCallback(queryResult);
    return instance;
  }

  Future<List<T>> getAll<T extends RootDatabaseModel>(String tableName,
      T Function(Map<String, dynamic>) constructorCallback) async {
    final db = await database;

    final List<Map<String, dynamic>> queryResult = await db.query(tableName);
    return List.generate(queryResult.length, (i) => constructorCallback(queryResult[i]));
  }

  Future<List<T>> query<T extends RootDatabaseModel>(
      String tableName, T Function(Map<String, dynamic>) constructorCallback,
      {bool? distinct,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    final db = await database;
    final List<Map<String, dynamic>> queryResult = await db.query(tableName,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return List.generate(queryResult.length, (i) => constructorCallback(queryResult[i]));
  }

  Future<void> update<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    final db = await database;
    object.updateTime = DateTime.now();
    await db.update(object.getTableName(), object.toMap(),
        where: 'id = ?', whereArgs: [object.id]);
  }

  Future<void> delete<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    final db = await database;
    await db.delete(
      object.getTableName(),
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }
}
