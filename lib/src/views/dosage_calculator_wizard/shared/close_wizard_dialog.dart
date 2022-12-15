import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseWizardDialog {

  static void show(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content),
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