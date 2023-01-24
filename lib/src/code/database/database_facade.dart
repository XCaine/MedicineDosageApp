import 'package:drugs_dosage_app/src/code/database/model_handlers/database_medication_handler.dart';
import 'package:drugs_dosage_app/src/code/database/model_handlers/database_packages_handler.dart';

class DatabaseFacade {
  static final DatabaseMedicationHandler medicineHandler =
      DatabaseMedicationHandler();
  static final DatabasePackagesHandler packagingOptionHandler =
      DatabasePackagesHandler();
}
