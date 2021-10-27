
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

class Loading {
  final BuildContext context;
  Loading(this.context);
  var diagRet = null;

  void dismiss() {
    Navigator.of(context).pop(diagRet);
  }
  Loading showLoading() {
    diagRet = showDialog(
      context: context,
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