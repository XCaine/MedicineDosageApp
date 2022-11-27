import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/models/root_model.dart';
import 'package:drugs_dosage_app/src/shared/providers/abstract_provider.dart';

class BootstrapQueryProvider implements AbstractProvider {
  /*final String _query = '''
    CREATE TABLE medicine(
      id INTEGER PRIMARY KEY, 
      productIdentifier VARCHAR(255) UNIQUE, 
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
    ''';*/

  final String _medicineQuery = '''
    CREATE TABLE ${Medicine.databaseName()}(
      ${RootDatabaseModel.idFieldName} INTEGER PRIMARY KEY, 
      ${Medicine.productIdentifierFieldName} VARCHAR(255) UNIQUE, 
      ${Medicine.productNameFieldName} VARCHAR(255),
      ${Medicine.commonlyUsedNameFieldName} VARCHAR(255),
      ${Medicine.potencyFieldName} VARCHAR(255),
      ${Medicine.pharmaceuticalFormFieldName} VARCHAR(255),
      ${Medicine.permitValidityFieldName} VARCHAR(255),
      ${Medicine.responsiblePartyFieldName} VARCHAR(255),
      ${Medicine.packagingFieldName} TEXT,
      ${Medicine.flyerFieldName} VARCHAR(255),
      ${Medicine.characteristicsFieldName} VARCHAR(255)
    );
    ''';

  final String _packagingOptionQuery = '''
      CREATE TABLE ${PackagingOption.databaseName()} (
      ${RootDatabaseModel.idFieldName} INTEGER PRIMARY KEY,
      ${PackagingOption.medicineIdFieldName} INTEGER,
      ${PackagingOption.categoryFieldName} VARCHAR(255),
      ${PackagingOption.freeTextFieldName} TEXT,
      FOREIGN KEY(${PackagingOption.medicineIdFieldName}) REFERENCES ${Medicine.databaseName()}(${RootDatabaseModel.idFieldName}) ON DELETE NO ACTION ON UPDATE NO ACTION
    );
    ''';

  @override
  List<String> provide() {
    return [_medicineQuery, _packagingOptionQuery];
  }
}
