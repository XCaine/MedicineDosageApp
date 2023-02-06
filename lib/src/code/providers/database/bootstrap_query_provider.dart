import 'package:drugs_dosage_app/src/code/models/database/app_metadata.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_provider.dart';

class BootstrapQueryProvider implements AbstractProvider<String> {
  final String _medicineQuery = '''
    CREATE TABLE ${Medication.tableName()}(
      ${RootDatabaseModel.idFieldName} INTEGER PRIMARY KEY, 
      ${Medication.productIdentifierFieldName} VARCHAR(255), 
      ${Medication.productNameFieldName} VARCHAR(255),
      ${Medication.commonlyUsedNameFieldName} VARCHAR(255),
      ${Medication.potencyFieldName} VARCHAR(255),
      ${Medication.pharmaceuticalFormFieldName} VARCHAR(255),
      ${Medication.permitValidityFieldName} VARCHAR(255),
      ${Medication.responsiblePartyFieldName} VARCHAR(255),
      ${Medication.packagingFieldName} TEXT,
      ${Medication.flyerFieldName} VARCHAR(255),
      ${Medication.characteristicsFieldName} VARCHAR(255),
      ${RootDatabaseModel.isCustomFieldName} INTEGER
    );
    ''';

  final String _packagingOptionQuery = '''
      CREATE TABLE ${Package.tableName()} (
      ${RootDatabaseModel.idFieldName} INTEGER PRIMARY KEY,
      ${Package.medicineIdFieldName} INTEGER,
      ${Package.categoryFieldName} VARCHAR(255),
      ${Package.rawCountFieldName} VARCHAR(255),
      ${Package.countFieldName} INTEGER,
      ${RootDatabaseModel.isCustomFieldName} INTEGER,
      FOREIGN KEY(${Package.medicineIdFieldName}) REFERENCES ${Medication.tableName()}(${RootDatabaseModel.idFieldName}) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';

  final String _appMetadataQuery = '''
    CREATE TABLE ${AppMetadata.tableName()} (
      ${RootDatabaseModel.idFieldName} INTEGER PRIMARY KEY,
      ${AppMetadata.initialLoadDoneFieldName} INTEGER,
      ${RootDatabaseModel.isCustomFieldName} INTEGER
    );
  ''';

  @override
  List<String> provide() {
    return [_medicineQuery, _packagingOptionQuery, _appMetadataQuery];
  }
}
