import 'package:drugs_dosage_app/src/code/database/base_database_query_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/database/medication.dart';

class DrugsInDatabaseVerifier {
  final BaseDatabaseQueryHandler _queryHandler = BaseDatabaseQueryHandler();

  Future<bool> get anyDrugsInDatabase async {
    String sql = 'select count(*) as count from ${Medication.tableName()}';
    var result = (await _queryHandler.database.rawQuery(sql)).single;
    int count = result['count'] as int;
    return count != 0;
  }

}