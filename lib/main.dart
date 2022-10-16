import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:flutter/material.dart';

import 'src/shared/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHandler.initialize();
  runApp(const MyApp());
}
