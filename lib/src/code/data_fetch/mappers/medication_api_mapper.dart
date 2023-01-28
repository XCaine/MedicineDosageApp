import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:drugs_dosage_app/src/code/data_fetch/packages_parser.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:logging/logging.dart';

import '../filters/impl/medication_api_filter.dart';

class ApiMedicationMapper {
  late final List<dynamic> parsedHeader;
  final Map<int, String> _indexToTargetFieldMap = {};
  static final Logger _logger =
      LogDistributor.getLoggerFor('ApiMedicineMapper');

  ApiMedicationMapper({required List<dynamic> incomingHeader}) {
    _parseHeader(incomingHeader);
    _buildIndexMap();
  }

  _parseHeader(List<dynamic> incomingHeader) {
    _logger.info('Parsing received CSV header');
    parsedHeader = [];
    for (String headerElement in incomingHeader) {
      String normalizedHeaderElement = removeDiacritics(headerElement)
          .replaceAll(RegExp('[^A-Za-z]'), '')
          .toLowerCase();
      parsedHeader.add(normalizedHeaderElement);
    }
  }

  _buildIndexMap() {
    _logger.info('Building index map');
    parsedHeader.asMap().forEach((index, headerFieldName) {
      var targetFieldName = _headerFieldsToModelMap[headerFieldName];
      if (targetFieldName != null) {
        _indexToTargetFieldMap[index] = targetFieldName;
      } else {
        _logger.info('Omitting header field $headerFieldName');
      }
    });
  }

  final Map<String, String> _headerFieldsToModelMap = {
    'identyfikatorproduktuleczniczego': Medication.productIdentifierFieldName,
    'nazwaproduktuleczniczego': Medication.productNameFieldName,
    'nazwapowszechniestosowana': Medication.commonlyUsedNameFieldName,
    'rodzajpreparatu': Medication.medicineTypeFieldName,
    'gatunkidocelowe': Medication.targetSpeciesFieldName,
    'moc': Medication.potencyFieldName,
    'postacfarmaceutyczna': Medication.pharmaceuticalFormFieldName,
    'waznoscpozwolenia': Medication.permitValidityFieldName,
    'podmiotodpowiedzialny': Medication.responsiblePartyFieldName,
    'opakowanie': Medication.packagingFieldName,
    'ulotka': Medication.flyerFieldName,
    'charakterystyka': Medication.characteristicsFieldName,
  };

  Medication? map(List<dynamic> data) {
    final int dataLength = data.length;
    Map<String, dynamic> json = {};

    //map all fields
    for (int index = 0; index <= dataLength - 1; index++) {
      final String? fieldName = _indexToTargetFieldMap[index];
      if (fieldName != null) {
        json[fieldName] = data[index];
      }
    }

    //validate fields
    if (!ApiMedicationFilter(medicineMap: json).isValid()) {
      return null;
    }

    //parse and additionally validate packaging info
    String packagingInfo = json[Medication.packagingFieldName];
    Map<String, dynamic> packages = PackagesParser(rawData: packagingInfo).parseToJson();
    if(packages[Package.jsonIdentifierFieldName].isEmpty) {
      return null;
    }
    String jsonEncodedPackages = jsonEncode(packages);
    json[Medication.packagingFieldName] = jsonEncodedPackages;

    //return
    Medication medicineInstance = Medication.fromJson(json);
    return medicineInstance;
  }
}
