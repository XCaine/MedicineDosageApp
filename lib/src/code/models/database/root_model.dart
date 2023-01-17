abstract class RootDatabaseModel {
  final DateTime createTime = DateTime.now();
  DateTime updateTime = DateTime.now();
  int? id;

  static const String idFieldName = 'id';

  RootDatabaseModel({this.id});

  Map<String, dynamic> toMap();

  String getTableName();
}
