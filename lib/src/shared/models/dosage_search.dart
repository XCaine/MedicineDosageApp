import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';

class DosageSearchWrapper {
  DosageSearchWrapper({required this.selectedMedicine});

  Medicine selectedMedicine;
  String? potency;
  int? dosagesPerDay;
  DateTime? dateStart;
  DateTime? dateEnd;

  factory DosageSearchWrapper.fromJson(Map<String, dynamic> medicineJson) {
    return DosageSearchWrapper(
        selectedMedicine: Medicine.fromJson(medicineJson)
    );
  }
}