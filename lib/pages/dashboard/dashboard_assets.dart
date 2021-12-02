import 'package:dartz/dartz.dart' as Dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

class DashboardAssets extends StatefulWidget {
  const DashboardAssets({Key? key}) : super(key: key);

  @override
  _DashboardAssetsState createState() => _DashboardAssetsState();
}

class _DashboardAssetsState extends State<DashboardAssets> {
  final walletsStore = GetIt.I.get<WalletsStore>();

  @override
  void initState() {
    super.initState();
    _buildAssetsList();
  }

  var _assetsList = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final address = PylonsApp.currentWallet.publicAddress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cached_outlined),
            onPressed: () {
              _buildAssetsList();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text("Address".tr(), style: const TextStyle(color: Colors.black, fontSize: 18)),
                      ),
                      IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: address));
                          }),
                    ],
                  ),
                  Text(address, style: const TextStyle(color: Colors.black, fontSize: 18)),
                ],
              ),
            ),
            Card(
              child: Column(
                children: _assetsList,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment Counter',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getFaucet() async {
    final result = await walletsStore.getFaucetCoin();

    if(result.isLeft()){
      return;
    }


    final amount = result.getOrElse(() => 0);

    if (amount > 0) {
      _buildAssetsList();
    }
  }

  Future<void> _buildAssetsList() async {
    final response = await GetIt.I.get<Repository>().getBalance(PylonsApp.currentWallet.publicAddress);

    if (response.isLeft()) {
      showErrorMessageToUser(response);
      return;
    }

    final assetsList = <Widget>[];
    for (final balance in response.getOrElse(() => [])) {
      final amount = balance.amount.toString();
      assetsList.add(SizedBox(
          height: 100,
          child: Row(children: <Widget>[
            Text("${balance.denom}: ", style: const TextStyle(color: Colors.indigo, fontSize: 26)),
            Text(amount, style: const TextStyle(color: Colors.black, fontSize: 26)),
            const Spacer(),
            IconButton(
                icon: Image.asset("assets/icons/receive.png"),
                onPressed: () {
                  _getFaucet();
                })
          ])));
    }
    setState(() {
      _assetsList = assetsList;
    });
  }

  void showErrorMessageToUser(Dz.Either<Failure, List<Balance>> response) {
    if (!mounted) {
      return;
    }
    context.show(message: response.swap().toOption().toNullable()!.message);
  }
}
