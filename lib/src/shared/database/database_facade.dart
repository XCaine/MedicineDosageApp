import 'package:drugs_dosage_app/src/shared/database/model_handlers/database_medicine_handler.dart';
import 'package:drugs_dosage_app/src/shared/database/model_handlers/database_packaging_option_handler.dart';

import 'database.dart';

class DatabaseFacade {
  static final DatabaseBroker _databaseBroker = DatabaseBroker();

  static final DatabaseMedicineHandler medicineHandler =
      DatabaseMedicineHandler(databaseBroker: _databaseBroker);
  static final DatabasePackagingOptionHandler packagingOptionHandler =
      DatabasePackagingOptionHandler(databaseBroker: _databaseBroker);
}
