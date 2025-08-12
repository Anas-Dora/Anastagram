import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = const Color(0xffe1e2e8),
    Color textColor = const Color(0xff2e3135),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
