import 'package:drugs_dosage_app/src/code/database/abstract_database_query_handler.dart';
import 'package:drugs_dosage_app/src/code/models/database/packaging_option.dart';

//TODO relationships with medicine are not handled, so e.g. it may be possible to delete all
// packages and related medicine would stay intact
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

  Future<List<PackagingOption>> getPackagingOptions() async {
    Future<List<PackagingOption>> packagingOptions = super.getObjects(
        PackagingOption.tableName(),
        (queryResult) => PackagingOption.fromJson(queryResult));
    return packagingOptions;
  }

  Future<void> updatePackagingOption(PackagingOption packagingOption) async {
    super.updateObject(packagingOption);
  }

  Future<void> deletePackagingOption(PackagingOption packagingOption) async {
    super.deleteObject(packagingOption);
  }
}
