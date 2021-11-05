
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

import '../pylons_app.dart';
class SnackbarToast {
  static void show(String msg){
    ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context)
        .showSnackBar(SnackBar(
      content: Text("$msg"),
    ),);
  }
}

class Loading {
  Loading();
  var diagRet = null;

  void dismiss() {
    navigatorKey.currentState!.pop();
  }
  Loading showLoading() {
    diagRet = showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) =>
          AlertDialog(
            content: Wrap(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                    const HorizontalSpace(10),
                    Text(
                      "Loading...",
                      style:
                      Theme
                          .of(ctx)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
    );
    return this;
  }
}