
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';



class SDKApprovalDialog {

  final BuildContext context;
  final SDKIPCMessage sdkipcMessage;
  final VoidCallback onApproved;
  final VoidCallback onCancel;



  SDKApprovalDialog({required this.context, required this.sdkipcMessage, required this.onApproved, required this.onCancel});

  Future show(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          content: Text(
              'Will you sign this ${sdkipcMessage.action}?',
              style: const TextStyle(fontSize: 18)),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(_).pop();
                onApproved.call();
              },
              child: const Text('Approve'),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).errorColor)),
              onPressed: () async {
                Navigator.of(_).pop();
                onCancel.call();
              },
              child: const Text('Cancel'),
            )
          ],
        ));
  }
}