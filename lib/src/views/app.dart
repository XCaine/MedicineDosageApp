import 'package:drugs_dosage_app/src/views/bmi_calculator/bmi_calculator_screen.dart';
import 'package:drugs_dosage_app/src/views/drugs_search/drugs_search.dart';
import 'package:drugs_dosage_app/src/views/home/home_screen.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_confirmation.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/manage_medications.dart';
import 'package:drugs_dosage_app/src/ztemp/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../code/constants/constants.dart';
import 'dosage_calculator_wizard/step1_search/step1_medicine_search.dart';

class MedicalCalculatorApp extends StatefulWidget {
  const MedicalCalculatorApp({Key? key}) : super(key: key);

  @override
  State<MedicalCalculatorApp> createState() => _MedicalCalculatorAppState();
}

class _MedicalCalculatorAppState extends State<MedicalCalculatorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Kalkulator Medyczny',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(
      path: Constants.homeScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: Constants.drugsScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const DrugsList();
      },
    ),
    GoRoute(
      path: Constants.bmiCalculatorScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const BmiCalculator();
      },
    ),
    GoRoute(
      path: Constants.drugDosageCalculatorScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const DosageCalculatorSearch();
      }
    ),
    GoRoute(
      path: Constants.settingsScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const Settings();
      }
    ),
    GoRoute(
      path: Constants.manageMedicationScreenRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const ManageMedications();
        }
    ),
    GoRoute(
        path: Constants.addMedicationConfirmationScreenRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const AddMedicationConfirmation();
        }
    )
  ]);
}
