import 'package:drugs_dosage_app/src/shared/database/abstract_database_query_handler.dart';
import 'package:drugs_dosage_app/src/shared/models/packaging_option.dart';

class DatabasePackagingOptionHandler
    extends AbstractDatabaseQueryHandler<PackagingOption> {
  DatabasePackagingOptionHandler({required super.databaseBroker});

  Future<void> insertPackagingOption(PackagingOption packagingOption) async {
    super.insertObject(packagingOption);
  }

  Future<void> insertPackagingOptionList(
      List<PackagingOption> packagingOptionList) async {
    super.insertObjectList(packagingOptionList);
  }

  Future<List<PackagingOption>> getPackagingOption() async {
    Future<List<PackagingOption>> packagingOption = super.getObject(
        PackagingOption.databaseName(),
        (queryResult) => PackagingOption.fromJson(queryResult));
    return packagingOption;
  }

  Future<void> updateMedicine(PackagingOption packagingOption) async {
    super.updateObject(packagingOption);
  }

  Future<void> deleteMedicine(PackagingOption packagingOption) async {
    super.deleteObject(packagingOption);
  }
}
