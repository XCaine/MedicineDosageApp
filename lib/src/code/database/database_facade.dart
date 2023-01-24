import 'package:drugs_dosage_app/src/code/database/model_handlers/database_medicine_handler.dart';
import 'package:drugs_dosage_app/src/code/database/model_handlers/database_packaging_option_handler.dart';

class DatabaseFacade {
  static final DatabaseMedicineHandler medicineHandler =
      DatabaseMedicineHandler();
  static final DatabasePackagingOptionHandler packagingOptionHandler =
      DatabasePackagingOptionHandler();
}
