import 'package:flutter/material.dart';

class Alert {
  static void SnackbarAlert(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
      ));
    Navigator.of(context).pop();
  }
}
