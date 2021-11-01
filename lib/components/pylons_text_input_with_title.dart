import 'package:flutter/material.dart';

class PylonsTextInputWithTitle extends StatelessWidget {
  final String title;
  final String hint;
  final TextInputType inputType;
  const PylonsTextInputWithTitle({
    Key? key,
    required this.title,
    required this.hint,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 4),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: const Color(0xFF616161)),
          ),
        ),
        TextFormField(
          keyboardType: inputType,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: const Color(0xFF201D1D)),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: const Color(0xFFC4C4C4)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0)),
        ),
      ],
    );
  }
}
