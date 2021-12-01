import 'dart:async';

import 'package:dartz/dartz.dart' as Dz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _buildAssetsList();
    });
  }

  List<Balance> assets = <Balance>[];

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.content_copy_outlined,
              color: kBlue,
            ),
            onPressed: () {
              copyClipboard();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cached_outlined,
              color: kBlue,
            ),
            onPressed: () {
              _buildAssetsList();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: assets.length,
        itemBuilder: (_, index) => _BalanceWidget(
          balance: assets[index],
          onCallFaucet: () {
            getFaucet(context, assets[index].denom);
          },
          backgroundAsset: Constants.kCardBGList[index % Constants.kCardBGList.length],
        ),
      ),
    );
  }

  Future<void> _buildAssetsList() async {
    assets.clear();

    final response = await GetIt.I.get<Repository>().getBalance(PylonsApp.currentWallet.publicAddress);

    if (response.isLeft()) {
      showErrorMessageToUser(response);
      return;
    }

    assets = response.getOrElse(() => []);
    setState(() {});
  }

  Future copyClipboard() async {
    var msg = PylonsApp.currentWallet.publicAddress;
    Clipboard.setData(ClipboardData(text: msg)).then((_) {
      SnackbarToast.show("Your wallet address copied to clipboard");
    });
  }

  Future getFaucet(BuildContext context, String denom) async {
    final diag = Loading()..showLoading();
    final walletsStore = GetIt.I.get<WalletsStore>();
    final faucetEither = await walletsStore.getFaucetCoin(denom: denom);

    if (faucetEither.isLeft()) {
      SnackbarToast.show(faucetEither.swap().toOption().toNullable()!.message);
    }

    SnackbarToast.show("faucet ${faucetEither.getOrElse(() => 0).toString().UvalToVal()} ${denom.UdenomToDenom()} added.");

    Timer(const Duration(milliseconds: 400), () {
      _buildAssetsList();

      diag.dismiss();
    });
  }

  void showErrorMessageToUser(Dz.Either<Failure, List<Balance>> response) {
    if (!mounted) {
      return;
    }
    context.show(message: response.swap().toOption().toNullable()!.message);
  }
}

class _BalanceWidget extends StatefulWidget {
  final Balance balance;
  final Function onCallFaucet;
  final String backgroundAsset;

  const _BalanceWidget({Key? key, required this.balance, required this.onCallFaucet, required this.backgroundAsset}) : super(key: key);

  @override
  State<_BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<_BalanceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    final coinMeta = Constants.kCoinDenom.keys.contains(widget.balance.denom)
        ? Constants.kCoinDenom[widget.balance.denom]
        : {"name": widget.balance.denom, "icon": "", "denom": widget.balance.denom, "short": widget.balance.denom, "faucet": false};

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderOnForeground: false,
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          width: screenSize.width(),
          height: screenSize.width(percent: 0.35),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(widget.backgroundAsset), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                if (coinMeta["icon"] != "") ...[
                  if (coinMeta["icon"].toString().contains(".svg"))
                    SvgPicture.asset(coinMeta["icon"].toString(), width: 30, height: 30)
                  else
                    Image.asset(coinMeta["icon"].toString(), width: 30, height: 30),
                  const SizedBox(width: 10),
                ],
                Text(
                  "${coinMeta["name"]}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                if (coinMeta["faucet"] as bool)
                  ElevatedButton(
                    onPressed: () {
                      widget.onCallFaucet();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFFFFFF),
                      maximumSize: const Size(100, 20),
                      minimumSize: const Size(100, 20),
                    ),
                    child: Text("faucet", style: Theme.of(context).textTheme.headline5),
                  )
              ]),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${"${widget.balance.amount.toHumanReadable()}".trimZero()} ${coinMeta["short"]}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
