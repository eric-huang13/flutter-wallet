import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pages/new_screens/purchase_item_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/transactions/get_recipe.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'models/sdk_ipc_response.dart';

/// Terminology
/// Signal : Incoming request from a 3rd party app
/// Key : The key is the process against which the 3rd part app has sent the signal

class IPCEngine {
  late StreamSubscription _sub;

  bool systemHandlingASignal = false;

  /// This method initiate the IPC Engine
  Future<bool> init() async {
    log('init', name: '[IPCEngine : init]');

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
    if (_isEaselUniLink(initialLink)) {
      _handleEaselLink(initialLink);
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

    //
    // if (systemHandlingASignal) {
    //   disconnectThisSignal(sender: getMessage.first, key: getMessage[1]);
    //   return [];
    // }

    debugPrint(getMessage);
    //
    // systemHandlingASignal = true;
    //
    await showApprovalDialog(sdkIPCMessage: sdkIPCMessage);
    // systemHandlingASignal = false;
    // return getMessage;
  }

  /// This method handles the link that the wallet received on click of the easel generated link
  /// Input : [link] contains the link that is received when you click the easel generated link.
  /// the [link] must follow a particular structure containing action, cookbook_id and recipe_id
  /// in its query parameters e.g http://wallet.pylons.tech/?action=purchase_nft
  /// &cookbook_id=Easel_autocookbook_pylo149haucpqld30pksrzqyff67prswul9vmmle27v
  /// &recipe_id=pylo149haucpqld30pksrzqyff67prswul9vmmle27v_2021_10_18_12_11_55&nft_amount=1
  /// Output : [void] contains the decoded message
  Future<void> _handleEaselLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final recipeId = queryParameters['recipe_id'];
    final cookbookId = queryParameters['cookbook_id'];

    _showLoading();

    final recipeResult = await GetRecipe(GetIt.I.get<BaseEnv>()).getRecipe(cookbookId!, recipeId!);

    navigatorKey.currentState!.pop();

    recipeResult.fold((exception) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(
        SnackBar(
          content: Text("$exception"),
        ),
      );
    }, (recipeJson) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => PurchaseItemScreen(
            recipe: recipeJson,
          ),
        ),
      );
      return;
    });
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

  /// This is a temporary dialog for the proof of concept.
  /// Input : [sdkIPCMessage] The sender of the signal
  /// Output : [key] The signal kind against which the signal is sent
  Future showApprovalDialog({required SDKIPCMessage sdkIPCMessage}) {
    return showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.overlay!.context,
        builder: (_) => AlertDialog(
              content: const Text('Allow this transaction'),
              actions: [
                RaisedButton(
                  onPressed: () async {
                    Navigator.of(_).pop();

                    final handlerMessage = await GetIt.I.get<HandlerFactory>().getHandler(sdkIPCMessage).handle();
                    debugPrint("$handlerMessage");
                    await dispatchUniLink(handlerMessage.createMessageLink(isAndroid: Platform.isAndroid));
                  },
                  child: const Text('Approval'),
                ),
                RaisedButton(
                  onPressed: () async {
                    Navigator.of(_).pop();

                    final cancelledResponse = SDKIPCResponse.failure(sender: sdkIPCMessage.sender, error: '', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: sdkIPCMessage.action);
                    await dispatchUniLink(cancelledResponse.createMessageLink(isAndroid: Platform.isAndroid));
                  },
                  child: const Text('Disapprove'),
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

  ///This method checks if the incoming link is generated from Easel
  bool _isEaselUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey("action") && queryParam.containsKey("recipe_id") && queryParam.containsKey("nft_amount") && queryParam.containsKey("cookbook_id");
  }

  void _showLoading() {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Wrap(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
                const HorizontalSpace(10),
                Text(
                  "Loading...",
                  style: Theme.of(ctx).textTheme.subtitle2!.copyWith(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}