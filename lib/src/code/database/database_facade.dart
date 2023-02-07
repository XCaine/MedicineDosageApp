import 'package:drugs_dosage_app/src/code/database/model_handlers/database_medication_handler.dart';
import 'package:drugs_dosage_app/src/code/database/model_handlers/database_packages_handler.dart';

class DatabaseFacade {
  final DatabaseMedicationHandler medicineHandler =
      DatabaseMedicationHandler();
  final DatabasePackagesHandler packagingOptionHandler =
      DatabasePackagesHandler();
}
