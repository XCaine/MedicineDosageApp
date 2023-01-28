import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:sqflite/sqlite_api.dart';

class BaseDatabaseQueryHandler<T extends RootDatabaseModel> {
  final DatabaseBroker databaseBroker;

  BaseDatabaseQueryHandler() : databaseBroker = DatabaseBroker();

  Future<int> getLastInsertedRowId([Transaction? txn]) async {
    int lastId;
    if(txn != null) {
      var lastIdResultSet = await txn.rawQuery('SELECT last_insert_rowid()');
      lastId = (lastIdResultSet.single)['last_insert_rowid()'] as int;
    } else {
      var lastIdResultSet = await databaseBroker.database.rawQuery('SELECT last_insert_rowid()');
      lastId = (lastIdResultSet.single)['last_insert_rowid()'] as int;
    }
    return lastId;
  }
}
