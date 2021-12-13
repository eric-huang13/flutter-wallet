import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetTradesHandler implements BaseHandler {
  @override
  SDKIPCMessage sdkipcMessage;

  GetTradesHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;
    final creator = jsonMap[HandlerFactory.CREATOR].toString();
    final response = await walletsStore.getTradesForSDK(creator: creator);
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;
    return SynchronousFuture(response);
  }
}
