
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetExecutionByRecipe implements BaseHandler {
  @override
  SDKIPCMessage sdkipcMessage;

  GetExecutionByRecipe(this.sdkipcMessage);

  @override
  Future<SDKIPCResponse> handle() async {
    final jsonMap = jsonDecode(sdkipcMessage.json) as Map;
    final cookbookId =  jsonMap[HandlerFactory.COOKBOOK_ID].toString();
    final recipeId =  jsonMap[HandlerFactory.RECIPE_ID].toString();

    jsonMap.remove('nodeVersion');

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.getExecutionByRecipeId(cookbookId: cookbookId, recipeId: recipeId);
    response.sender = sdkipcMessage.sender;
    response.action = sdkipcMessage.action;
    return SynchronousFuture(response);
  }

}
