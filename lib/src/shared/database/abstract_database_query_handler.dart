import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/models/root_model.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class AbstractDatabaseQueryHandler<T extends RootDatabaseModel> {
  final DatabaseBroker databaseBroker;

  AbstractDatabaseQueryHandler({required this.databaseBroker});

  Future<int> getLastInsertedRowId([Transaction? txn]) async {
    int lastId;
    if(txn != null) {
      var lastIdResultSet = await txn.rawQuery('SELECT last_insert_rowid()');
      lastId = (lastIdResultSet.single)['last_insert_rowid()'] as int;
    } else {
      Database db = await databaseBroker.database;
      var lastIdResultSet = await db.rawQuery('SELECT last_insert_rowid()');
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
