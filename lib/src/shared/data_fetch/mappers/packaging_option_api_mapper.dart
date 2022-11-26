import 'dart:convert';

import 'package:drugs_dosage_app/src/shared/models/packaging_option.dart';

class ApiPackagingOptionMapper {

  List<PackagingOption> mapToInstances(String packageData, int medicineId) {
    List<Map<String, dynamic>> json = mapToJson(packageData, medicineId);
    List<PackagingOption> instances = [];
    for(Map<String, dynamic> jsonElement in json) {
      instances.add(PackagingOption.fromJson(jsonElement));
    }
    return instances;
  }

  List<Map<String, dynamic>> mapToJson(String packageData, [int? medicineId]) {
    LineSplitter splitter = const LineSplitter();
    List<String> dataLines = splitter.convert(packageData);
    if(dataLines.isEmpty || dataLines.length %2 != 0) {
      throw ArgumentError('Could not parse package data');
    }
    List<String> packageInfo = [];
    String previousLine = '';
    for(String line in dataLines) {
      if(previousLine.isEmpty) {
        previousLine = line;
      } else {
        packageInfo.add('$previousLine\n$line');
        previousLine = '';
      }
    }
    List<Map<String, dynamic>> json = [];
    for(String info in packageInfo) {
      json.add(_mapSinglePackage(info, medicineId));
    }

    return json;
  }

  Map<String, dynamic> _mapSinglePackage(String singlePackageInfo, int? medicineId) {
    Map<String, dynamic> json = {};
    List<String> lines = singlePackageInfo.split('\n');
    String firstLine = lines[0];
    String selectedCategory = '';
    for(String category in PackagingOption.drugCategories) {
      if(firstLine.toLowerCase().contains(category)) {
        selectedCategory = category;
      }
    }
    if(selectedCategory.isEmpty) {
      throw ArgumentError('Cannot parse information about drug category');
    }
    if(medicineId != null) {
      json[PackagingOption.medicineIdFieldName] = medicineId;
    }
    json[PackagingOption.categoryFieldName] = selectedCategory;
    json[PackagingOption.freeTextFieldName] = lines[1];
    return json;
  }
}