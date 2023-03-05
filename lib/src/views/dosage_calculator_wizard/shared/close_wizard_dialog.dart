import 'package:flutter/material.dart';

class CloseWizardDialog {
  static Future<void> show(
      BuildContext context, String content, String confirmMessage, Function onConfirmAction) async {
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
                child: const Text('Anuluj')),
            TextButton(
                onPressed: () {
                  onConfirmAction();
                  Navigator.of(context).pop();
                },
                child: Text(confirmMessage)),
          ],
        );
      },
    );
  }
}
