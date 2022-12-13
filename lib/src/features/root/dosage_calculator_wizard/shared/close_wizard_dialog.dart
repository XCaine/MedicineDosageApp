import 'package:drugs_dosage_app/src/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseWizardDialog {

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Czy na pewno chcesz zamknąć kalkulator?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Anuluj')
            ),
            TextButton(
                onPressed: () {
                  context.go(Constants.homeScreenRoute);
                },
                child: const Text('Zamknij')
            ),
          ],
        );
      },
    );
  }
}