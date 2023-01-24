import 'package:drugs_dosage_app/src/code/database/base_database_query_handler.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';

//TODO relationships with medicine are not handled, so e.g. it may be possible to delete all
// packages and related medicine would stay intact
class DatabasePackagesHandler
    extends BaseDatabaseQueryHandler<Package> {

  Future<void> insertPackagingOption(Package packagingOption) async {
    super.insertObject(packagingOption);
  }

  Future<void> insertPackagingOptionList(
      List<Package> packagingOptionList) async {
    super.insertObjectList(packagingOptionList);
  }

  Future<List<Package>> getPackagingOptions() async {
    Future<List<Package>> packagingOptions = super.getObjects(
        Package.tableName(),
        (queryResult) => Package.fromJson(queryResult));
    return packagingOptions;
  }

  Future<void> updatePackagingOption(Package packagingOption) async {
    super.updateObject(packagingOption);
  }

  Future<void> deletePackagingOption(Package packagingOption) async {
    super.deleteObject(packagingOption);
  }
}
