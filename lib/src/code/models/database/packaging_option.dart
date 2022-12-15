import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';

class PackagingOption extends RootDatabaseModel {
  static const String _databaseName = 'packaging';

  static const rootJsonFieldName = 'packages';

  static const String medicineIdFieldName = 'medicineId';
  static const String categoryFieldName = 'category';
  static const String countFieldName = 'count';
  static const String rawCountFieldName = 'rawCount';

  //foreign key
  int medicineId;
  String category;
  String rawCount;
  int? count;

  PackagingOption(
      {super.id,
      required this.medicineId,
      required this.category,
      required this.rawCount,
      this.count});

  @override
  factory PackagingOption.fromJson(Map<String, dynamic> json) {
    return PackagingOption(
      id: json[RootDatabaseModel.idFieldName],
      medicineId: json[medicineIdFieldName],
      category: json[categoryFieldName],
      rawCount: json[rawCountFieldName],
      count: json[countFieldName],
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
      countFieldName: count
    };
    return map;
  }
}
