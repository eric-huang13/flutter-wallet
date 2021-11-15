import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetProfileHandler implements BaseHandler {
  @override
  SDKIPCMessage sdkipcMessage;

  GetProfileHandler(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    final loading = Loading()..showLoading();

    final response = await walletsStore.getProfile();
    loading.dismiss();

    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;
    return SynchronousFuture(response);
  }
}
