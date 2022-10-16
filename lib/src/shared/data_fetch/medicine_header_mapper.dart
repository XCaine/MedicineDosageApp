import '../classes/medicine.dart';

class ApiMedicineMapper {
  static const int _productIdentifierPosition = 0;
  static const int _productNamePosition = 1;
  static const int _commonlyUsedNamePosition = 2;
  static const int _medicineTypePosition = 3;
  static const int _previousNamePosition = 4;
  static const int _targetSpeciesPosition = 5;
  static const int _gracePeriodPosition = 6;
  static const int _potencyPosition = 7;
  static const int _pharmaceuticalFormPosition = 8;
  static const int _procedureTypePosition = 9;
  static const int _permitNumberPosition = 10;
  static const int _permitValidityPosition = 11;
  static const int _atcCodePosition = 12;
  static const int _responsiblePartyPosition = 13;
  static const int _packagingPosition = 14;
  static const int _activeSubstancePosition = 15;
  static const int _flyerPosition = 16;
  static const int _characteristicsPosition = 17;

  final Map<int, String> _indexToHeaderMap = {
    _productIdentifierPosition: 'productIdentifier',
    _productNamePosition: 'productName',
    _commonlyUsedNamePosition: 'commonlyUsedName',
    _medicineTypePosition: 'medicineType',
    _previousNamePosition: 'previousName',
    _targetSpeciesPosition: 'targetSpecies',
    _gracePeriodPosition: 'gracePeriod',
    _potencyPosition: 'potency',
    _pharmaceuticalFormPosition: 'pharmaceuticalForm',
    _procedureTypePosition: 'procedureType',
    _permitNumberPosition: 'permitNumber',
    _permitValidityPosition: 'permitValidity',
    _atcCodePosition: 'atcCode',
    _responsiblePartyPosition: 'responsibleParty',
    _packagingPosition: 'packaging',
    _activeSubstancePosition: 'activeSubstance',
    _flyerPosition: 'flyer',
    _characteristicsPosition: 'characteristics',
  };

  String? _mapIndexToHeader(int index) {
    return _indexToHeaderMap[index];
  }

  Medicine mapData(List<dynamic> data) {
    final int dataLength = data.length;
    Map<String, dynamic> json = {};
    for (int index = 0; index <= dataLength - 1; index++) {
      final String? fieldName = _mapIndexToHeader(index);
      if (fieldName == null) {
        //TODO logger here
        print('Error loading medicine instance index ${data[0]}');
        continue;
      } else {
        json[fieldName] = data[index];
      }
    }

    Medicine medicineInstance = Medicine.fromJson(json);
    return medicineInstance;
  }
}
