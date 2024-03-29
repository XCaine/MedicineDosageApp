import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';

class ApiMedicationFilter {
  final Map<String, dynamic> _medicineMap;
  static final _logger = LogDistributor.getLoggerFor("ApiMedicationFilter");

  ApiMedicationFilter({required Map<String, dynamic> medicineMap}) : _medicineMap = medicineMap;

  bool isValid() {
    bool validationResult = _commonlyUsedNameValid() &&
        _pharmaceuticalFormValid() &&
        _medicineTypeValid() &&
        _targetSpeciesValid() &&
        _potencyValid() &&
        _permitValidityValid() &&
        _packagingValid();
    return validationResult;
  }

  bool _commonlyUsedNameValid() {
    String? commonlyUsedName = _medicineMap[Medication.commonlyUsedNameFieldName];
    return commonlyUsedName != null &&
        commonlyUsedName.isNotEmpty &&
        commonlyUsedName != '-' &&
        commonlyUsedName.toLowerCase() != 'produkt złożony';
  }

  final List<String> _validPharmaceuticalFormPatterns = ['czopki', 'globulki', 'kapsułk', 'tabletk'];

  bool _pharmaceuticalFormValid() {
    String? pharmaceuticalForm = _medicineMap[Medication.pharmaceuticalFormFieldName];
    return pharmaceuticalForm != null &&
        pharmaceuticalForm.isNotEmpty &&
        _validPharmaceuticalFormPatterns.any((pattern) => pharmaceuticalForm.toLowerCase().startsWith(pattern));
  }

  bool _medicineTypeValid() {
    String? medicineType = _medicineMap[Medication.medicineTypeFieldName];
    return medicineType != null && medicineType == 'Ludzki';
  }

  bool _targetSpeciesValid() {
    String? targetSpecies = _medicineMap[Medication.targetSpeciesFieldName];
    return targetSpecies == null || targetSpecies.isEmpty;
  }

  //50,5 mcg        -> yes
  //5 mg + 0.2 mg   -> no
  final RegExp _potencyRegex = RegExp(r"^(\d+(,\d+)?) (mcg|g|mg)$");

  bool _potencyValid() {
    String? potency = _medicineMap[Medication.potencyFieldName];
    return potency != null && potency.isNotEmpty && potency != '-' && _potencyRegex.hasMatch(potency);
  }

  bool _permitValidityValid() {
    String? permitValidity = _medicineMap[Medication.permitValidityFieldName];
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
        _logger.severe('Failed to parse permit date from $permitValidity', e, stackTrace);
        result = false;
      }
    }
    return result;
  }

  bool _packagingValid() {
    String? packaging = _medicineMap[Medication.packagingFieldName];
    return packaging != null && packaging.isNotEmpty;
  }
}
