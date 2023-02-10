import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 5000),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }
}
