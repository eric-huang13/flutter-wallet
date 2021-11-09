import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';

var MOCK_RECIPE = """
{
  "cookbookID": "cookbook_for_test7",
  "ID": "cookbook_for_test_2021_10_22_09_13_594",
  "name": "Test NFT v3",
  "description": " A simple test recipe to be executed",
  "version": "v1.0.0",
  "coinInputs": [
    {
      "coins": [
        {
          "denom": "upylon",
          "amount": "350"
        }
      ]
    }
  ],
  "itemInputs": [],
  "entries": {
    "coinOutputs": [],
    "itemOutputs": [
      {
        "ID": "How_do_you_do_turn_this_on",
        "doubles": [
          {
            "key": "Residual",
            "weightRanges": [
              {
                "lower": "2000000000000000000",
                "upper": "2000000000000000000",
                "weight": 1
              }
            ]
          }
        ],
        "longs": [
          {
            "key": "Quantity",
            "weightRanges": [
              {
                "lower": 34,
                "upper": 34,
                "weight": 1
              }
            ]
          },
          {
            "key": "Width",
            "weightRanges": [
              {
                "lower": 960,
                "upper": 960,
                "weight": 1
              }
            ]
          },
          {
            "key": "Height",
            "weightRanges": [
              {
                "lower": 1280,
                "upper": 1280,
                "weight": 1
              }
            ]
          }
        ],
        "strings": [
          {
            "key": "Name",
            "value": "How do you do turn this on"
          },
          {
            "key": "App_Type",
            "value": "Avatar"
          },
          {
            "key": "Description",
            "value": "This is NFT Description for Test "
          },
          {
            "key": "NFT_URL",
            "value": "https://i.imgur.com/QechbvX.jpg"
          },
          {
            "key": "Currency",
            "value": "upylon"
          },
          {
            "key": "Price",
            "value": "450"
          },
          {
            "key": "Creator",
            "value": "NFT Studio"
          }
        ],
        "mutableStrings": [],
        "transferFee": [{"denom": "upylon",
          "amount": "10"
        }],
        "tradePercentage": "100000000000000000",
        "amountMinted": 0,
        "quantity": 30,
        "tradeable": true
      }
    ],
    "itemModifyOutputs": []
  },
  "outputs": [
    {
      "entryIDs": [
        "How_do_you_do_turn_this_on"
      ],
      "weight": 1
    }
  ],
  "blockInterval": 1,
  "enabled": true
}""";

void main() {
  testWidgets('test recipe handler', (tester) async {
    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);



    await tester.pumpWidget( MaterialApp(
      navigatorKey: navigatorKey,
      home: const Scaffold(),
    ));



    final sdkipcMessage = SDKIPCMessage(action: HandlerFactory.TX_CREATE_RECIPE, json: MOCK_RECIPE, sender: SENDER_APP);

    final handler = CreateRecipeHandler(sdkipcMessage);
    final response = await handler.handle();
    expect(MOCK_TRANSACTION.txHash, response.data);
  });
}
