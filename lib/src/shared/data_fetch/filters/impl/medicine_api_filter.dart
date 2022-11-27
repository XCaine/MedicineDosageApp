import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
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
        _packagingValid();
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

  bool _packagingValid() {
    String? packaging = _medicineMap[Medicine.packagingFieldName];
    return packaging != null && packaging.isNotEmpty;
  }
}
