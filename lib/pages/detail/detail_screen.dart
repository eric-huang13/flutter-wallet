import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/forms/create_trade_form.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

enum DetailPageType { typeRecipe, typeItem }

class DetailScreenWidget extends StatefulWidget {
  final String recipeID;
  final String cookbookID;
  final String itemID;
  final int nft_amount;
  final DetailPageType pageType;

  //final bool isOwner;
  const DetailScreenWidget({
    Key? key,
    this.recipeID = "",
    this.cookbookID = "",
    this.itemID = "",
    this.nft_amount = 1,
    this.pageType = DetailPageType.typeItem,
  }) : super(key: key);

  @override
  State<DetailScreenWidget> createState() => _DetailScreenWidgetState();
}

class _DetailScreenWidgetState extends State<DetailScreenWidget>
    with SingleTickerProviderStateMixin {
  final walletsStore = GetIt.I.get<WalletsStore>();

  bool isOwner = false;
  bool isInResellMode = false;
  bool isInTrade = false;
  int tabIndex = 0;
  String itemName = "";
  String itemDescription = "";
  String itemUrl = "";
  String itemPrice = "";
  String itemCurrency = "";
  int imageWidth = 0;
  int imageHeight = 0;

  late TabController _tabController;

  final List<Widget> myTabs = <Widget>[
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('work'.tr()),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('info'.tr()),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('history'.tr()),
    ),
  ];

  static late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_tabSelect);
    loadData().then((value) => _pages = <Widget>[
          DetailTabWorkWidget(
              cookbookID: widget.cookbookID,
              recipeID: widget.recipeID,
              itemName: itemName,
              itemDescription: itemDescription),
          const DetailTabInfoWidget(),
          const DetailTabHistoryWidget(),
        ]);
  }

  Future loadData() async {
    switch (widget.pageType) {
      case DetailPageType.typeRecipe:
        {
          final recipeResponse =
              await walletsStore.getRecipe(widget.cookbookID, widget.recipeID);
          if (recipeResponse.isRight()) {
            final recipe = recipeResponse.toOption().toNullable()!;
            setState(() {
              itemName = recipe.entries.itemOutputs.first.strings
                  .firstWhere((stKeyVal) => stKeyVal.key == "Name")
                  .value;

              itemUrl = recipe.entries.itemOutputs.first.strings
                  .firstWhere((stKeyVal) => stKeyVal.key == "NFT_URL")
                  .value;

              itemDescription = recipe.entries.itemOutputs.first.strings
                  .firstWhere((stKeyVal) => stKeyVal.key == "Description")
                  .value;

              imageWidth = recipe.entries.itemOutputs.first.longs
                  .firstWhere((longKeyVal) => longKeyVal.key == "Width")
                  .weightRanges
                  .first
                  .upper
                  .toInt();

              imageHeight = recipe.entries.itemOutputs.first.longs
                  .firstWhere((longKeyVal) => longKeyVal.key == "Height")
                  .weightRanges
                  .first
                  .upper
                  .toInt();

              itemPrice = recipe.coinInputs.first.coins.first.amount.toString();

              itemCurrency =
                  recipe.coinInputs.first.coins.first.denom.toString();
            });
          }

          break;
        }
      case DetailPageType.typeItem:
        {
          await walletsStore.getItem(widget.cookbookID, widget.itemID);
          break;
        }
    }

    setState(() {});
  }

  void _tabSelect() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  void onPressPurchaseModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: const [CardInfoForm()]));
  }

  void onPressPurchase(BuildContext context) {
    if (!isOwner) {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentInfoScreenWidget()));
      switch (widget.pageType) {
        case DetailPageType.typeRecipe:
          {
            walletsStore.executeRecipe({
              "cookbookID": widget.cookbookID,
              "recipeID": widget.recipeID,
              "coinInputsIndex": 0
            }).then((value) => {});
            break;
          }
        case DetailPageType.typeItem:
          // TODO: Handle this case.
          break;
      }
    } else {
      if (!isInResellMode) {
        //setState(() {
        //  isInResellMode = !isInResellMode;
        //});
        onResellNft();
      }
    }
  }

  void onDeleteTrade() {
    /*
    showDialog(
        context: context,
        builder: AlertDialog(
          title: const Text(''),
          content: const Text('Do you really want to delete trade?'),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed:(){},
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: (){},
              child: const Text('Delete Trade')
            )
          ]
        )
    );
     */
  }

  void onResellNft() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: const [CreateTradeForm()]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                child: CachedNetworkImage(
                  imageUrl: itemUrl == "" ? kImage : itemUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => NFTViewWidget(
                            imageUrl: itemUrl,
                          )));
                }),
            const VerticalSpace(10),
            //tab bar
            Container(
                alignment: Alignment.centerLeft,
                height: 30,
                color: Colors.white,
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: kPeachDark,
                  tabs: myTabs,
                  labelPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                )),
            Container(child: _pages.isNotEmpty ? _pages[tabIndex] : null)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          alignment: Alignment.center,
          height: 72,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(children: [
                Text("$itemPrice $itemCurrency",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: kTextColor,
                        fontFamily: 'Inter')),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      onPressPurchase(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kBlue,
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0)),
                    child: Text(!isOwner ? 'purchase'.tr() : 'resell_nft'.tr(),
                        style: const TextStyle(color: Colors.white)))
              ]),
            ],
          )),
    );
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
