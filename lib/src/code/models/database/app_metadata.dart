import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';

class AppMetadata extends RootDatabaseModel {
  static const String _tableName = 'app_metadata';

  static const String initialLoadDoneFieldName = 'initialLoadDone';

  int? initialLoadDone;

  AppMetadata({super.id, this.initialLoadDone});

  factory AppMetadata.fromJson(Map<String, dynamic> json) {
    return AppMetadata(id: json[RootDatabaseModel.idFieldName], initialLoadDone: json[initialLoadDoneFieldName]);
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
    final map = {initialLoadDoneFieldName: initialLoadDone};
    return map;
  }
}
