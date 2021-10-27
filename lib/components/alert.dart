import 'package:flutter/material.dart';

class Alert {
  static void SnackbarAlert(BuildContext context, String msg){
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('User name is Empty'),
      ));
    Navigator.of(context).pop();
  }
}