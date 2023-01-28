import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';

class Package extends RootDatabaseModel {
  static const String _tableName = 'package';

  static const String jsonIdentifierFieldName = 'packages';

  static const String medicineIdFieldName = 'medicineId';
  static const String categoryFieldName = 'category';
  static const String countFieldName = 'count';
  static const String rawCountFieldName = 'rawCount';

  //foreign key
  final int medicineId;
  final String category;
  final String rawCount;
  final int? count;

  Package(
      {super.id,
      required this.medicineId,
      required this.category,
      required this.rawCount,
      this.count,
      super.isCustom = 1});

  @override
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json[RootDatabaseModel.idFieldName],
      medicineId: json[medicineIdFieldName],
      category: json[categoryFieldName],
      rawCount: json[rawCountFieldName],
      count: json[countFieldName],
    );
  }

  @override
  String getTableName() {
    return tableName();
  }

  static String tableName() {
    return _tableName;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
      medicineIdFieldName: medicineId,
      categoryFieldName: category,
      countFieldName: count,
      RootDatabaseModel.isCustomFieldName: isCustom
    };
    return map;
  }
}
