import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _drugsScreen = 'drugsScreen';
  static const String _bmiCalculator = 'bmiCalculator';
  static const String _dosageCalculator = 'dosageCalculator';
  static const String _settings = 'settings';
  static const String _manageMedications = 'manageMedications';
  static const Map<String, String> _routerOptionsMap = {
    _drugsScreen: Constants.drugsScreenRoute,
    _bmiCalculator: Constants.bmiCalculatorScreenRoute,
    _dosageCalculator: Constants.drugDosageCalculatorScreenRoute,
    _settings: Constants.settingsScreenRoute,
    _manageMedications: Constants.manageMedicationScreenRoute,
  };

  Icon _getIconForLink(String link) {
    Icon resultIcon = const Icon(Icons.disabled_by_default_outlined);
    switch (link) {
      case _drugsScreen:
        resultIcon = const Icon(Icons.info_outline);
        break;
      case _dosageCalculator:
        resultIcon = const Icon(Icons.calculate_outlined);
        break;
      case _bmiCalculator:
        resultIcon = const Icon(Icons.monitor_weight_outlined);
        break;
      case _settings:
        resultIcon = const Icon(Icons.settings);
        break;
      case _manageMedications:
        resultIcon = const Icon(Icons.edit);
        break;
    }
    return resultIcon;
  }

  String _getTitleForLink(String link) {
    String result = '';
    switch (link) {
      case _drugsScreen:
        result = 'Baza leków';
        break;
      case _dosageCalculator:
        result = 'Kalkulator dawek';
        break;
      case _bmiCalculator:
        result = 'Kalkulator BMI';
        break;
      case _settings:
        result = 'Ustawienia';
        break;
      case _manageMedications:
        result = 'Zarządzanie lekami';
        break;
    }
    return result;
  }

  void _navigateToScreen(BuildContext context, String link) {
    String destination = _routerOptionsMap[link]!;
    context.go(destination);
  }

  Widget _menuLink(String link) {
    return GestureDetector(
      onTap: () => _navigateToScreen(context, link),
      child: SizedBox(
          height: 100,
          width: 180,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                  child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _getIconForLink(link),
                  ),
                  Expanded(flex: 4, child: Text(_getTitleForLink(link)))
                ],
              )),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_menuLink(_drugsScreen), _menuLink(_dosageCalculator)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_menuLink(_bmiCalculator), _menuLink(_manageMedications)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_menuLink(_settings)],
            ),
          ],
        ),
      ),
    );
  }
}
