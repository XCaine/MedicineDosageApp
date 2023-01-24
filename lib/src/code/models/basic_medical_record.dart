import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';

class BasicMedicalRecord {
  BasicMedicalRecord({required this.id, required this.commonlyUsedName, required this.productName});

  int id;
  String commonlyUsedName;
  String productName;

  factory BasicMedicalRecord.fromJson(Map<String, dynamic> json) {
    return BasicMedicalRecord(
        id: json[RootDatabaseModel.idFieldName],
        commonlyUsedName: json[Medication.commonlyUsedNameFieldName],
        productName: json[Medication.productNameFieldName]);
  }
}
