import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/material.dart';

import 'src/views/app.dart';

//DB IS LOCATED IN data/data/com.pw.drugs_dosage_app/databases/medical_app_database.db
void main() {
  //TODO trzymać plik z lekami nie z api tylko lokalnie; jak nie ma sieci albo
  //nie uda się załadować wersji sieciowe, załadować wersję lokalną.
  //ew potem można wszystko usunąć jeżeli chcemy zupdate'ować do wersji sieciowej
  //można dodać do medicine pole wskazujące czy source to api, czy użytkownik
  //jeżeli będę robił CRUDa do medicine + package
  LogDistributor.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseBroker.initialize();
  runApp(const MedicalCalculatorApp());
}
