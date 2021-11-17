
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class StripeScreen extends StatefulWidget {
  const StripeScreen({Key? key}) : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen>
{
  @override
  Widget build(BuildContext context) {

    return Webview();
  }
}