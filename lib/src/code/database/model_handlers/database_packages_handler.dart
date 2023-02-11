import 'package:drugs_dosage_app/src/code/database/base_database_query_handler.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';

class DatabasePackagesHandler extends BaseDatabaseQueryHandler<Package> {
  Future<void> insertPackagingOption(Package packagingOption) async {
    databaseBroker.insert(packagingOption);
  }

  Future<void> insertPackagingOptionList(List<Package> packagingOptionList) async {
    databaseBroker.insertAll(packagingOptionList);
  }

  Future<List<Package>> getPackagingOptions() async {
    Future<List<Package>> packagingOptions =
        databaseBroker.getAll(Package.tableName(), (queryResult) => Package.fromJson(queryResult));
    return packagingOptions;
  }

  Future<void> updatePackagingOption(Package packagingOption) async {
    databaseBroker.update(packagingOption);
  }

  Future<void> deletePackagingOption(Package packagingOption) async {
    databaseBroker.delete(packagingOption);
  }
}
