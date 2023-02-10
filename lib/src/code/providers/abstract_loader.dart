import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';

abstract class AbstractLoader<T extends RootDatabaseModel> {
  load({Function? onFinishCallback});
}
