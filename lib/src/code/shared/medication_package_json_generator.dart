import 'package:drugs_dosage_app/src/code/models/database/package.dart';

class MedicationPackageJsonGenerator {
  static String generate(List<String> packages, String category) {
    Map<String, dynamic> json = {};

    List<Map<String, String>> packageData = [];
    for (var package in packages) {
      Map<String, String> packageInstanceData = {};
      packageInstanceData['"${Package.categoryFieldName}"'] = '"$category"';
      packageInstanceData['"${Package.rawCountFieldName}"'] = '"$package tabl."';
      packageInstanceData['"${Package.countFieldName}"'] = '"$package"';
      packageData.add(packageInstanceData);
    }
    json['"${Package.jsonIdentifierFieldName}"'] = packageData;
    var jsonString = json.toString();
    return jsonString;
  }
}
