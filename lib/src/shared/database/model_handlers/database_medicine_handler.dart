import 'package:drugs_dosage_app/src/shared/database/abstract_database_query_handler.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';

class DatabaseMedicineHandler extends AbstractDatabaseQueryHandler<Medicine> {
  DatabaseMedicineHandler({required super.databaseBroker});

  Future<void> insertMedicine(Medicine medicine) async {
    super.insertObject(medicine);
  }

  Future<void> insertMedicineList(List<Medicine> medicineList) async {
    super.insertObjectList(medicineList);
  }

  Future<List<Medicine>> getMedicine() async {
    Future<List<Medicine>> medicine = super.getObject(Medicine.databaseName(),
        (queryResult) => Medicine.fromJson(queryResult));
    return medicine;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    super.updateObject(medicine);
  }

  Future<void> deleteMedicine(Medicine medicine) async {
    super.deleteObject(medicine);
  }
}
