import 'package:drugs_dosage_app/src/features/root/dosage_calculator/dosage_calculator_results.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:flutter/material.dart';

class OtherInfoFormHandler {
  OtherInfoFormHandler({required key}) : _key = key;

  final GlobalKey<FormState> _key;

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'pole jest puste';
    }
    return null;
  }

  dynamic submit(BuildContext context, DosageSearchWrapper searchWrapper) {
    if (_key.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DosageCalculatorResult(
                  searchWrapper: searchWrapper,
                )),
      );
      //ScaffoldMessenger.of(context).showSnackBar(
      //  const SnackBar(content: Text('Processing Data')),
      //);
    }
  }
}
