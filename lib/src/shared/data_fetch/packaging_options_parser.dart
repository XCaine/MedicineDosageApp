import 'dart:convert';

import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/util/drug_category_util.dart';
import 'package:logging/logging.dart';

///parser for raw data coming from API
class PackagingOptionsParser {
  static final Logger _logger = LogDistributor.getLoggerFor('PackagingOptionsParser');
  final String _rawData;

  PackagingOptionsParser({required rawData}) : _rawData = rawData;

  static const String _metadata = 'packagingFirstLine';
  static const String _deleted = 'skasowane';

  /// Return medicine String parsed to json
  /// or empty Map if something went wrong
  Map<String, dynamic> parseToJson() {
    List<Map<String, dynamic>> packageList = _parseInternal();
    packageList = _onlyValid(packageList);
    Map<String, dynamic> json = {
      PackagingOption.rootJsonFieldName: packageList
    };
    return json;
  }

  List<Map<String, dynamic>> _onlyValid(List<Map<String, dynamic>> allPackages) {
    List<Map<String, dynamic>> validatedJsonPackages = [];
    for (Map<String, dynamic> singlePackage in allPackages) {
      String metadata = (singlePackage[_metadata] as String);
      bool packageDeleted = metadata.contains(_deleted);
      bool isValidDrugType = DrugCategoryUtil.validDrugCategories
          .any((validDrugType) => metadata.contains(validDrugType));
      bool countValid = singlePackage[PackagingOption.countFieldName] != null;

      if(!packageDeleted && isValidDrugType && countValid) {
        validatedJsonPackages.add({
          PackagingOption.categoryFieldName: singlePackage[PackagingOption.categoryFieldName],
          PackagingOption.rawCountFieldName: singlePackage[PackagingOption.rawCountFieldName],
          PackagingOption.countFieldName: singlePackage[PackagingOption.countFieldName]
        });
      }
    }
    if(validatedJsonPackages.isEmpty) {
      _logger.finer('They are no json packages after validation');
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
    List<Map<String, dynamic>> packagesJson = [];
    for (List<String> info in packageInfo) {
      try {
        Map<String, dynamic> package = _parseSinglePackage(info);
        packagesJson.add(package);
      } catch(e, stackTrace) {
        _logger.fine(e, stackTrace);
      }
    }

    if(packagesJson.isEmpty) {
      _logger.finer('There are no packages after parsing');
    }

    var seen = <int>{};
    var deduplicatedPackagesJson = packagesJson
        .where((packageJson) => packageJson[PackagingOption.countFieldName] != null && seen.add(packageJson[PackagingOption.countFieldName]))
        .toList();

    return deduplicatedPackagesJson;
  }

  Map<String, dynamic> _parseSinglePackage(List<String> singlePackageInfo) {
    assert(singlePackageInfo.length == 2);
    Map<String, dynamic> json = {};
    String metadata = singlePackageInfo[0].toLowerCase();
    String rawCount = singlePackageInfo[1].toLowerCase();

    //'20 kaps.' -> 20
    int? count = int.tryParse(rawCount.split(' ').first);

    String selectedCategory = DrugCategoryUtil.drugCategories.firstWhere(
        (cat) => metadata.contains(cat),
        orElse: () => ''
    );

    //for (String category in DrugCategoryUtil.drugCategories) {
    //  if (firstLine.toLowerCase().contains(category)) {
    //    selectedCategory = category;
    //  }
    //}
    json[PackagingOption.categoryFieldName] = selectedCategory;
    json[_metadata] = metadata;
    json[PackagingOption.rawCountFieldName] = rawCount;
    json[PackagingOption.countFieldName] = count;
    return json;
  }
}
