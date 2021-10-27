import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen>
    with AutomaticKeepAliveClientMixin<CurrencyScreen>{

  @override
  void updateKeepAlive() => true;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    _buildAssetsList();
  }

  var _assets = ValueNotifier(<Balance>[]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
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
      body: ValueListenableBuilder(
        valueListenable: _assets,
        builder: (_, List<Balance> assets, __) {
          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (_, index) => _BalanceWidget(
              balance: assets[index],
            ),
          );
        }
      ),
    );
  }

  Future<void> _buildAssetsList() async {

    //Query the balance and update it.
    final balanceObj = PylonsBalance(GetIt.I.get());
    final balances =
        await balanceObj.getBalance(PylonsApp.currentWallet.publicAddress);

    _assets.value = balances;
  }
}

class _BalanceWidget extends StatelessWidget {
  const _BalanceWidget({
    Key? key,
    required this.balance,
  }) : super(key: key);

  final Balance balance;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: screenSize.width(),
      height: screenSize.width(percent: 0.35),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/icons/purple_card.png",
            ),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${balance.denom}",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white, fontSize: 18),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${balance.amount}",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
