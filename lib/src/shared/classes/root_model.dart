abstract class RootDatabaseModel {
  //DateTime createTime;
  //DateTime updateTime;
  final int? id;

  const RootDatabaseModel({
    this.id,
  });

  Map<String, dynamic> toMap();
}
