import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/alert.dart';
import 'package:pylons_wallet/components/buttons/pylons_blue_button_with_loader.dart';
import 'package:pylons_wallet/components/pylons_rounded_button.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/new_screens/new_home.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

// Define a custom Form widget.
class ImportFromGoogleForm extends StatefulWidget {
  final WalletsStore walletStore;

  const ImportFromGoogleForm({Key? key, required this.walletStore})
      : super(key: key);

  @override
  ImportFromGoogleFormState createState() {
    return ImportFromGoogleFormState();
  }
}

class ImportFromGoogleFormState extends State<ImportFromGoogleForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final mnemonicController = TextEditingController();

  final isLoadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 50,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/pylons_logo.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                  const VerticalSpace(30),
                  PylonsRoundedButton(
                      glyph: const AssetImage('assets/images/gcloud.png'),
                      text: "import_from_google_cloud".tr(),
                      onTap: () {}),
                  const VerticalSpace(20),
                  PylonsTextInput(
                      controller: usernameController, label: "user_name".tr()),
                  const VerticalSpace(20),
                  PylonsTextInput(
                      controller: mnemonicController,
                      label: "enter_mnemonic".tr()),
                  const VerticalSpace(30),
                  PylonsBlueButtonLoading(
                    onTap: () {
                      _loginExistingUser(
                          neumonic: mnemonicController.text,
                          userName: usernameController.text);
                    },
                    text: "start_pylons".tr(),
                    loader: isLoadingNotifier,
                  ),
                  const VerticalSpace(20),
                ],
              )) // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  /// Create the new wallet and associate the chosen username with it.
  Future _loginExistingUser(
      {required String userName, required String neumonic}) async {
    isLoadingNotifier.value = true;

    final result = await widget.walletStore
        .importPylonsAccount(mnemonic: neumonic, username: userName);

    isLoadingNotifier.value = false;

    result.fold((failure) {
      Alert.SnackbarAlert(context, failure.message);
    }, (walletInfo) {
      PylonsApp.currentWallet = walletInfo;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NewHomeScreen()),
          (route) => true);
    });
  }
}
