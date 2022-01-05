import 'package:cosmos_utils/mnemonic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pylons_wallet/components/alert.dart';
import 'package:pylons_wallet/components/buttons/pylons_blue_button_with_loader.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/new_screens/new_home.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

import '../pylons_app.dart';

// Define a custom Form widget.
class NewUserForm extends StatefulWidget {
  final WalletsStore walletsStore;

  const NewUserForm({Key? key, required this.walletsStore}) : super(key: key);

  @override
  NewUserFormState createState() => NewUserFormState();
}

class NewUserFormState extends State<NewUserForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();

  final isLoadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                  Container(
                    height: 100,
                  ),
                  PylonsTextInput(
                      controller: usernameController,
                      label: "user_name".tr(),
                      errorText: validateUsername),
                  const VerticalSpace(50),
                  PylonsBlueButtonLoading(
                    onTap: onStartPylonsPressed,
                    text: "start_pylons".tr(),
                    loader: isLoadingNotifier,
                  ),
                  const VerticalSpace(30)
                ],
              )) // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'User name is Empty';
    }

    return null;
  }

  Future<void> onStartPylonsPressed() async {
    if (_formKey.currentState!.validate()) {
      _registerNewUser(usernameController.value.text);
    }
  }

  /// Create the new wallet and associate the chosen username with it.
  Future _registerNewUser(String userName) async {
    isLoadingNotifier.value = true;

    final isAccountExists = await widget.walletsStore.isAccountExists(userName);

    if (isAccountExists) {
      isLoadingNotifier.value = false;
      Alert.SnackbarAlert(context, "${'user_name_already_exists'.tr()}!");
      return;
    }
    final _mnemonic = await generateMnemonic();
    final result =
        await widget.walletsStore.importAlanWallet(_mnemonic, userName);

    isLoadingNotifier.value = false;
    result.fold((failure) {
      Alert.SnackbarAlert(context, failure.message);
    }, (walletInfo) async {
      await Clipboard.setData(ClipboardData(text: _mnemonic));

      Alert.SnackbarAlert(context, "${'mnemonic_copied'.tr()}!");

      PylonsApp.currentWallet = walletInfo;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NewHomeScreen()),
          (route) => true);
    });
  }
}
