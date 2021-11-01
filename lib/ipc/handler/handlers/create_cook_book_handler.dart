import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

/// This handler handles the create cook book transaction request from 3 party apps
class CreateCookBookHandler implements BaseHandler {

  CreateCookBookHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;

    jsonMap.remove('nodeVersion');
    var loading = Loading().showLoading();

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createCookBook(jsonMap);
    loading.dismiss();
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;
    if (response.error == ""){
      SnackbarToast.show("Coookbook ${jsonMap['name']} Created");
    }

    debugPrint('Response $response');

    return SynchronousFuture(response);
  }

  @override
  SDKIPCMessage sdkipcMessage;
}
