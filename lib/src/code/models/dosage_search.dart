import 'package:drugs_dosage_app/src/code/models/database/medication.dart';

class DosageSearchWrapper {
  DosageSearchWrapper({required this.selectedMedicine});

  Medication selectedMedicine;
  String? potency;
  int? dosagesPerDay;
  DateTime? dateStart;
  DateTime? dateEnd;
  int? numberOfDays;
  bool searchByDates = true;

  factory DosageSearchWrapper.fromJson(Map<String, dynamic> medicineJson) {
    return DosageSearchWrapper(
        selectedMedicine: Medication.fromJson(medicineJson)
    );
  }

  int get totalDosages {
    int totalDosages = dosagesPerDay! * totalDays;
    return totalDosages;
  }

  int get totalDays {
    int totalDays = (searchByDates ? dateEnd!.difference(dateStart!).inDays : numberOfDays)!;
    return totalDays;
  }
}