import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_check_widget.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/pylons_text_input_with_title.dart';
import 'package:pylons_wallet/pages/account/create_account_email_confirmation_screen.dart';

class CreateAccountMainScreen extends StatefulWidget {
  @override
  State<CreateAccountMainScreen> createState() =>
      _CreateAccountMainScreenState();
}

class _CreateAccountMainScreenState extends State<CreateAccountMainScreen> {
  List<String> options = [
    "minimum_char".tr(),
    "special_char".tr(),
    "uppercase_letter".tr(),
  ];

  List<bool> optionValues = [
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 24, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "create_account".tr(),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF080830),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/pylon.png',
                  width: 28,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  "welcome_to_pylons".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: const Color(0xFF080830)),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              "sign_up_title".tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: const Color(0xFF616161)),
            ),
            const SizedBox(
              height: 30,
            ),
            PylonsTextInputWithTitle(
              title: "email_address".tr(),
              hint: "email_hint".tr(),
              inputType: TextInputType.emailAddress,
            ),
            PylonsTextInputWithTitle(
              title: "password".tr(),
              hint: "password_hint".tr(),
              inputType: TextInputType.visiblePassword,
            ),
            _buildPasswordValidation(context),
            PylonsTextInputWithTitle(
              title: "confirm_password".tr(),
              hint: "password_hint".tr(),
              inputType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 32,
            ),
            PylonsBlueButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateAccountEmailConfirmationScreen(),
                  ),
                );
              },
              text: "next".tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordValidation(
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 10),
      padding: const EdgeInsets.only(left: 16, top: 8.0, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: const Color(0xFFC4C4C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "password_need_to".tr(),
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: const Color(0xFF616161)),
          ),
          Column(
            children: List.generate(options.length, (i) {
              return _buildOptions(
                text: options[i],
                isChecked: optionValues[i],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions({required String text, required bool isChecked}) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Row(
        children: [
          PylonsCheckWidget(
            isChecked: isChecked,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(text)
        ],
      ),
    );
  }
}
