import 'package:drugs_dosage_app/src/shared/models/root_model.dart';

class Medicine extends RootDatabaseModel {
  static const String _databaseName = 'medicine';

  static const String productIdentifierFieldName = 'productIdentifier';
  static const String productNameFieldName = 'productName';
  static const String commonlyUsedNameFieldName = 'commonlyUsedName';
  static const String medicineTypeFieldName = 'medicineType';
  static const String targetSpeciesFieldName = 'targetSpecies';
  static const String potencyFieldName = 'potency';
  static const String pharmaceuticalFormFieldName = 'pharmaceuticalForm';
  static const String permitValidityFieldName = 'permitValidity';
  static const String responsiblePartyFieldName = 'responsibleParty';
  static const String packagingFieldName = 'packaging';
  static const String flyerFieldName = 'flyer';
  static const String characteristicsFieldName = 'characteristics';

  final String productIdentifier; //Identyfikator Produktu Leczniczego
  final String productName; //Nazwa Produktu Leczniczego
  final String commonlyUsedName; //Nazwa powszechnie stosowana
  final String potency; //Moc
  final String pharmaceuticalForm; //Postać farmaceutyczna
  final String permitValidity; //Ważność pozwolenia
  final String? responsibleParty; //podmiot odpowiedzialny
  final String packaging; //Opakowanie
  final String? flyer; //Ulotka
  final String? characteristics; //Charakterystyka

  Medicine({
    super.id,
    required this.productIdentifier,
    required this.productName,
    required this.commonlyUsedName,
    required this.potency,
    required this.pharmaceuticalForm,
    required this.permitValidity,
    this.responsibleParty,
    required this.packaging,
    this.flyer,
    this.characteristics,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json[RootDatabaseModel.idFieldName],
      productIdentifier: json[productIdentifierFieldName],
      productName: json[productNameFieldName],
      commonlyUsedName: json[commonlyUsedNameFieldName],
      potency: json[potencyFieldName],
      pharmaceuticalForm: json[pharmaceuticalFormFieldName],
      permitValidity: json[permitValidityFieldName],
      responsibleParty: json[responsiblePartyFieldName],
      packaging: json[packagingFieldName],
      flyer: json[flyerFieldName],
      characteristics: json[characteristicsFieldName],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
      productIdentifierFieldName: productIdentifier,
      productNameFieldName: productName,
      commonlyUsedNameFieldName: commonlyUsedName,
      potencyFieldName: potency,
      pharmaceuticalFormFieldName: pharmaceuticalForm,
      permitValidityFieldName: permitValidity,
      responsiblePartyFieldName: responsibleParty,
      packagingFieldName: packaging,
      flyerFieldName: flyer,
      characteristicsFieldName: characteristics,
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
    return '$productName ($commonlyUsedName)';
  }
}
