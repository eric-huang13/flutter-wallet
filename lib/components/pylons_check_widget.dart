import 'package:flutter/material.dart';

class PylonsCheckWidget extends StatelessWidget {
  final bool isChecked;

  const PylonsCheckWidget({
    Key? key,
    required this.isChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      height: 16.0,
      child: Image.asset(
        isChecked ? 'assets/icons/checked.png' : 'assets/icons/cancel.png',
      ),
    );
  }
}
