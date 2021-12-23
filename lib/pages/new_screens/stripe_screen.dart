import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class StripeScreen extends StatefulWidget {
  final String url;
  final VoidCallback onBack;
  const StripeScreen({Key? key, required this.url, required this.onBack})
      : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  late WebViewController _controller;
  final baseEnv = GetIt.I.get<BaseEnv>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> backHistory(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backHistory(context),
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                debuggingEnabled: true,
                //userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 5 Build/LMY48B; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/43.0.2357.65 Mobile Safari/537.36',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) {}),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.contains(baseEnv.baseStripeCallbackUrl)) {
                    widget.onBack();
                    return NavigationDecision.prevent;
                  }
                  if (request.url.startsWith("blob:")) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("blob_type_not_supported".tr()),
                      ));
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },

                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                gestureNavigationEnabled: true,
              ))),
    );
  }
}
