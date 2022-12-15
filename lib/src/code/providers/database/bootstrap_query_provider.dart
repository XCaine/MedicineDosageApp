import 'package:drugs_dosage_app/src/code/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/code/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_provider.dart';

class BootstrapQueryProvider implements AbstractProvider {

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
      ${PackagingOption.rawCountFieldName} VARCHAR(255),
      ${PackagingOption.countFieldName} INTEGER,
      FOREIGN KEY(${PackagingOption.medicineIdFieldName}) REFERENCES ${Medicine.databaseName()}(${RootDatabaseModel.idFieldName}) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';

  @override
  List<String> provide() {
    return [_medicineQuery, _packagingOptionQuery];
  }
}
