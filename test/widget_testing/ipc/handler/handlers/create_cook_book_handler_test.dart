import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';

var MOCK_COOKBOOK = """
{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "ID": "cookbookLOUD",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}""";

void main() {
  testWidgets('test createCookBook handler', (tester) async {




    await tester.pumpWidget( MaterialApp(
      navigatorKey: navigatorKey,
      home: const Scaffold(),
    ));



    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);



    final  sdkipcMessage = SDKIPCMessage(action: HandlerFactory.TX_CREATE_COOKBOOK, json: MOCK_COOKBOOK , sender: 'Sending app');


    final handler = CreateCookBookHandler(sdkipcMessage);
    final response = await handler.handle();
    expect(MOCK_TRANSACTION.txHash, response.data);

  });
}
