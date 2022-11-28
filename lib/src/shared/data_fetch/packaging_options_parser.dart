import 'dart:convert';

import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/util/drug_category_util.dart';

///parser for raw data coming from API
class PackagingOptionsParser {
  final String _rawData;

  PackagingOptionsParser({required rawData}) : _rawData = rawData;

  static const String _packagingFirstLine = 'packagingFirstLine';
  static const String _deleted = 'skasowane';

  /// Return medicine String parsed to json
  /// or empty list if something went wrong
  Map<String, dynamic> parseToJson() {
    List<Map<String, dynamic>> packageList = _parseInternal();
    packageList = _onlyValid(packageList);
    Map<String, dynamic> json = {
      PackagingOption.rootJsonFieldName: packageList
    };
    return json;
  }

  List<Map<String, dynamic>> _onlyValid(List<Map<String, dynamic>> json) {
    List<Map<String, dynamic>> validatedJsonPackages = [];
    for (Map<String, dynamic> jsonPackage in json) {
      String firstLine =
          (jsonPackage[_packagingFirstLine] as String).toLowerCase();
      bool packageDeleted = firstLine.contains(_deleted);
      bool isValidDrugType = DrugCategoryUtil.validDrugCategories
          .any((validDrugType) => firstLine.contains(validDrugType));
      if(!packageDeleted && isValidDrugType) {
        validatedJsonPackages.add({
          PackagingOption.categoryFieldName: jsonPackage[PackagingOption.categoryFieldName],
          PackagingOption.freeTextFieldName: jsonPackage[PackagingOption.freeTextFieldName]
        });
      }
    }
    return validatedJsonPackages;
  }

  List<Map<String, dynamic>> _parseInternal() {
    LineSplitter splitter = const LineSplitter();
    List<String> dataLines = splitter.convert(_rawData);
    if (dataLines.isEmpty ||
        dataLines.length % 2 != 0 ||
        dataLines.length < 2) {
      return [];
    }
    List<List<String>> packageInfo = [];
    String previousLine = '';
    for (String line in dataLines) {
      if (previousLine.isEmpty) {
        previousLine = line;
      } else {
        packageInfo.add([previousLine, line]);
        previousLine = '';
      }
    }
    List<Map<String, dynamic>> json = [];
    for (List<String> info in packageInfo) {
      Map<String, dynamic> package = _parseSinglePackage(info);
      json.add(package);
    }

    return json;
  }

  Map<String, dynamic> _parseSinglePackage(
      List<String> singlePackageInfo) {
    assert(singlePackageInfo.length == 2);
    Map<String, dynamic> json = {};
    String firstLine = singlePackageInfo[0];
    String selectedCategory = '';
    for (String category in DrugCategoryUtil.drugCategories) {
      if (firstLine.toLowerCase().contains(category)) {
        selectedCategory = category;
      }
    }
    json[PackagingOption.categoryFieldName] = selectedCategory;
    json[_packagingFirstLine] = singlePackageInfo[0];
    json[PackagingOption.freeTextFieldName] = singlePackageInfo[1];
    return json;
  }
}
