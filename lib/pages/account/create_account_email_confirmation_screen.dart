import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_main.dart';

class CreateAccountEmailConfirmationScreen extends StatelessWidget {
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
          children: [
            const SizedBox(
              height: 34,
            ),
            Image.asset(
              'assets/images/email_confirm.png',
              height: 223,
            ),
            const SizedBox(
              height: 63,
            ),
            Text(
              "verify_email".tr(),
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: const Color(0xFF080830)),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "verify_email_subtitle".tr(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: const Color(0xFF616161)),
            ),
            Text(
              "choeun.park@pylons.tech".tr(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: const Color(0xFF1212C4), fontWeight: FontWeight.w600),
            ),
            Text(
              "verify_email_subtitle2".tr(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: const Color(0xFF616161)),
            ),
            const Spacer(flex: 2,),
            PylonsBlueButton(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => Dashboard()),
                        (route) => true);
              },
              text: "start_pylons".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
