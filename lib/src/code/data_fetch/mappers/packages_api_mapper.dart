import 'dart:convert';

import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';

class ApiPackagesMapper {
  static final _logger = LogDistributor.getLoggerFor('ApiPackagesMapper');

  List<Package> mapToInstances(String packageData, int medicineId) {
    Map<String, dynamic> decodedPackageData = json.decode(packageData);
    List<dynamic> packages = decodedPackageData[Package.jsonIdentifierFieldName];

    List<Package> instances = [];
    for (dynamic package in packages) {
      package[Package.medicineIdFieldName] = medicineId;
      instances.add(Package.fromJson(package));
    }
    return instances;
  }

  List<dynamic> mapToJson(String packageData) {
    Map<String, dynamic> decodedPackageData = json.decode(packageData);
    List<dynamic> packages = decodedPackageData[Package.jsonIdentifierFieldName];
    return packages;
  }
}
