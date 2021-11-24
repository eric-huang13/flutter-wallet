
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


  void dismiss() {
    navigatorKey.currentState!.pop();
  }



  Future showLoading({String message = "Loading"}) {
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) =>
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
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
                        message,
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
          ),
    );
  }
}