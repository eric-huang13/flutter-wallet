import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

/// This handler handles the create cook book transaction request from 3 party apps
class CreateCookBookHandler implements BaseHandler {
  final SDKIPCMessage sdkipcMessage;

  CreateCookBookHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;

    jsonMap.remove('nodeVersion');

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createCookBook(jsonMap);
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;

    debugPrint('Response $response');

    return SynchronousFuture(response);
  }
}