import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:sqflite/utils/utils.dart';

class AddMedicationDao {
  final DatabaseBroker _dbBroker = DatabaseBroker();

  Future<bool> anotherMedicationWithSameProductIdentifierExists(String productIdentifier) async {
    int count = firstIntValue(
      await _dbBroker.database.query(Medication.tableName(),
          columns: [sqlCountColumn],
          where: '${Medication.productIdentifierFieldName} = ?',
        whereArgs: [productIdentifier],
      )) ?? 0;

    return count != 0;
  }
}