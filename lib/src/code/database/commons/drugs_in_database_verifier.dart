import 'package:drugs_dosage_app/src/code/database/database.dart';

import '../../models/database/medication.dart';

class DrugsInDatabaseVerifier {
  final DatabaseBroker _dbBroker = DatabaseBroker();

  Future<bool> get anyDrugsInDatabase async {
    String sql = 'select count(*) as count from ${Medication.tableName()}';
    var result = (await _dbBroker.database.rawQuery(sql)).single;
    int count = result['count'] as int;
    return count != 0;
  }
}
