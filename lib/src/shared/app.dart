import 'package:drugs_dosage_app/src/features/root/dosage_calculator/dosage_calculator_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/root/bmi_calculator/bmi_calculator_screen.dart';
import '../features/root/drugs/drugs_screen.dart';
import '../features/root/home/home_screen.dart';
import 'constants/constants.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'AppName',
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
        return DosageCalculatorSearch();
      }
    )
  ]);
}
