import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

//unilink key format constants
const KEY_PURCHASE_NFT  = "purchase_nft";
const KEY_COOKBOOK_ID   = "cookbook_id";
const KEY_RECIPE_ID     = "recipe_id";
const KEY_NFT_AMOUNT    = "nft_amount";

/// Terminology
/// Signal : Incoming request from a 3rd party app
/// Key : The key is the process against which the 3rd part app has sent the signal
class IPCEngine {
  late BuildContext context;

  late StreamSubscription _sub;

  bool systemHandlingASignal = false;


  /// This method initiate the IPC Engine
  Future<bool> init(BuildContext context) async {
    log('init', name: '[IPCEngine : init]');
    this.context = context;

    await handleInitialLink();
    setUpListener();
    return true;
  }

  /// This method setups the listener which receives
  void setUpListener() {
    _sub = linkStream.listen((String? link) {
      if (link == null) {
        return;
      }

      if(_isEaselUniLink(link)) {
        _handleEaselLink(link);
      }else {
        handleLink(link);
      }

      // Link contains the data that the wallet need
    }, onError: (err) {});
  }

  /// This method is used to handle the uni link when the app first opens
  Future<void> handleInitialLink() async {
    /// This will handle the initial delay when the app first time opens
    await Future.delayed(const Duration(seconds: 2));

    final initialLink = await getInitialLink();

    log('$initialLink', name: '[IPCEngine : handleInitialLink]');
    if (initialLink == null) {
      return;
    }
    handleLink(initialLink);
  }


  /// This method encodes the message that we need to send to wallet
  /// Input]  [msg] is the string received from the wallet
  /// Output : [List] contains the decoded response
  String encodeMessage(List<String> msg) {
    final encodedMessageWithComma = msg.map((e) => base64Url.encode(utf8.encode(e))).join(',');
    return base64Url.encode(utf8.encode(encodedMessageWithComma));
  }

  /// This method decode the message that the wallet sends back
  /// Input : [msg] is the string received from the wallet
  /// Output : [List] contains the decoded response
  List<String> decodeMessage(String msg) {
    final decoded = utf8.decode(base64Url.decode(msg));
    return decoded.split(',').map((e) => utf8.decode(base64Url.decode(e))).toList();
  }

  /// This method handles the link that the wallet received from the 3rd Party apps
  /// Input : [link] contains the link that is received from the 3rd party apps.
  /// Output : [List] contains the decoded message
  Future<List> handleLink(String link) async {
    log(link, name: '[IPCEngine : handleLink]');

    final getMessage = decodeMessage(link.split('/').last);

    if (systemHandlingASignal) {
      disconnectThisSignal(sender: getMessage.first, key: getMessage[1]);
      return [];
    }


    print(getMessage);

    systemHandlingASignal = true;

    await showApprovalDialog(
      key: getMessage[1],
      sender: getMessage.first,
      wholeMessage: getMessage,
    );
    systemHandlingASignal = false;
    return getMessage;
  }

  Future<void> _handleEaselLink(String link) async{
    final queryParameters = Uri.parse(link).queryParameters;
    final action = queryParameters['action']?? "";
    final amount = queryParameters['nft_amount']?? "";
    final cookbookID = queryParameters['cookbook_id']?? "";
    final recipeID = queryParameters['recipe_id']?? "";
    final itemID = queryParameters['item_id']?? "";
    final tradeID = queryParameters['trade_id']?? "";

    debugPrint("amount: $amount, cookbook_id: $cookbookID, recipe_id: $recipeID");

    //move to purchase Item Screen
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => DetailScreenWidget (
      cookbookID: cookbookID,
      recipeID: recipeID, pageType: DetailPageType.typeRecipe,
    )));

    /**
    final walletsStore = GetIt.I.get<WalletsStore>();

    // var jsonString ='''{
    //     "cookbookID": "cookbookLOUD",
    //     "ID": "LOUDEasel",
    //     "name": "Easel Recipe",
    //     "description": "Tests recipe",
    //     "version": "v0.0.1",
    //     "coinInputs": [
    //     {
    //     "coins": [
    //       {
    //         "denom": "upylon",
    //         "amount": "10000"
    //       }
    //     ]
    //   }
    //     ],
    //     "itemInputs": [],
    //     "entries": {
    //       "coinOutputs": [],
    //       "itemOutputs": [
    //         {
    //           "ID": "item output",
    //           "strings": [
    //             {
    //               "key": "NFT_URL",
    //               "value": "https://image_here"
    //             }
    //           ],
    //           "mutableStrings": [],
    //           "transferFee": [],
    //           "tradePercentage": "0.2",
    //           "tradeable": true
    //         }
    //       ],
    //       "itemModifyOutputs": []
    //     },
    //     "outputs": [
    //       {
    //         "entryIDs": [
    //           "basic_character_lv1"
    //         ],
    //         "weight": 1
    //       }
    //     ],
    //     "enabled": true,
    //     "extraInfo": "extraInfo"
    //   }''';

    var jsonExecuteRecipe = '''{
        "creator": "",
        "cookbookID": "cookbookLOUD",
        "recipeID": "LOUDEasel",
        "coinInputsIndex": 0,
        "itemIDs": ["item output"]
        }''';

    final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
    var response = (await walletsStore.executeRecipe(jsonMap)).txHash;

    print(response);
    */
  }

  /// This method sends the unilink to the wallet app
  /// Input : [String] is the unilink with data for the wallet app
  Future<bool> dispatchUniLink(String uniLink) async {
    if (await canLaunch(uniLink)) {
      await launch(uniLink);
      return true;
    } else {
      return false;
    }
  }

  /// This is a temporary dialog for the proof of concept.
  /// Input : [sender] The sender of the signal
  /// Output : [key] The signal kind against which the signal is sent
  Future showApprovalDialog({required String sender, required String key, required List<String> wholeMessage}) {
    return showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (_) => AlertDialog(
              content: const Text('Allow this transaction'),
              actions: [
                RaisedButton(
                  onPressed: () async {
                    Navigator.of(_).pop();

                    final handlerMessage = await GetIt.I.get<HandlerFactory>().getHandler(wholeMessage).handle();
                    print(handlerMessage);
                    await dispatchUniLink(handlerMessage);
                  },
                  child: const Text('Approval'),
                )
              ],
            ));
  }

  /// This method disposes the
  void dispose() {
    _sub.cancel();
  }

  /// This method disconnect any new signal. If another signal is already in process
  /// Input : [sender] The sender of the signal
  /// Output : [key] The signal kind against which the signal is sent
  Future<void> disconnectThisSignal({required String sender, required String key}) async {
    final encodedMessage = encodeMessage([key, 'Wallet Busy: A transaction is already is already in progress']);
    await dispatchUniLink('pylons://$sender/$encodedMessage');
  }

  //https://wallet.pylons.tech/?action=purchase_nft&cookbook_id=aaa&recipe_id=bbb&nft_amount=1
  //adb shell am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "pylons://wallet/?action=purchase_nft&cookbook_id=aaa&recipe_id=bbb&nft_amount=1"
  bool _isEaselUniLink(String link){
    print(link);
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey("action") && queryParam.containsKey("recipe_id") && queryParam.containsKey("cookbook_id") && queryParam.containsKey("nft_amount");
  }
}
