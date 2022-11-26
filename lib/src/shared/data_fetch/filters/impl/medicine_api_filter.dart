import 'package:drugs_dosage_app/src/shared/data_fetch/mappers/packaging_option_api_mapper.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/packaging_option.dart';
import 'package:logging/logging.dart';

class ApiMedicineFilter {
  final Map<String, dynamic> _medicineMap;
  static final Logger _logger =
      LogDistributor.getLoggerFor("ApiMedicineFilter");

  ApiMedicineFilter({required Map<String, dynamic> medicineMap})
      : _medicineMap = medicineMap;

  bool isValid() {
    bool validationResult = _commonlyUsedNameValid() &&
        _medicineTypeValid() &&
        _targetSpeciesValid() &&
        _potencyValid() &&
        _permitValidityValid() &&
        _packagingInfoValid();
    return validationResult;
  }

  bool _commonlyUsedNameValid() {
    String? commonlyUsedName = _medicineMap[Medicine.commonlyUsedNameFieldName];
    return commonlyUsedName != null &&
        commonlyUsedName.isNotEmpty &&
        commonlyUsedName != '-';
  }

  bool _medicineTypeValid() {
    String? medicineType = _medicineMap[Medicine.medicineTypeFieldName];
    return medicineType != null && medicineType == 'Ludzki';
  }

  bool _targetSpeciesValid() {
    String? targetSpecies = _medicineMap[Medicine.targetSpeciesFieldName];
    return targetSpecies == null || targetSpecies.isEmpty;
  }

  bool _potencyValid() {
    String? potency = _medicineMap[Medicine.potencyFieldName];
    return potency != null && potency.isNotEmpty && potency != '-';
  }

  bool _permitValidityValid() {
    String? permitValidity = _medicineMap[Medicine.permitValidityFieldName];
    bool result = false;
    if (permitValidity == null || permitValidity.isEmpty) {
      result = false;
    } else if (permitValidity.toLowerCase() == 'bezterminowe') {
      result = true;
    } else {
      try {
        var validUntil = DateTime.parse(permitValidity);
        var today = DateTime.now();
        result = today.compareTo(validUntil) <= 0;
      } catch (e, stackTrace) {
        _logger.severe(
            'Failed to parse permit date from $permitValidity', e, stackTrace);
        result = false;
      }
    }
    return result;
  }

  //TODO maybe move it to separate method/class and change existing packaging data to not have to parse it twice
  //eg. for every element just do element: '$drugCategory\n$restOfTheString'
  bool _packagingInfoValid() {
    String? packageInfo = _medicineMap[Medicine.packagingFieldName];
    bool result = false;
    if (packageInfo == null) {
      result = false;
    } else {
      List<Map<String, dynamic>> json =
          ApiPackagingOptionMapper().mapToJson(packageInfo);
      for (Map<String, dynamic> jsonElement in json) {
        String category = jsonElement[PackagingOption.categoryFieldName];
        String freeText = jsonElement[PackagingOption.freeTextFieldName];
      }
    }

    return result;
  }
}
