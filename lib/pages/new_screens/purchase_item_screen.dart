import 'dart:convert';
import 'dart:ui';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/image_widgets.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/model/recipe_json.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';

class PurchaseItemScreen extends StatefulWidget {
  final NFT nft;
  const PurchaseItemScreen({
    Key? key,
    required this.nft,
  }) : super(key: key);

  @override
  State<PurchaseItemScreen> createState() => _PurchaseItemScreenState();
}

class _PurchaseItemScreenState extends State<PurchaseItemScreen> {
  bool _showPay = false;

  final GlobalKey key = new GlobalKey();

  //detect card's outside tap
  void onTapUp(BuildContext context, TapUpDetails details) {
    if(key.currentContext != null) {
      final RenderBox containerBox = key.currentContext!.findRenderObject() as RenderBox;
      final isHit = containerBox.hitTest(BoxHitTestResult(), position: details.localPosition);
      if(_showPay == true && !isHit) {
        setState((){
          _showPay = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Scaffold(
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
                      child: _ImageWidget(imageUrl: widget.nft.url),
                    ),
                    AnimatedSwitcher(
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final  offsetAnimation =
                        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
                        final  offsetHideAnimation =
                        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0)).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                        //return ScaleTransition(child: child, scale: animation);
                      },
                      duration: const Duration(milliseconds: 300),
                      child: _showPay? Container(
                          key: key,
                          width: screenSize.width(),
                          height: screenSize.height() * .35,

                          child: _PayByCardWidget(
                              recipe: widget.nft,
                            )) : SizedBox(),
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
                        widget.nft.name,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const VerticalSpace(4),
                      RichText(
                        text: TextSpan(
                            text: "${"created_by".tr()} ",
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 16,
                                    ),
                            children: [
                              TextSpan(
                                  text: widget.nft.creator,
                                  style: TextStyle(color: kBlue))
                            ]),
                      ),
                      const VerticalSpace(20),
                      Row(
                        children: [
                          UserImageWidget(
                            imageUrl: kImage2,
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
                                      text: widget.nft.owner == "" ? widget.nft.creator : widget.nft.owner,
                                      style: TextStyle(color: kBlue))
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
                              indicatorColor: kBlue.withOpacity(0.41),
                              labelStyle: const TextStyle(fontSize: 16),
                              tabs: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('description'.tr()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('nft_details'.tr()),
                                ),
                              ],
                            ),
                            body: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child:
                                    Padding(
                                      padding:EdgeInsets.only(top: 20),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.nft.description),
                                          SizedBox(height: 20),
                                          Text(
                                              "Current Price: ${widget.nft.price.UvalToVal()} ${widget.nft.denom.UdenomToDenom()}"),
                                          Text(
                                              "Size: ${widget.nft.width} x ${widget.nft.height}"),
                                          if(widget.nft.type == nftType.type_recipe)
                                          Text(
                                              "Number of Editions: ${widget.nft.amountMinted} / ${widget.nft.quantity}"),
                                          if(widget.nft.type == nftType.type_recipe)
                                          Text(
                                              "Royalty: ${ (double.parse(widget.nft.tradePercentage) * 100).toStringAsFixed(1) } %"
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                Text("Details")
                              ],
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(10),
                      Row(
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFED8864).withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                            ),
                            icon: Image.asset(
                              'assets/icons/card.png',
                              width: 30,
                            ),
                            label: Text(
                              "buy_now".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              setState(() {
                                _showPay = !_showPay;
                              });
                            },
                          ),
                          const Spacer(),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFFFFFFF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              side: BorderSide(
                                  color:
                                      const Color(0xFFED8864).withOpacity(0.4)),
                            ),
                            icon: const Icon(
                              Icons.favorite_outlined,
                              color: Color(0xFFED8864),
                              size: 24,
                            ),
                            label: Text(
                              "save_for_later".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: const Color(0xFFED8864),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {},
                          ),
                        ],
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
      )
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String imageUrl;
  const _ImageWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: Stack(
            children: [CachedNetworkImage(imageUrl: imageUrl,
              width: screenSize.width(),
              errorWidget: (a, b, c) => Center(child: Text("unable_to_fetch_nft_item".tr(), style: Theme.of(context).textTheme.bodyText1,)),
              height: screenSize.height(percent: 0.30),
              fit: BoxFit.fill,
            ),
              Positioned.fill(
                  right: 10,
                  bottom: 10,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector (
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => NFTViewWidget(imageUrl: imageUrl,)));
                        },
                        child: Image.asset('assets/icons/zoom.png', width: 16, height: 16),
                      )
                  )
              ),
            ]
        ) ,
      ),
    );
  }
}

class _PayByCardWidget extends StatelessWidget {
  const _PayByCardWidget({
    Key? key,
    required this.recipe}) : super(key: key);

  final NFT recipe;

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
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
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
            color: const Color(0xffFFFFFF).withOpacity(0.4),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
          ),
          child: Container(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff1212C4).withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const UserImageWidget(
                      imageUrl: kImage2,
                      radius: 23,
                    ),
                    const HorizontalSpace(30),
                    Text(
                      recipe.denom.UdenomToDenom().toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                    ),
                    const HorizontalSpace(30),
                    Text(
                      recipe.price.UvalToVal(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.35),
                    side: BorderSide(
                        color: const Color(0xFFFFFFFF).withOpacity(0.4)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  ),
                  icon: Image.asset(
                    'assets/icons/card.png',
                    width: 30,
                  ),
                  label: Text(
                    "Pay",
                    style: Theme.of(context).textTheme.button!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => _executeRecipe(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openPaymentSheet(NFT nft) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final stripeServices = GetIt.I.get<StripeServices>();
    final response = await stripeServices.CreatePaymentIntent(
        StripeCreatePaymentIntentRequest(productID: "recipe/${nft.cookbookID}/${nft.recipeID}", coinInputIndex: 0, address: walletsStore.getWallets().value.last.publicAddress)
    );
    print('clientsecret ' + response.clientsecret);
    if(response.clientsecret != ""){
      Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: true,
        googlePay: true,
        style: ThemeMode.system,
        testEnv: true,
        merchantCountryCode: 'US',
        merchantDisplayName: 'Pylons',
        paymentIntentClientSecret: response.clientsecret
      ));
      await Stripe.instance.presentPaymentSheet();

    }
  }

  Future<void> _executeRecipe(BuildContext context) async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    if(recipe.type == nftType.type_recipe) {

      openPaymentSheet(recipe);
      return;

      const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbookID": "",
        "recipeID": "",
        "coinInputsIndex": 0
        }
        ''';

      final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
      jsonMap["cookbookID"] = recipe.cookbookID;
      jsonMap["recipeID"] = recipe.recipeID;

      _showLoading(context);

      // print(jsonMap);
      final response = await walletsStore.executeRecipe(jsonMap);


      Navigator.pop(context);

      debugPrint("${response.success ? response.data : response.error}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.success ? "Successfully purchased this NFT." : response.error}")));
    }else if(recipe.type == nftType.type_trade) {
        _showLoading(context);
        const json = '''
        {
          "ID": 0
        }
        ''';
        final jsonMap = jsonDecode(json) as Map;
        jsonMap["ID"] = recipe.tradeID;
        // print(jsonMap);
        final response = await walletsStore.fulfillTrade(jsonMap);

        Navigator.pop(context);

        debugPrint("${response.success ? response.data : response.error}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response.success ? "Successfully purchased this NFT." : response.error}")));
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        content: Wrap(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
                const HorizontalSpace(10),
                Text(
                  "Loading...",
                  style:
                      Theme.of(ctx).textTheme.subtitle2!.copyWith(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
