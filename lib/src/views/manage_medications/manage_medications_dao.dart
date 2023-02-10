import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/shared/pair.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/utils/utils.dart';

class ManageMedicationsDao {
  final DatabaseBroker _dbBroker = DatabaseBroker();
  static final Logger _logger = LogDistributor.getLoggerFor('ManageMedicationsDao');

  Future<Medication?> getMedicationById(int id) async {
    Medication? instance;
    try {
      var medicationJson = (await _dbBroker.database.query(
        Medication.tableName(),
        where: '${RootDatabaseModel.idFieldName} = ?',
        whereArgs: [id],
      ))
          .single;
      instance = Medication.fromJson(medicationJson);
    } catch (e, stackTrace) {
      _logger.severe('Could not fetch medication from database using id $id', stackTrace);
    }
    return instance;
  }

  Future<Pair<Medication?, List<Package>>> getMedicationWithPackagesById(int medicationId) async {
    Medication? medication;
    List<Package> packages = [];
    try {
      var medicationJson = (await _dbBroker.database.query(
        Medication.tableName(),
        where: '${RootDatabaseModel.idFieldName} = ?',
        whereArgs: [medicationId],
      ))
          .single;
      medication = Medication.fromJson(medicationJson);

      var packagesJson = (await _dbBroker.database
          .query(Package.tableName(), where: '${Package.medicineIdFieldName} = ?', whereArgs: [medicationId]));

      for (var packageJson in packagesJson) {
        var package = Package.fromJson(packageJson);
        packages.add(package);
      }
    } catch (e, stackTrace) {
      _logger.severe('Could not fetch medication with packages from database using id $medicationId', stackTrace);
    }

    return Pair(medication, packages);
  }

  Future<void> deleteMedication(int id) async {
    _dbBroker.deleteById(id, Medication.tableName());
  }

  Future<bool> anotherMedicationWithSameProductIdentifierExists(String productIdentifier) async {
    int count = firstIntValue(await _dbBroker.database.query(
          Medication.tableName(),
          columns: [sqlCountColumn],
          where: '${Medication.productIdentifierFieldName} = ?',
          whereArgs: [productIdentifier],
        )) ??
        0;

    return count != 0;
  }

  Future<Medication?> getMedicationByProductIdentifier(String productIdentifier) async {
    Medication? instance;
    try {
      var medicationJson = (await _dbBroker.database.query(
        Medication.tableName(),
        where: '${Medication.productIdentifierFieldName} = ?',
        whereArgs: [productIdentifier],
      ))
          .single;
      instance = Medication.fromJson(medicationJson);
    } catch (e, stackTrace) {
      _logger.severe('Could not fetch medication from database using product identifier $productIdentifier', stackTrace);
    }
    return instance;
  }
}
