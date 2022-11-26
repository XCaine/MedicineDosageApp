import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/models/root_model.dart';

abstract class AbstractDatabaseQueryHandler<T extends RootDatabaseModel> {
  final DatabaseBroker databaseBroker;

  AbstractDatabaseQueryHandler({required this.databaseBroker});

  Future<void> insertObject(T object) async {
    databaseBroker.insert(object);
  }

  Future<void> insertObjectList(List<T> objectList) async {
    databaseBroker.insertAll(objectList);
  }

  Future<List<T>> getObject(
      String databaseName, Function(Map<String, dynamic>) constructor) async {
    Future<List<T>> medicine =
        databaseBroker.get(databaseName, (queryResult) => constructor(queryResult));
    return medicine;
  }

  Future<void> updateObject(T object) async {
    databaseBroker.update(object);
  }

  Future<void> deleteObject(T object) async {
    databaseBroker.delete(object);
  }
}
