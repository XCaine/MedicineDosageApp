abstract class RootDatabaseModel {
  final DateTime createTime = DateTime.now();
  DateTime updateTime = DateTime.now();
  int? id;
  int isCustom;

  static const String idFieldName = 'id';
  static const isCustomFieldName = 'isCustom';

  RootDatabaseModel({this.id, this.isCustom = 1});

  Map<String, dynamic> toMap();

  String getTableName();
}
