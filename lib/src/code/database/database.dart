import 'dart:async';

import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/app_metadata.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/providers/database/bootstrap_query_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../constants/constants.dart';

class DatabaseBroker {
  late sqflite.Database database;
  static final Logger _logger = LogDistributor.getLoggerFor('DatabaseHandler');
  static DatabaseBroker? _instance;

  DatabaseBroker._internal({dropExisting = false}) {
    try {
      _initDatabase(dropExisting);
    } catch (e, stackTrace) {
      _logger.severe('Database initialization failed', stackTrace);
    }
  }

  factory DatabaseBroker() {
    _instance ??= DatabaseBroker._internal();
    return _instance!;
  }

  factory DatabaseBroker.initialize() {
    return DatabaseBroker();
  }

  factory DatabaseBroker.dropExistingAndInitialize() {
    _instance = DatabaseBroker._internal(dropExisting: true);
    return _instance!;
  }

  _initDatabase([dropExisting = false]) async {
    String databasePath = join(await sqflite.getDatabasesPath(), Constants.databaseName);
    if (dropExisting) {
      await _dropDatabaseIfExists(databasePath);
    }

    sqflite.Database database = await sqflite.openDatabase(
      databasePath,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        List<String> bootstrapQueries = BootstrapQueryProvider().provide();
        for (String query in bootstrapQueries) {
          await db.execute(query);
        }
        _logger.info('Database has been created');
      },
      version: 1,
    );
    this.database = database;

    int metadataValuesCount = await getCountOf(AppMetadata.tableName());
    if (metadataValuesCount == 0) {
      insert(AppMetadata(initialLoadDone: 0));
    }
    _logger.info('Database initialization ended');
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

  Future<int> getCountOf(String tableName) async {
    var result = (await database.rawQuery('select count(*) as count from ${AppMetadata.tableName()}')).single;
    int count = result['count'] as int;
    return count;
  }

  Future<void> insert<T extends RootDatabaseModel>(T object,
      [sqflite.ConflictAlgorithm conflictAlgorithm = sqflite.ConflictAlgorithm.replace]) async {
    await database.insert(object.getTableName(), object.toMap(), conflictAlgorithm: conflictAlgorithm);
  }

  Future<void> insertAll<T extends RootDatabaseModel>(List<T> objects,
      [sqflite.ConflictAlgorithm conflictAlgorithm = sqflite.ConflictAlgorithm.replace]) async {
    if (objects.isEmpty) {
      return;
    }
    final tableName = objects.first.getTableName();

    sqflite.Batch batch = database.batch();
    for (var element in objects) {
      batch.insert(tableName, element.toMap(), conflictAlgorithm: conflictAlgorithm);
    }
    batch.commit();
  }

  Future<T> get<T extends RootDatabaseModel>(
      String tableName, T Function(Map<String, dynamic>) constructorCallback, String id) async {
    final Map<String, dynamic> queryResult = (await database.query(tableName, where: 'id = ?', whereArgs: [id])).single;
    T instance = constructorCallback(queryResult);
    return instance;
  }

  Future<List<T>> getAll<T extends RootDatabaseModel>(
      String tableName, T Function(Map<String, dynamic>) constructorCallback) async {
    final List<Map<String, dynamic>> queryResult = await database.query(tableName);
    return List.generate(queryResult.length, (i) => constructorCallback(queryResult[i]));
  }

  Future<void> update<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    object.updateTime = DateTime.now();
    await database.update(object.getTableName(), object.toMap(), where: 'id = ?', whereArgs: [object.id]);
  }

  Future<void> delete<T extends RootDatabaseModel>(T object) async {
    assert(object.id != null, 'ID cannot be null');
    await database.delete(
      object.getTableName(),
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }

  Future<void> deleteById(int id, String tableName) async {
    await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
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
    final List<Map<String, dynamic>> queryResult = await database.query(tableName,
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
}
