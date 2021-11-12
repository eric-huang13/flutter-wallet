import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

class ShowLoader {
  BuildContext buildContext;


  ShowLoader(this.buildContext);

  Future show(){
    return  showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
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
                  style: Theme.of(ctx).textTheme.subtitle2!.copyWith(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );


  }


  void hide() {
    return Navigator.of(buildContext).pop();

  }





}