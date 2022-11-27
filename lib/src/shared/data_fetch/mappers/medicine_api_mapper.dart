import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:drugs_dosage_app/src/shared/data_fetch/packaging_options_parser.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:logging/logging.dart';

import '../filters/impl/medicine_api_filter.dart';

class ApiMedicineMapper {
  late final List<dynamic> parsedHeader;
  final Map<int, String> _indexToTargetFieldMap = {};
  static final Logger _logger =
      LogDistributor.getLoggerFor('ApiMedicineMapper');

  ApiMedicineMapper({required List<dynamic> incomingHeader}) {
    parseHeader(incomingHeader);
    buildIndexMap();
  }

  parseHeader(List<dynamic> incomingHeader) {
    _logger.info('Parsing received CSV header');
    parsedHeader = [];
    for (String headerElement in incomingHeader) {
      String normalizedHeaderElement = removeDiacritics(headerElement)
          .replaceAll(RegExp('[^A-Za-z]'), '')
          .toLowerCase();
      parsedHeader.add(normalizedHeaderElement);
    }
  }

  buildIndexMap() {
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
    'identyfikatorproduktuleczniczego': Medicine.productIdentifierFieldName,
    'nazwaproduktuleczniczego': Medicine.productNameFieldName,
    'nazwapowszechniestosowana': Medicine.commonlyUsedNameFieldName,
    'rodzajpreparatu': Medicine.medicineTypeFieldName,
    'gatunkidocelowe': Medicine.targetSpeciesFieldName,
    'moc': Medicine.potencyFieldName,
    'postacfarmaceutyczna': Medicine.pharmaceuticalFormFieldName,
    'waznoscpozwolenia': Medicine.permitValidityFieldName,
    'podmiotodpowiedzialny': Medicine.responsiblePartyFieldName,
    'opakowanie': Medicine.packagingFieldName,
    'ulotka': Medicine.flyerFieldName,
    'charakterystyka': Medicine.characteristicsFieldName,
  };

  Medicine? map(List<dynamic> data) {
    final int dataLength = data.length;
    Map<String, dynamic> json = {};
    for (int index = 0; index <= dataLength - 1; index++) {
      final String? fieldName = _indexToTargetFieldMap[index];
      if (fieldName != null) {
        json[fieldName] = data[index];
      }
    }

    if (!ApiMedicineFilter(medicineMap: json).isValid()) {
      return null;
    }
    String packagingInfo = json[Medicine.packagingFieldName];
    Map<String, dynamic> packages =
        PackagingOptionsParser(rawData: packagingInfo).parseToJson();
    if(packages.isEmpty) {
      return null;
    }
    String jsonEncodedPackages = jsonEncode(packages);
    json[Medicine.packagingFieldName] = jsonEncodedPackages;
    Medicine medicineInstance = Medicine.fromJson(json);
    return medicineInstance;
  }
}