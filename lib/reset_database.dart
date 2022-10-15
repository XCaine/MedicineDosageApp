import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

main() {
  _deleteDatabase();
}

_deleteDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory.deleteDatabase(
    join(await getDatabasesPath(), 'medical_app_database.db'),
  ).then((value) => print('Database deleted'));

  exit(0);
}