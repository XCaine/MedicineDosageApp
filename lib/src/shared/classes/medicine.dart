import 'package:drugs_dosage_app/src/shared/classes/root_model.dart';

class Medicine extends RootDatabaseModel {
  final String productIdentifier; //Identyfikator Produktu Leczniczego
  final String productName; //Nazwa Produktu Leczniczego
  final String? commonlyUsedName; //Nazwa powszechnie stosowana
  final String? medicineType; //Rodzaj preparatu
  final String? previousName; //Nazwa poprzednia produktu
  final String? targetSpecies; //???Gatunki docelowe
  final String? gracePeriod; //Okres karencji
  final String? potency; //Moc
  final String? pharmaceuticalForm; //Postać farmaceutyczna
  final String? procedureType; //Typ procedury
  final String? permitNumber; //Numer pozwolenia
  final String? permitValidity; //Ważność pozwolenia
  final String? atcCode; //Kod ATC
  final String? responsibleParty; //Podmiot odpowiedzialny
  final String? packaging; //Opakowanie
  final String? activeSubstance; //Substancja czynna
  final String? flyer; //Ulotka
  final String? characteristics; //Charakterystyka

  const Medicine({
    int? id,
    required this.productIdentifier,
    required this.productName,
    /*required*/ this.commonlyUsedName,
    /*required*/ this.medicineType,
    /*required*/ this.previousName,
    /*required*/ this.targetSpecies,
    /*required*/ this.gracePeriod,
    /*required*/ this.potency,
    /*required*/ this.pharmaceuticalForm,
    /*required*/ this.procedureType,
    /*required*/ this.permitNumber,
    /*required*/ this.permitValidity,
    /*required*/ this.atcCode,
    /*required*/ this.responsibleParty,
    /*required*/ this.packaging,
    /*required*/ this.activeSubstance,
    /*required*/ this.flyer,
    /*required*/ this.characteristics,
  }) : super(id: id);

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
    //map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return '$productIdentifier $productName';
  }

  static String getCreateTableQuery() {
    return '''
    CREATE TABLE medicine(
      id INTEGER PRIMARY KEY, 
      productIdentifier VARCHAR(255), 
      productName VARCHAR(255),
      commonlyUsedName VARCHAR(255),
      medicineType VARCHAR(255),
      previousName VARCHAR(255),
      targetSpecies VARCHAR(255),
      gracePeriod VARCHAR(255),
      potency VARCHAR(255),
      pharmaceuticalForm VARCHAR(255),
      procedureType VARCHAR(255),
      permitNumber VARCHAR(255),
      permitValidity VARCHAR(255),
      atcCode VARCHAR(255),
      responsibleParty VARCHAR(255),
      packaging TEXT,
      activeSubstance VARCHAR(255),
      flyer VARCHAR(255),
      characteristics VARCHAR(255)
    )
    ''';
  }
}
