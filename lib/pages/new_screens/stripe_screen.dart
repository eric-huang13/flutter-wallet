import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    if(Platform.isAndroid)
      WebView.platform = SurfaceAndroidWebView();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      debuggingEnabled: true,
      //userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 5 Build/LMY48B; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/43.0.2357.65 Mobile Safari/537.36',
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
      },
      javascriptChannels: [
        JavascriptChannel(
            name: 'Print', onMessageReceived: (JavascriptMessage message) {}),
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        if (request.url.contains(baseEnv.baseStripeCallbackUrl)) {
          widget.onBack();
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      gestureNavigationEnabled: true,
    );
  }
}
