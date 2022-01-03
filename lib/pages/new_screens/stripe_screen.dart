import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_handler.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
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
  bool showReturnBtn = false;
  Completer<WebViewController> controller = Completer();
  final baseEnv = GetIt.I.get<BaseEnv>();

  final dataSource = GetIt.I.get<LocalDataSource>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid)
      WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> backHistory(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<bool> loadLoginLink() async {
    final loading = Loading()..showLoading();
    final account_response = await StripeHandler().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {SnackbarToast.show(fail.message)},
        (accountlink) => {_controller.loadUrl(accountlink)});

    return true;
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          maintainBottomViewPadding: true,
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            debuggingEnabled: true,
            //userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 5 Build/LMY48B; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/43.0.2357.65 Mobile Safari/537.36',
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            javascriptChannels: [
              _extractDataJSChannel(context),
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {}),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              print('request.url' + request.url);
              if (request.url.contains(baseEnv.baseStripeCallbackUrl)) {
                widget.onBack();
                return NavigationDecision.prevent;
              }
              if (request.url.contains(baseEnv.baseStripeCallbackRefreshUrl)) {
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
            onPageFinished: (String url) {
              if (url.contains(kStripeLoginLinkPrefix) &&
                  !url.contains(kStripeAccountLinkPrefix) &&
                  !url.contains(kStripeEditSuffix)) {
                setState(() {
                  showReturnBtn = true;
                });
              } else {
                setState(() {
                  showReturnBtn = false;
                });
              }
            },
            gestureNavigationEnabled: true,
          ),
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
            backgroundColor: kBlue,
            onPressed: () {
              widget.onBack();
            },
            icon: Icon(Icons.arrow_back_ios, size: 14),
            label: Text("return_to_pylons".tr(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .1,
                    fontFamily: 'Inter')),
          ),
          visible: showReturnBtn, // set it to false
        ));
  }
}
