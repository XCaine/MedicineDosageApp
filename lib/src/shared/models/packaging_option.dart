import 'package:drugs_dosage_app/src/shared/models/root_model.dart';

class PackagingOption extends RootDatabaseModel {
  static const String _databaseName = 'packaging';

  static const List<String> drugCategories = [
    'otc', 'rp', 'rpz', 'rpw', 'lz'
  ];

  static const String medicineIdFieldName = 'medicineId';
  static const String categoryFieldName = 'category';
  static const String freeTextFieldName = 'freeText';

  //foreign key
  int medicineId;
  String category;
  String freeText;

  PackagingOption(
      {super.id,
      required this.medicineId,
      required this.category,
      required this.freeText});

  @override
  factory PackagingOption.fromJson(Map<String, dynamic> json) {
    return PackagingOption(
      id: json[RootDatabaseModel.idFieldName],
      medicineId: json[medicineIdFieldName],
      category: json[categoryFieldName],
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
      medicineIdFieldName: medicineId,
      categoryFieldName: category,
      freeTextFieldName: freeText
    };
    return map;
  }
}
