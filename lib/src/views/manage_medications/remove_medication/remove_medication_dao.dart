import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:logging/logging.dart';

class RemoveMedicationDao {
  final DatabaseBroker _dbBroker = DatabaseBroker();
  static final Logger _logger = LogDistributor.getLoggerFor('RemoveMedicationDao');

  Future<Medication?> getMedicationById(int id) async {
    Medication? instance;
    try {
      var medicationJson = (await _dbBroker.database.query(Medication.tableName(),
        where: '${RootDatabaseModel.idFieldName} = ?',
        whereArgs: [id],
      )).single;
      instance = Medication.fromJson(medicationJson);
    } catch(e, stackTrace) {
      _logger.severe('Could not fetch medication from database using id $id');
    }
    return instance;
  }
  
  Future<void> deleteMedication(int id) async {
    _dbBroker.deleteById(id, Medication.tableName());
  }
}