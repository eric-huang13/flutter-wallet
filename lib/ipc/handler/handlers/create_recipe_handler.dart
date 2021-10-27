import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class CreateRecipeHandler implements BaseHandler {
  SDKIPCMessage sdkipcMessage;

  CreateRecipeHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;

    jsonMap.remove('nodeVersion');

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createRecipeIPC(jsonMap);
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;

    if (response.error == ""){
      Fluttertoast.showToast(
          msg: "Coookbook ${jsonMap['name']} Created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
    }
    return SynchronousFuture(response);
  }
}
