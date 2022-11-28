import 'package:drugs_dosage_app/src/shared/models/database/root_model.dart';

abstract class AbstractLoader<T extends RootDatabaseModel> {
  load();
}