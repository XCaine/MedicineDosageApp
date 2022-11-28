import 'dart:convert';

import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';

class ApiPackagingOptionMapper {
  List<PackagingOption> mapToInstances(String packageData, int medicineId) {
    Map<String, dynamic> decodedPackageData = json.decode(packageData);
    List<dynamic> packages =
        decodedPackageData[PackagingOption.rootJsonFieldName];

    List<PackagingOption> instances = [];
    for (dynamic package in packages) {
      package[PackagingOption.medicineIdFieldName] = medicineId;
      instances.add(PackagingOption.fromJson(package));
    }
    return instances;
  }

  List<dynamic> mapToJson(String packageData) {
    Map<String, dynamic> decodedPackageData = json.decode(packageData);
    List<dynamic> packages =
        decodedPackageData[PackagingOption.rootJsonFieldName];
    return packages;
  }
}
