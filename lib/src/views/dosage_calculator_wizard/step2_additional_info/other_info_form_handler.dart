import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/step3_results/step3_calculation_results.dart';
import 'package:drugs_dosage_app/src/code/models/dosage_search.dart';
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
      if(searchWrapper.searchByDates) {
        searchWrapper.numberOfDays = searchWrapper.dateEnd!.difference(searchWrapper.dateStart!).inDays;
      } else {
        searchWrapper.dateStart = DateTime.now();
        searchWrapper.dateEnd = DateTime.now().add(Duration(days: searchWrapper.numberOfDays!));
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DosageCalculatorResult(
                  searchWrapper: searchWrapper,
                )),
      );
    }
  }
}
