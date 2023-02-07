import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/utils/utils.dart';

class AddMedicationDao {
  final DatabaseBroker _dbBroker = DatabaseBroker();
  static final Logger _logger = LogDistributor.getLoggerFor('AddMedicationDao');

  Future<bool> anotherMedicationWithSameProductIdentifierExists(String productIdentifier) async {
    int count = firstIntValue(
      await _dbBroker.database.query(Medication.tableName(),
          columns: [sqlCountColumn],
          where: '${Medication.productIdentifierFieldName} = ?',
        whereArgs: [productIdentifier],
      )) ?? 0;

    return count != 0;
  }

  Future<Medication?> getMedicationByProductIdentifier(String productIdentifier) async {
    Medication? instance;
    try {
      var medicationJson = (await _dbBroker.database.query(Medication.tableName(),
        where: '${Medication.productIdentifierFieldName} = ?',
        whereArgs: [productIdentifier],
      )).single;
      instance = Medication.fromJson(medicationJson);
    } catch(e, stackTrace) {
      _logger.severe('Could not fetch medication from database using product identifier $productIdentifier');
    }
    return instance;
  }
}