import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_assets.dart';

import '../pylons_app.dart';

class PylonsAppDrawer extends StatefulWidget {
  final String title;

  const PylonsAppDrawer({
    Key? key,
    this.title = "",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PylonsAppDrawerState();
}

class PylonsAppDrawerState extends State<PylonsAppDrawer> {
  String accountName = PylonsApp.currentWallet.name;
  String walletAddress = PylonsApp.currentWallet.publicAddress;
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
  }

  void copyToClipboard() {
    Clipboard.setData(
            ClipboardData(text: PylonsApp.currentWallet.publicAddress))
        .then((_) {
      Fluttertoast.showToast(
          msg: "Wallet address copied to clipboard",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Row(
                  children: [
                    Text(accountName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter')),
                    const Icon(Icons.check_circle_rounded,
                        size: 14, color: kPeach),
                  ],
                ),
                accountEmail: Row(children: [
                  Flexible(
                    child: Text(walletAddress),
                  ),
                  IconButton(
                    icon: const ImageIcon(AssetImage('assets/icons/copy.png'),
                        size: 20, color: kSelectedIcon),
                    onPressed: () => {copyToClipboard()},
                  )
                ]),
                currentAccountPicture: const CircleAvatar(
                  child: FlutterLogo(size: 42.0),
                )),
            ListTile(
                title: const Text('Balances'),
                leading: const Icon(Icons.account_balance_wallet),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardAssets()));
                })
          ],
        ),
      ),
    );
  }
}
