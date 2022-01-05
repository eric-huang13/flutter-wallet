import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';

TransactionHash MOCK_TRANSACTION = TransactionHash(
    txHash: '64CFE19786363B8C6AB10D865A5C570C3999AB0B95E5723BE584F574FC58F99E');

String MOCK_USERNAME = "Jawad";
String SENDER_APP = 'Sending app';

var MOCK_COOKBOOK = """
{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "ID": "$MOCK_COOKBOOK_ID",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}""";

var MOCK_RECIPE = """
{
  "cookbookID": "$MOCK_COOKBOOK_ID",
  "ID": "$MOCK_RECIPE_ID",
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

const String MOCK_COOKBOOK_ID = 'cookbookLOUD';

const String MOCK_STRIPEURL = '';
const String MOCK_STRIPEPUBKEY = '';
const String MOCK_ADDRESS = 'pylo18238123823kjhgda7w1';
const String MOCK_RECIPE_ID = 'recipeid';
const String MOCK_ITEM_ID = 'itemId';
const String MOCK_EXECUTION_ID = 'executionId';
const String MOCK_ERROR = 'SOMETHING_WENT_WRONG';
const String MOCK_RECIPE_VERSION = 'recipe version';
const String MOCK_NODE_VERSION = 'node version';
const String MOCK_MNEMONIC =
    'badge major relax fine life payment monkey glow arrive logic token genuine disagree spice scrub ripple interest pottery fire okay gather measure race ill';

Item MOCK_ITEM = Item(
  owner: '',
  cookbookID: MOCK_COOKBOOK_ID,
  iD: MOCK_ITEM_ID,
  nodeVersion: 'v1.0.0',
  doubles: [],
  longs: [],
  strings: [],
);

Execution MOCK_EXECUTION = Execution(
  creator: MOCK_ADDRESS,
  iD: MOCK_EXECUTION_ID,
  cookbookID: MOCK_COOKBOOK_ID,
  recipeVersion: MOCK_RECIPE_VERSION,
  nodeVersion: MOCK_NODE_VERSION,
);

BaseEnv MOCK_BASE_ENV = BaseEnv();
