
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeScreen extends StatefulWidget {
  final String token;
  final String url;
  const StripeScreen({Key? key, required this.token, required this.url}) : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen>
{
  late WebViewController _controller;
  @override
  void initState(){
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return WebView(
      initialUrl: widget.url,
      navigationDelegate: (request) {
        if (request.url.contains('mail.google.com')) {
          print('Trying to open Gmail');
          Navigator.pop(context); // Close current window
          return NavigationDecision.prevent; // Prevent opening url
        } else if (request.url.contains('youtube.com')) {
          print('Trying to open Youtube');
          return NavigationDecision.navigate; // Allow opening url
        } else {
          return NavigationDecision.navigate; // Default decision
        }
      },
    );
  }
}