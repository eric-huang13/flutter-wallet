import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsBlueButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const PylonsBlueButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: kBlue,
      ),
      child: SizedBox(
        // height: 43,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
