import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:sqflite/sqlite_api.dart';

class BaseDatabaseQueryHandler<T extends RootDatabaseModel> {
  final DatabaseBroker databaseBroker;

  BaseDatabaseQueryHandler() : databaseBroker = DatabaseBroker();

  Database get database {
    return databaseBroker.database;
  }

  Future<int> getLastInsertedRowId([Transaction? txn]) async {
    int lastId;
    if(txn != null) {
      var lastIdResultSet = await txn.rawQuery('SELECT last_insert_rowid()');
      lastId = (lastIdResultSet.single)['last_insert_rowid()'] as int;
    } else {
      var lastIdResultSet = await database.rawQuery('SELECT last_insert_rowid()');
      lastId = (lastIdResultSet.single)['last_insert_rowid()'] as int;
    }
    return lastId;
  }

  Future<void> insertObject(T object) async {
    databaseBroker.insert(object);
  }

  Future<void> insertObjectList(List<T> objectList) async {
    databaseBroker.insertAll(objectList);
  }

  Future<List<T>> getObjects(
      String databaseName, Function(Map<String, dynamic>) constructor) async {
    Future<List<T>> medicine =
        databaseBroker.getAll(databaseName, (queryResult) => constructor(queryResult));
    return medicine;
  }

  Future<void> updateObject(T object) async {
    databaseBroker.update(object);
  }

  Future<void> deleteObject(T object) async {
    databaseBroker.delete(object);
  }
}
