import 'package:drugs_dosage_app/src/shared/data_fetch/mappers/packaging_option_api_mapper.dart';
import 'package:drugs_dosage_app/src/shared/database/abstract_database_query_handler.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';

import '../../models/packaging_option.dart';
import '../database_facade.dart';

class DatabaseMedicineHandler extends AbstractDatabaseQueryHandler<Medicine> {
  static final _logger = LogDistributor.getLoggerFor('DatabaseMedicineHandler');

  DatabaseMedicineHandler({required super.databaseBroker});

  Future<void> insertMedicine(Medicine medicine) async {
    super.insertObject(medicine);
  }

  Future<void> insertMedicineList(List<Medicine> medicineList) async {
    List<String> productIdentifierList =
        medicineList.map((medicine) => medicine.productIdentifier).toList();
    super.insertObjectList(medicineList);

    var commitedMedicines =
        await _getMedicinesBasedOnProductIdentifiers(productIdentifierList);
    ApiPackagingOptionMapper packagingMapper = ApiPackagingOptionMapper();
    for (Medicine medicine in commitedMedicines) {
      List<PackagingOption> packagingOptions =
          packagingMapper.mapToInstances(medicine.packaging, medicine.id!);
      DatabaseFacade.packagingOptionHandler.insertObjectList(packagingOptions);
    }
  }

  Future<List<Medicine>> _getMedicinesBasedOnProductIdentifiers(
      List<String> productIdentifiers) async {
    List<
        Map<String,
            dynamic>> queryResult = await (await databaseBroker.database).rawQuery(
        'select * from ${Medicine.databaseName()} where ${Medicine.productIdentifierFieldName} in (${productIdentifiers.join(',')})');

    var instances = List.generate(
        queryResult.length, (i) => Medicine.fromJson(queryResult[i]));
    return instances;
  }

  Future<List<Medicine>> getMedicines() async {
    Future<List<Medicine>> medicines = super.getObjects(Medicine.databaseName(),
        (queryResult) => Medicine.fromJson(queryResult));
    return medicines;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    super.updateObject(medicine);
  }

  Future<void> deleteMedicine(Medicine medicine) async {
    super.deleteObject(medicine);
  }
}
