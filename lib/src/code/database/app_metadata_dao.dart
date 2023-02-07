import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/models/database/app_metadata.dart';

class AppMetadataDao {
  final DatabaseBroker _dbBroker = DatabaseBroker();

  Future<void> setInitialLoadStatus({required bool newStatus}) async {
    var instance =
        (await _dbBroker.getAll(AppMetadata.tableName(), (queryResult) => AppMetadata.fromJson(queryResult))).single;
    instance.initialLoadDone = newStatus ? 1 : 0;
    _dbBroker.update(instance);
  }

  Future<bool> get initialLoadDone async {
    var metadataInstance =
        (await _dbBroker.getAll(AppMetadata.tableName(), (queryResult) => AppMetadata.fromJson(queryResult))).single;
    bool loadDone = metadataInstance.initialLoadDone != null && metadataInstance.initialLoadDone != 0;
    return loadDone;
  }
}
