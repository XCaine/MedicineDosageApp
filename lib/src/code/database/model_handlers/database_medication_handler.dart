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
  Future<bool> insertMedicineList(List<Medication> medicineList, {bool custom = true}) async {
    Database db = databaseBroker.database;
    ApiPackagesMapper packagingMapper = ApiPackagesMapper();
    int chunkSize = 500;
    var partitionedMedicineList = partition(medicineList, chunkSize);
    int currentCount = 0;
    int iterations = partitionedMedicineList.length;
    var start = DateTime.now();
    for (List<Medication> medicineGroup in partitionedMedicineList) {
      try {
        currentCount++;
        _logger.info('Iteration $currentCount/$iterations. Loading $chunkSize medical records per iteration');
        await db.transaction((Transaction txn) async {
          for (Medication medicine in medicineGroup) {
            medicine.isCustom = custom ? 1 : 0;
            await txn.insert(Medication.tableName(), medicine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
            //inserting related packages
            int lastId = await getLastInsertedRowId(txn);
            var packages = packagingMapper.mapToJson(medicine.packaging);
            for (var package in packages) {
              package[RootDatabaseModel.isCustomFieldName] = 0;
              package[Package.medicineIdFieldName] = lastId;
              await txn.insert(Package.tableName(), package);
            }
          }
        });
      } catch (e, stackTrace) {
        _logger.severe('Error during inserting medicine group', e, stackTrace);
        return false;
      }
    }
    var end = DateTime.now();
    _logger.info('Database load took ${(end.difference(start)).inSeconds} s');
    return true;
  }

}
