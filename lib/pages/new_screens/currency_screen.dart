import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/pages/new_screens/stripe_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stripe/stripe_payout_widget.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen>
//    with AutomaticKeepAliveClientMixin<CurrencyScreen>
{

//  @override
//  void updateKeepAlive() => true;

//  @override
//  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 100), (){
      _buildAssetsList();
      //loadData(colType);
    }
    );
  }

  //var _assets = ValueNotifier(<Balance>[]);
  var assets = <Balance>[];

  Future<void> handleStripe() async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final stripeServices = GetIt.I.get<StripeServices>();
    final walletsStore = GetIt.I.get<WalletsStore>();

    await dataSource.loadData();
    var token = '';
    var accountlink = "";

    if(dataSource.StripeAccount != ""){

      //get accountlink only
      final accountlink_response = await stripeServices.GetAccountLink(StripeAccountLinkRequest(
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Account: dataSource.StripeAccount
      ));
      accountlink = accountlink_response.accountlink;
    }
    else {
      final response = await stripeServices.GenerateRegistrationToken(walletsStore.getWallets().value.last.publicAddress);
      if(response.token != ""){
        dataSource.StripeToken = response.token;
        token = response.token;
      }

      final register_response = await stripeServices.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));

      dataSource.StripeAccount = register_response.account;
      accountlink = register_response.accountlink;

    }

    dataSource.saveData();

    print(accountlink);


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StripeScreen(url: accountlink, token: dataSource.StripeToken, onBack: (){
            navigatorKey.currentState!.pop();
          } );
        });
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/stripe_logo.png', width: 24, height: 24),
            onPressed: () {
              handleStripe();
            }
          ),
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
          index:index,
          onCallFaucet: (){ getFaucet(context, assets[index].denom.text);},
          onCallStripePayout: (){ getPayout(context, assets[index].amount.value.toString()); }
      ),
    ),
      /*body: ValueListenableBuilder(
        valueListenable: _assets,
        builder: (_, List<Balance> assets, __) {
          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (_, index) => _BalanceWidget(
              balance: assets[index],
                index:index,
                onCallFaucet: (){ getFaucet(context, assets[index].denom.text);}
            ),
          );
        }
      ),*/
    );
  }

  Future<void> _buildAssetsList() async {
    assets.clear();

    //Query the balance and update it.
    final balanceObj = PylonsBalance(GetIt.I.get());
    final balances =
        await balanceObj.getBalance(PylonsApp.currentWallet.publicAddress);
    setState((){
      //_assets.value = balances;
      balances.forEach((element) {
        assets.add(element);
      });
    });
  }
  Future copyClipboard() async {
    var msg = "${PylonsApp.currentWallet.publicAddress}";
    Clipboard.setData(new ClipboardData(text: msg)).then((_){
      SnackbarToast.show("Your wallet address copied to clipboard");
    });
  }



  Future getFaucet(BuildContext context, String denom) async {
    final diag = Loading()..showLoading();
    final walletsStore = GetIt.I.get<WalletsStore>();
    final amount = await walletsStore.getFaucetCoin(denom:denom);
    SnackbarToast.show("faucet ${amount.toString().UvalToVal()} ${denom.UdenomToDenom()} added.");
    Timer(
        const Duration(milliseconds: 3000), (){
      _buildAssetsList();
      //await _buildAssetsList();
      diag.dismiss();
      //loadData(colType);
    });
  }

  Future getPayout(BuildContext context, String amount) async {
    StripePayoutWidget(context:context, amount: amount ).show();
  }
}



class _BalanceWidget extends  StatefulWidget {
  const _BalanceWidget({
    Key? key,
    required this.balance,
    required this.index,
    required this.onCallFaucet,
    required this.onCallStripePayout
  }) : super(key: key);

  final Balance balance;
  final int index;
  final Function onCallFaucet;
  final Function onCallStripePayout;

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
    final coinMeta = Constants.kCoinDenom.keys.contains(widget.balance.denom.text) ?  Constants.kCoinDenom[widget.balance.denom.text] : {
      "name": widget.balance.denom.text,
      "icon": "",
      "denom": widget.balance.denom.text,
      "short": widget.balance.denom.text
    };
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderOnForeground: false,
        elevation: 20,
        child:Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          width: screenSize.width(),
          height: screenSize.width(percent: 0.35),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Constants.kCardBGList[widget.index % Constants.kCardBGList.length]
                ),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children:[
                  if(coinMeta["icon"] != "") ...[
                      Image.asset (coinMeta["icon"].toString(), width: 15, height: 15),
                      SizedBox(width: 5),
                  ],
                  Text(
                  "${coinMeta["name"]}",
                  style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  if(widget.balance.denom.text == "ustripeusd")
                    ElevatedButton(
                      onPressed: (){
                        widget.onCallStripePayout();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFFFFFF),
                        maximumSize: Size(100, 20),
                        minimumSize: Size(100,20),

                      ),
                      child: Text("payout", style: TextStyle(color: Color(0xFF1212C4), fontSize: 15)),
                    )
                  else
                  ElevatedButton(
                    onPressed: (){
                      widget.onCallFaucet();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFFFFFF),
                      maximumSize: const Size(100, 20),
                      minimumSize: const Size(100,20),

                    ),
                    child: const Text("faucet", style: TextStyle(color: Color(0xFF1212C4), fontSize: 15)),
                  )


                ]
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${"${widget.balance.amount.toHumanReadable() }".trimZero()} ${coinMeta["short"]}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                ),
              ),
            ],
          ),
      )
    );
  }
}
