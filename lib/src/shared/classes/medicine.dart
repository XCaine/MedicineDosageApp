import 'package:drugs_dosage_app/src/shared/classes/root_model.dart';

class Medicine extends RootDatabaseModel {
  static const String _databaseName = 'medicine';

  final String productIdentifier; //Identyfikator Produktu Leczniczego
  final String productName; //Nazwa Produktu Leczniczego
  final String commonlyUsedName; //Nazwa powszechnie stosowana
  final String? medicineType; //Rodzaj preparatu
  final String? previousName; //Nazwa poprzednia produktu
  final String? targetSpecies; //???Gatunki docelowe
  final String? gracePeriod; //Okres karencji
  final String potency; //Moc
  final String pharmaceuticalForm; //Postać farmaceutyczna
  final String? procedureType; //Typ procedury
  final String? permitNumber; //Numer pozwolenia
  final String? permitValidity; //Ważność pozwolenia
  final String? atcCode; //Kod ATC
  final String? responsibleParty; //Podmiot odpowiedzialny
  final String packaging; //Opakowanie
  final String? activeSubstance; //Substancja czynna
  final String? flyer; //Ulotka
  final String? characteristics; //Charakterystyka

  Medicine({
    super.id,
    required this.productIdentifier,
    required this.productName,
    required this.commonlyUsedName,
    /*required*/ this.medicineType,
    /*required*/ this.previousName,
    /*required*/ this.targetSpecies,
    /*required*/ this.gracePeriod,
    required this.potency,
    required this.pharmaceuticalForm,
    /*required*/ this.procedureType,
    /*required*/ this.permitNumber,
    /*required*/ this.permitValidity,
    /*required*/ this.atcCode,
    /*required*/ this.responsibleParty,
    required this.packaging,
    /*required*/ this.activeSubstance,
    /*required*/ this.flyer,
    /*required*/ this.characteristics,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      productIdentifier: json['productIdentifier'],
      productName: json['productName'],
      commonlyUsedName: json['commonlyUsedName'],
      medicineType: json['medicineType'],
      previousName: json['previousName'],
      targetSpecies: json['targetSpecies'],
      gracePeriod: json['gracePeriod'],
      potency: json['potency'],
      pharmaceuticalForm: json['pharmaceuticalForm'],
      procedureType: json['procedureType'],
      permitNumber: json['permitNumber'],
      permitValidity: json['permitValidity'],
      atcCode: json['atcCode'],
      responsibleParty: json['responsibleParty'],
      packaging: json['packaging'],
      activeSubstance: json['activeSubstance'],
      flyer: json['flyer'],
      characteristics: json['characteristics'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
      'productIdentifier': productIdentifier,
      'productName': productName,
      'commonlyUsedName': commonlyUsedName,
      'medicineType': medicineType,
      'previousName': previousName,
      'targetSpecies': targetSpecies,
      'gracePeriod': gracePeriod,
      'potency': potency,
      'pharmaceuticalForm': pharmaceuticalForm,
      'procedureType': procedureType,
      'permitNumber': permitNumber,
      'permitValidity': permitValidity,
      'atcCode': atcCode,
      'responsibleParty': responsibleParty,
      'packaging': packaging,
      'activeSubstance': activeSubstance,
      'flyer': flyer,
      'characteristics': characteristics,
    };
    return map;
  }

  @override
  String getDatabaseName() {
    return databaseName();
  }

  static String databaseName() {
    return _databaseName;
  }

  @override
  String toString() {
    return '$productIdentifier $productName';
  }
}
