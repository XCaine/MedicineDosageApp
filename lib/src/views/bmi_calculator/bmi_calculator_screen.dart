import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({Key? key}) : super(key: key);

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmi;

  String _message = 'Wprowadź swoją wagę i wzrost';

  void _calculateBmi() {
    final double? height = double.tryParse(_heightController.value.text);
    final double? weight = double.tryParse(_weightController.value.text);

    if (height == null || height <= 0 || weight == null || weight <= 0) {
      setState(() {
        _message = "Waga lub wzrost są niepoprawne";
      });
      return;
    }
    double heightInMeters = height / 100;
    setState(() {
      _bmi = weight / (heightInMeters * heightInMeters);
      if (_bmi! < 16.0) {
        _message = "Znaczna niedowaga";
      } else if (_bmi! < 16.9) {
        _message = "Niedowaga";
      } else if (_bmi! < 18.4) {
        _message = "Lekka niedowaga";
      } else if (_bmi! < 24.9) {
        _message = "Poprawna waga";
      } else if (_bmi! < 29.9) {
        _message = "Nadwaga";
      } else if (_bmi! < 34.9) {
        _message = 'Otyłość (klasa I)';
      } else if (_bmi! < 39.9) {
        _message = 'Otyłość (klasa II)';
      } else {
        _message = 'Otyłość (klasa III)';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _heightController.dispose();
    _weightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bmiWidget = Center(
      child: SizedBox(
        width: 320,
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Wysokość (cm)'),
                  controller: _heightController,
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Waga (kg)',
                  ),
                  controller: _weightController,
                ),
                ElevatedButton(
                  onPressed: _calculateBmi,
                  child: const Text('Oblicz'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  _bmi == null ? 'Brak wyniku' : _bmi!.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 50),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMI'),
        actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
      ),
      body: bmiWidget,
    );
  }
}
