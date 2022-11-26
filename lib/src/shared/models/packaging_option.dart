import 'package:drugs_dosage_app/src/shared/models/root_model.dart';

class PackagingOption extends RootDatabaseModel {
  static const String _databaseName = 'packaging';

  static const String externalIdFieldName = 'externalId';
  static const String categoryFieldName = 'category';
  static const String numberFieldName = 'number';
  static const String freeTextFieldName = 'freeText';

  String externalId;
  String category;
  String number;
  String freeText;

  PackagingOption(
      {super.id,
      required this.externalId,
      required this.category,
      required this.number,
      required this.freeText});

  @override
  factory PackagingOption.fromJson(Map<String, dynamic> json) {
    return PackagingOption(
      id: json[RootDatabaseModel.idFieldName],
      externalId: json[externalIdFieldName],
      category: json[categoryFieldName],
      number: json[numberFieldName],
      freeText: json[freeTextFieldName],
    );
  }

  @override
  String getDatabaseName() {
    return databaseName();
  }

  static String databaseName() {
    return _databaseName;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
      externalIdFieldName: externalId,
      categoryFieldName: category,
      numberFieldName: number,
      freeTextFieldName: freeText
    };
    return map;
  }
}
