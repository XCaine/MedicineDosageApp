import 'package:drugs_dosage_app/src/shared/models/root_model.dart';

abstract class AbstractLoader<T extends RootDatabaseModel> {
  load();
}