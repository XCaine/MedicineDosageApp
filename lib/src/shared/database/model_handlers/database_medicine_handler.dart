import 'package:drugs_dosage_app/src/shared/data_fetch/mappers/packaging_option_api_mapper.dart';
import 'package:drugs_dosage_app/src/shared/database/abstract_database_query_handler.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:quiver/iterables.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../models/database/packaging_option.dart';

class DatabaseMedicineHandler extends AbstractDatabaseQueryHandler<Medicine> {
  static final _logger = LogDistributor.getLoggerFor('DatabaseMedicineHandler');

  DatabaseMedicineHandler({required super.databaseBroker});

  Future<void> insertMedicine(Medicine medicine) async {
    super.insertObject(medicine);
  }

  //for registered medicine loader
  Future<void> insertMedicineList(List<Medicine> medicineList) async {
    Database db = await databaseBroker.database;
    ApiPackagingOptionMapper packagingMapper = ApiPackagingOptionMapper();
    int chunkSize = 500;
    var partitionedMedicineList = partition(medicineList, chunkSize);
    int currentCount = 0;
    int iterations = partitionedMedicineList.length;
    var start = DateTime.now();
    for (List<Medicine> medicineGroup in partitionedMedicineList) {
      try {
        currentCount++;
        _logger.info('Iteration $currentCount/$iterations. Loading $chunkSize medical records per iteration');
        await db.transaction((Transaction txn) async {
          for (Medicine medicine in medicineGroup) {
            await txn.insert(Medicine.databaseName(), medicine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
            //inserting related packages
            int lastId = await getLastInsertedRowId(txn);
            var packages = packagingMapper.mapToJson(medicine.packaging);
            for (var package in packages) {
              package[PackagingOption.medicineIdFieldName] = lastId;
              await txn.insert(PackagingOption.databaseName(), package);
            }
          }
        });
      } catch (e, stackTrace) {
        _logger.severe('Error during inserting medicine group', e, stackTrace);
      }
    }
    var end = DateTime.now();
    _logger.info('Database load took ${(end.difference(start)).inSeconds} s');
  }

  Future<List<Medicine>> getMedicines() async {
    Future<List<Medicine>> medicines =
        super.getObjects(Medicine.databaseName(), (queryResult) => Medicine.fromJson(queryResult));
    return medicines;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    super.updateObject(medicine);
  }

  Future<void> deleteMedicine(Medicine medicine) async {
    super.deleteObject(medicine);
  }
}
