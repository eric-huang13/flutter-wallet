import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sprintf/sprintf.dart';
import 'package:pylons_wallet/components/image_widgets.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart' as Constants;
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:pylons_wallet/utils/formatter.dart';

import '../../pylons_app.dart';

class AssetDetailViewScreen extends StatefulWidget {
  final NFT nftItem;
  const AssetDetailViewScreen({
    Key? key,
    required this.nftItem,
  }) : super(key: key);

  @override
  State<AssetDetailViewScreen> createState() => _AssetDetailViewScreenState();
}

typedef PayCallbackFunc = void Function(String, String);

class _AssetDetailViewScreenState extends State<AssetDetailViewScreen> {
  bool _showPay = false;
  String owner = "";

  final GlobalKey key = new GlobalKey();

  //detect card's outside tap
  void onTapUp(BuildContext context, TapUpDetails details) {
    if (key.currentContext != null) {
      final RenderBox containerBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final isHit = containerBox.hitTest(BoxHitTestResult(),
          position: details.localPosition);
      if (_showPay == true && !isHit) {
        setState(() {
          _showPay = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //_showPay = (widget.nftItem.type == nftType.type_item) ? true: false;
      owner = widget.nftItem.owner == PylonsApp.currentWallet.name
          ? "you"
          : widget.nftItem.owner;
    });
  }

  Future copyClipboard(String msg) async {
    var msg = "";
    if (widget.nftItem.type == NftType.TYPE_TRADE) {
      msg = sprintf(Constants.kUnilinkPurchaseTrade,
          [Constants.kUnilinkUrl, widget.nftItem.tradeID]);
    } else if (widget.nftItem.type == NftType.TYPE_ITEM) {
      msg = sprintf(Constants.kUnilinkPurchaseNftView, [
        Constants.kUnilinkUrl,
        widget.nftItem.cookbookID,
        widget.nftItem.itemID
      ]);
    }
    Clipboard.setData(new ClipboardData(text: msg)).then((_) {
      SnackbarToast.show("nft_address_copied".tr());
    });
  }

  Future onCreateTrade(String amount, String denom) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final loading = Loading()..showLoading();
    final json = {
      "coinInputs": [
        {
          "coins": [
            {"denom": denom, "amount": amount}
          ]
        }
      ],
      "itemOutputs": [
        {
          "cookbookID": widget.nftItem.cookbookID,
          "itemID": widget.nftItem.itemID
        }
      ]
    };
    final response = await walletsStore.createTrade(json);

    loading.dismiss();
    setState(() {
      _showPay = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.success != false
            ? "trade_create_success".tr()
            : sprintf("trade_create_fail".tr(), response.error))));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: Colors.black,
              ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                )),
          ],
        ),
        body: GestureDetector(
          onTapUp: (TapUpDetails details) => onTapUp(context, details),
          child: Stack(
            children: [
              const Positioned(
                bottom: 0,
                right: 0,
                child: backgroundImage,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenSize.height(percent: 0.35),
                    width: screenSize.width(),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Stack(children: [
                            _ImageWidget(imageUrl: widget.nftItem.url),
                            Positioned.fill(
                                right: 0,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: !_showPay
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _showPay = true;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                      'assets/icons/ico_dollar.png',
                                                      width: 16,
                                                      height: 16),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(3),
                                                    primary: Color(
                                                        0x801212C4), // <-- Button color
                                                    onPrimary: Color(
                                                        0x801212C4), // <-- Splash color
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Image.asset(
                                                      'assets/icons/ico_share.png',
                                                      width: 16,
                                                      height: 16),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(3),
                                                    primary: Color(
                                                        0x801212C4), // <-- Button color
                                                    onPrimary: Color(
                                                        0x801212C4), // <-- Splash color
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    copyClipboard(
                                                        widget.nftItem.itemID);
                                                  },
                                                  child: Image.asset(
                                                      'assets/icons/ico_clip.png',
                                                      width: 16,
                                                      height: 16),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(3),
                                                    primary: Color(
                                                        0x801212C4), // <-- Button color
                                                    onPrimary: Color(
                                                        0x801212C4), // <-- Splash color
                                                  )),
                                            ])
                                      : SizedBox(),
                                )),
                          ]),
                        ),
                        AnimatedSwitcher(
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            final offsetAnimation = Tween<Offset>(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset(0.0, 0.0))
                                .animate(animation);
                            final offsetHideAnimation = Tween<Offset>(
                                    begin: Offset(0.0, 0.0),
                                    end: Offset(1.0, 0.0))
                                .animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                            //return ScaleTransition(child: child, scale: animation);
                          },
                          duration: const Duration(milliseconds: 300),
                          child: _showPay
                              ? Container(
                                  key: key,
                                  width: screenSize.width(),
                                  height: screenSize.height() * .35,
                                  child: _PayByCardWidget(
                                    onPayCallback: (amount, denom) {
                                      onCreateTrade(amount, denom);
                                    },
                                  ))
                              : const SizedBox(),
                        )
                      ],
                    ),
                  ),
                  const VerticalSpace(10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nftItem.name,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const VerticalSpace(4),
                          RichText(
                            text: TextSpan(
                                text: "${"created_by".tr()} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                                children: [
                                  TextSpan(
                                      text: widget.nftItem.creator,
                                      style: TextStyle(color: Constants.kBlue))
                                ]),
                          ),
                          const VerticalSpace(20),
                          Row(
                            children: [
                              UserImageWidget(
                                imageUrl: Constants.kImage2,
                                radius: 10,
                              ),
                              const HorizontalSpace(6),
                              RichText(
                                text: TextSpan(
                                    text: "${"owned_by".tr()} ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: owner,
                                          style: TextStyle(color: Constants.kBlue))
                                    ]),
                              ),
                            ],
                          ),
                          const VerticalSpace(20),
                          Expanded(
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: TabBar(
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey[700],
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor: Constants.kBlue.withOpacity(0.41),
                                  labelStyle: const TextStyle(fontSize: 16),
                                  tabs: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("description".tr()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("nft_details".tr()),
                                    ),
                                  ],
                                ),
                                body: TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.nftItem.description),
                                              SizedBox(height: 20),
                                              Text(
                                                sprintf("current_price".tr(),[widget.nftItem.price.toString().UvalToVal(), widget.nftItem.denom.UdenomToDenom()] )
                                              ),
                                              Text(
                                                sprintf("size_x".tr(), [widget.nftItem.width, widget.nftItem.height])
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              if (widget.nftItem.type ==
                                                  NftType.TYPE_TRADE)
                                                Text("item_on_trade".tr()),
                                            ],
                                          )),
                                    ),
                                    Text("details".tr())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpace(10),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class _ImageWidget extends StatelessWidget {
  final String imageUrl;
  _ImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: Stack(children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: screenSize.width(),
            errorWidget: (a, b, c) => Center(
                child: Text(
              "unable_to_fetch_nft_item".tr(),
              style: Theme.of(context).textTheme.bodyText1,
            )),
            height: screenSize.height(percent: 0.30),
            fit: BoxFit.fill,
          ),
          Positioned.fill(
              right: 10,
              bottom: 10,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NFTViewWidget(
                                imageUrl: imageUrl,
                              )));
                    },
                    child: Image.asset('assets/icons/zoom.png',
                        width: 16, height: 16),
                  ))),
        ]),
      ),
    );
  }
}

class _PayByCardWidget extends StatefulWidget {
  const _PayByCardWidget({Key? key, required this.onPayCallback})
      : super(key: key);

  final PayCallbackFunc onPayCallback;

  @override
  State<StatefulWidget> createState() => _PayByCardWidgetState();
}

class _PayByCardWidgetState extends State<_PayByCardWidget> {
  static const paymentDenoms = [Constants.kUSDCoinName, Constants.kPylonCoinName];
  String selectedDenom = "USD";
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SizedBox(
            width: screenSize.width(),
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    height: screenSize.height(percent: 0.35),
                    // width: screenSize.width(),
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: screenSize.height(percent: 0.35),
          width: screenSize.width(),
          margin: const EdgeInsets.only(left: 50),
          decoration: BoxDecoration(
            color: Constants.kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Constants.kBlue.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Create Trade",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextFormField(
                  controller: amountController,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      //  when the TextFormField in focused
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      //  when the TextFormField in focused
                    ),
                    suffix: DropdownButton<String>(
                      value: selectedDenom,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: Colors.white),
                      elevation: 16,
                      underline: const SizedBox(),
                      focusColor: Constants.kBlue,
                      dropdownColor: Constants.kBlue.withOpacity(0.4),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      onChanged: (String? data) {
                        setState(() {
                          selectedDenom = data ?? "";
                        });
                      },
                      items: paymentDenoms
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, -10),
                    filled: true,
                    labelText: "price".tr(),
                    labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                        ),
                    hintText: "expecting_price".tr(),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Constants.kUnselectedIcon, fontSize: 16),
                  ),
                ),
                TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Constants.kWhite.withOpacity(0.35),
                      side: BorderSide(color: Constants.kWhite.withOpacity(0.4)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                    ),
                    icon: Image.asset(
                      'assets/icons/trade.png',
                      width: 20,
                    ),
                    label: Text(
                      "list_nft".tr(),
                      style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      //check validation
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (amountController.text == "") {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text("price_is_empty".tr()),
                          ));
                        return;
                      }

                      if (selectedDenom == "currency_is_empty".tr()) {
                        return;
                      }

                      widget.onPayCallback(amountController.text.ValToUval(),
                          selectedDenom.DenomToUdenom());
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
