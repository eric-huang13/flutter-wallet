import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class CurrencyScreen extends StatefulWidget {
  CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  void initState() {
    super.initState();
    _buildAssetsList();
  }
  var _assets = <Balance>[];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.cached_outlined, color: kBlue,),
              onPressed: () {
                _buildAssetsList();
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _assets.length,
            itemBuilder: (_, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: screenSize.width(),
              height: screenSize.width(percent: 0.4),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/icons/purple_card.png",),
                fit: BoxFit.fill),
              ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text("${_assets[index].denom}",
                        style: Theme.of(_).textTheme.subtitle1!.copyWith(
                          color: Colors.white
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("${_assets[index].amount}",
                          style: Theme.of(_).textTheme.subtitle1!.copyWith(
                              color: Colors.white
                          )),
                    ),
                  ]),
                )));
  }

  Future<void> _buildAssetsList() async {
    setState(() {
      isLoading = true;
    });
    //Query the balance and update it.
    final balanceObj = PylonsBalance(GetIt.I.get());
    final balances =
        await balanceObj.getBalance(PylonsApp.currentWallet.publicAddress);

    setState(() {
      isLoading = false;
      _assets = balances;
    });
  }
}
