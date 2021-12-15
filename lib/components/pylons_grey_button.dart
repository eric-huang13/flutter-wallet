import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsGreyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const PylonsGreyButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: kUnselectedIcon,
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
