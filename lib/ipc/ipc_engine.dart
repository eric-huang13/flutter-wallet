import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/ipc/widgets/sdk_approval_dialog.dart';
import 'package:pylons_wallet/pages/new_screens/asset_detail_view.dart';
import 'package:pylons_wallet/pages/new_screens/purchase_item_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

//unilink key format constants
const KEY_PURCHASE_NFT = "purchase_nft";
const KEY_COOKBOOK_ID = "cookbook_id";
const KEY_RECIPE_ID = "recipe_id";
const KEY_NFT_AMOUNT = "nft_amount";

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

      if (_isEaselUniLink(link)) {
        _handleEaselLink(link);
      } else if (_isNFTViewUniLink(link)) {
        _handleNFTViewLink(link);
      } else if (_isNFTTradeUniLink(link)) {
        _handleNFTTradeLink(link);
      } else {
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
    print(initialLink);

    if (_isEaselUniLink(initialLink)) {
      _handleEaselLink(initialLink);
    } else if (_isNFTViewUniLink(initialLink)) {
      _handleNFTViewLink(initialLink);
    } else if (_isNFTTradeUniLink(initialLink)) {
      _handleNFTTradeLink(initialLink);
    } else {
      handleLink(initialLink);
    }
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
  /// Output : [void] contains the decoded message
  Future<void> handleLink(String link) async {
    log(link, name: '[IPCEngine : handleLink]');

    final getMessage = link.split('/').last;

    SDKIPCMessage sdkIPCMessage;

    try {
      sdkIPCMessage = SDKIPCMessage.fromIPCMessage(getMessage);
    } catch (e) {
      debugPrint('Something went wrong in parsing');
      return;
    }


    debugPrint(getMessage);

    await showApprovalDialog(sdkIPCMessage: sdkIPCMessage);

  }

  Future<void> _handleEaselLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final recipeId = queryParameters['recipe_id'];
    final cookbookId = queryParameters['cookbook_id'];
    final walletsStore = GetIt.I.get<WalletsStore>();

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getRecipe(cookbookId!, recipeId!);

    showLoader.dismiss();

    if (recipeResult.isLeft()) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(
        const SnackBar(
          content: Text("NFT not exists"),
        ),
      );
    } else {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => PurchaseItemScreen(
            nft: NFT.fromRecipe(recipeResult.toOption().toNullable()!),
          ),
        ),
      );
    }
  }

  Future<void> _handleNFTTradeLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final tradeId = queryParameters['trade_id'] ?? "0";
    final walletsStore = GetIt.I.get<WalletsStore>();

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getTradeByID(Int64.parseInt(tradeId));

    showLoader.dismiss();

    if (recipeResult == null) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(
        const SnackBar(
          content: Text("NFT not exists"),
        ),
      );
    } else {
      final item = await NFT.fromTrade(recipeResult);
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => PurchaseItemScreen(nft: item),
        ),
      );
    }
  }

  Future<void> _handleNFTViewLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final itemId = queryParameters['item_id'];
    final cookbookId = queryParameters['cookbook_id'];
    final walletsStore = GetIt.I.get<WalletsStore>();

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getItem(cookbookId!, itemId!);

    showLoader.dismiss();

    if (recipeResult == null) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(
        const SnackBar(
          content: Text("NFT not exists"),
        ),
      );
    } else {
      final item = await NFT.fromItem(recipeResult);
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => AssetDetailViewScreen(nftItem: item),
        ),
      );
    }
  }

  /// This method sends the unilink to the wallet app
  /// Input : [String] is the unilink with data for the wallet app
  Future<bool> dispatchUniLink(String uniLink) async {
    try {
      if (Platform.isAndroid) {
        if (await canLaunch(uniLink)) {
          await launch(uniLink);
          return true;
        } else {
          return false;
        }
      } else {
        await launch(uniLink);
        return true;
      }
    } catch (e) {
      print("$e Something went wrong.");
      return true;
    }
  }

  /// This functions shows approval dialog to execute transactions as requested 3rd party apps.
  /// Input : [sdkIPCMessage] The sender of the signal
  Future showApprovalDialog({required SDKIPCMessage sdkIPCMessage}) async {
    final whiteListedTransactions = [HandlerFactory.GET_PROFILE, HandlerFactory.GET_COOKBOOK];

    if (whiteListedTransactions.contains(sdkIPCMessage.action)) {
      final handlerMessage = await GetIt.I.get<HandlerFactory>().getHandler(sdkIPCMessage).handle();
      debugPrint("$handlerMessage");
      await dispatchUniLink(handlerMessage.createMessageLink(isAndroid: Platform.isAndroid));
      return;
    }

    final sdkApprovalDialog = SDKApprovalDialog(
        context: navigatorKey.currentState!.overlay!.context,
        sdkipcMessage: sdkIPCMessage,
        onApproved: () async {
          final handlerMessage = await GetIt.I.get<HandlerFactory>().getHandler(sdkIPCMessage).handle();
          debugPrint("$handlerMessage");
          await dispatchUniLink(handlerMessage.createMessageLink(isAndroid: Platform.isAndroid));
        },
        onCancel: () async {
          final cancelledResponse = SDKIPCResponse.failure(sender: sdkIPCMessage.sender, error: 'User Declined the request', errorCode: HandlerFactory.ERR_USER_DECLINED, transaction: sdkIPCMessage.action);
          await dispatchUniLink(cancelledResponse.createMessageLink(isAndroid: Platform.isAndroid));
        });

    await sdkApprovalDialog.show();
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

  ///This method checks if the incoming link is generated from Easel
  bool _isEaselUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey("action") && queryParam['action'] == 'purchase_nft' && queryParam.containsKey("recipe_id") && queryParam.containsKey("nft_amount") && queryParam.containsKey("cookbook_id");
  }

  bool _isNFTViewUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey("action") && queryParam['action'] == 'nft_view' && queryParam.containsKey("item_id") && queryParam.containsKey("cookbook_id");
  }

  bool _isNFTTradeUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey("action") && queryParam['action'] == 'purchase_trade' && queryParam.containsKey("trade_id");
  }
}
