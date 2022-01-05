import 'package:flutter/material.dart';
import 'package:pylons_wallet/forms/new_user_form.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class CreateAccountBottomSheet {
  BuildContext context;
  WalletsStore walletsStore;

  CreateAccountBottomSheet({required this.context, required this.walletsStore});

  Future show() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: [
              NewUserForm(
                walletsStore: walletsStore,
              )
            ]));
  }
}
