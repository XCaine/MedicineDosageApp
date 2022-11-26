import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:flutter/material.dart';

import 'src/shared/app.dart';

void main() {
  LogDistributor.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseBroker.initialize();
  runApp(const MyApp());
}
