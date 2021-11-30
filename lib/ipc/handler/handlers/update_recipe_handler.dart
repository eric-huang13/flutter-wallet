import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class UpdateRecipeHandler implements BaseHandler {
  @override
  SDKIPCMessage sdkipcMessage;

  UpdateRecipeHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {

    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;


    jsonMap.remove('nodeVersion');

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.updateRecipe(jsonMap);
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;
    return SynchronousFuture(response);
  }
}
