import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({required String title, required String content, super.key}) :
    _title = title,
    _content = content;

  final String _title;
  final String _content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

}