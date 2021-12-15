import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsWhiteButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const PylonsWhiteButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(primary: kWhite, elevation: 0),
        child: SizedBox(
          height: 43,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: kBlue)),
            ],
          ),
        ),
      ),
    );
  }
}
