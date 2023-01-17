import 'package:drugs_dosage_app/src/code/database/abstract_database_query_handler.dart';

import '../../models/database/medicine.dart';

class DrugsInDatabaseVerifier extends AbstractDatabaseQueryHandler<Medicine> {
  DrugsInDatabaseVerifier({required super.databaseBroker});
}