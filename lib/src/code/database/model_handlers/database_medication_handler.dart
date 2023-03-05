import 'package:drugs_dosage_app/src/code/data_fetch/mappers/packages_api_mapper.dart';
import 'package:drugs_dosage_app/src/code/database/base_database_query_handler.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:quiver/iterables.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../models/database/package.dart';

class DatabaseMedicationHandler extends BaseDatabaseQueryHandler<Medication> {
  static final _logger = LogDistributor.getLoggerFor('DatabaseMedicineHandler');

  //for registered medicine loader
  Future<bool> insertMedicationsWithPackages(List<Medication> medications,
      {bool custom = true, Function(String)? setMessageOnProgress}) async {
    Database db = databaseBroker.database;
    ApiPackagesMapper packagingMapper = ApiPackagesMapper();
    int currentCount = 0;
    int chunkSize = 500;
    var partitionedMedications = partition(medications, chunkSize);
    int iterations = partitionedMedications.length;
    var start = DateTime.now();
    for (List<Medication> medicationGroup in partitionedMedications) {
      try {
        currentCount++;
        if (setMessageOnProgress != null) {
          try {
            setMessageOnProgress('Ładowanie - część $currentCount z $iterations');
          } catch (e, stackTrace) {
            _logger.warning('Cannot execute callback to set the loading message', stackTrace);
          }
        }
        _logger.info('Iteration $currentCount/$iterations. Loading $chunkSize medical records per iteration');
        await db.transaction((Transaction txn) async {
          for (Medication medication in medicationGroup) {
            medication.isCustom = custom ? 1 : 0;
            await txn.insert(Medication.tableName(), medication.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
            //inserting related packages
            int lastId = await getLastInsertedRowId(txn);
            var packages = packagingMapper.mapToJson(medication.packaging);
            for (var package in packages) {
              package[RootDatabaseModel.isCustomFieldName] = medication.isCustom;
              package[Package.medicineIdFieldName] = lastId;
              await txn.insert(Package.tableName(), package);
            }
          }
        });
      } catch (e, stackTrace) {
        _logger.severe('Error during inserting medication group', e, stackTrace);
        return false;
      }
    }
    var end = DateTime.now();
    _logger.info('Database load took ${(end.difference(start)).inSeconds} s');
    return true;
  }

  Future<bool> updateMedicationWithPackages(Medication medication, List<Package> originalPackages,
      {bool custom = true}) async {
    Database db = databaseBroker.database;
    ApiPackagesMapper packagingMapper = ApiPackagesMapper();

    try {
      await db.transaction((Transaction txn) async {
        medication.isCustom = custom ? 1 : 0;
        await txn.update(Medication.tableName(), medication.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
            where: '${RootDatabaseModel.idFieldName} = ?',
            whereArgs: [medication.id]);
        var packages = packagingMapper.mapToJson(medication.packaging);
        for (var originalPackage in originalPackages) {
          await txn.delete(Package.tableName(),
              where: '${RootDatabaseModel.idFieldName} = ?', whereArgs: [originalPackage.id]);
        }
        for (var package in packages) {
          package[RootDatabaseModel.isCustomFieldName] = medication.isCustom;
          package[Package.medicineIdFieldName] = medication.id;
          await txn.insert(Package.tableName(), package);
        }
      });
    } catch (e, stackTrace) {
      _logger.severe('Error during updating medication', e, stackTrace);
      return false;
    }

    return true;
  }
}
