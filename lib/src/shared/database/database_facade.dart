import '../classes/medicine.dart';
import 'database.dart';

class DatabaseFacade {
  final DatabaseHandler _handler = DatabaseHandler();

  Future<void> insertMedicine(Medicine medicine) async {
    _handler.insert(medicine);
  }

  Future<void> insertMedicineList(List<Medicine> medicineList) async {
    _handler.insertAll(medicineList);
  }

  Future<List<Medicine>> getMedicine() async {
    Future<List<Medicine>> medicine =
    _handler.get(Medicine.databaseName(), (queryResult) => Medicine.fromJson(queryResult));
    return medicine;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    _handler.update(medicine);
  }

  Future<void> deleteMedicine(Medicine medicine) async {
    _handler.delete(medicine);
  }
}