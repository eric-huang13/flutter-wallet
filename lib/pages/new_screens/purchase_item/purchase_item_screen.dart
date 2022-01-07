import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/image_widgets.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/pages/new_screens/purchase_item/widgets/pay_by_card.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sprintf/sprintf.dart';

import 'purchase_item_view_model.dart' show PurchaseItemViewModel;

class PurchaseItemScreen extends StatefulWidget {
  final NFT nft;
  const PurchaseItemScreen({Key? key, required this.nft}) : super(key: key);

  @override
  State<PurchaseItemScreen> createState() => _PurchaseItemScreenState();
}

class _PurchaseItemScreenState extends State<PurchaseItemScreen> {
  PurchaseItemViewModel get viewModel => sl();

  @override
  void initState() {
    super.initState();

    scheduleMicrotask((){
      viewModel.setNFT(widget.nft);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const PurchaseItemContent(),
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
        borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
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
            placeholder: (context, _) => Shimmer(
              color: PylonsAppTheme.cardBackground,
              child: Container(),
            ),
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
                    child: Image.asset('assets/icons/zoom.png', width: 16, height: 16),
                  ))),
        ]),
      ),
    );
  }
}

class PurchaseItemContent extends StatefulWidget {
  const PurchaseItemContent({Key? key}) : super(key: key);

  @override
  _PurchaseItemContentState createState() => _PurchaseItemContentState();
}

class _PurchaseItemContentState extends State<PurchaseItemContent> {
  bool _showPay = false;

  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    final viewModel = context.watch<PurchaseItemViewModel>();

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
                          child: _ImageWidget(imageUrl: viewModel.nft.url),
                        ),
                        AnimatedSwitcher(
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            final offsetAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation);
                            final offsetHideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 0.0)).animate(animation);
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
                                  child: PayByCardWidget(
                                    recipe: viewModel.nft,
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
                            viewModel.nft.name,
                            style: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const VerticalSpace(4),
                          RichText(
                            text: TextSpan(
                                text: "${"created_by".tr()} ",
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 16,
                                    ),
                                children: [TextSpan(text: viewModel.nft.creator, style: const TextStyle(color: kBlue))]),
                          ),
                          const VerticalSpace(20),
                          Row(
                            children: [
                              const UserImageWidget(
                                imageUrl: kImage2,
                                radius: 10,
                              ),
                              const HorizontalSpace(6),
                              RichText(
                                text: TextSpan(
                                    text: "${"owned_by".tr()} ",
                                    style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),
                                    children: [TextSpan(text: viewModel.nft.owner == "" ? viewModel.nft.creator : viewModel.nft.owner, style: const TextStyle(color: kBlue))]),
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
                                        child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(viewModel.nft.description),
                                          const SizedBox(height: 20),
                                          Text(sprintf("current_price".tr(), [viewModel.nft.price.UvalToVal(), viewModel.nft.denom.UdenomToDenom()])),
                                          Text(sprintf("size_x".tr(), [viewModel.nft.width, viewModel.nft.height])),
                                          if (viewModel.nft.type == NftType.TYPE_RECIPE) Text(sprintf("number_of_editions".tr(), [viewModel.nft.amountMinted, viewModel.nft.quantity])),
                                          if (viewModel.nft.type == NftType.TYPE_RECIPE) Text(sprintf("royalty".tr(), [(double.parse(viewModel.nft.tradePercentage) * 100).toStringAsFixed(1)]))
                                        ],
                                      ),
                                    )),
                                    Text("details".tr())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpace(10),
                          Row(
                            children: [
                              ValueListenableBuilder<bool>(
                                  valueListenable: viewModel.shouldShowBuyNow,
                                  builder: (context, value, child) {

                                    if(value) {
                                      return TextButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: kPeachDark.withOpacity(0.4),
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                      ),
                                      icon: Image.asset(
                                        'assets/icons/card.png',
                                        width: 30,
                                      ),
                                      label: Text(
                                        "buy_now".tr(),
                                        style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showPay = !_showPay;
                                        });
                                      },
                                    );
                                    }

                                    return const SizedBox();

                                  }),
                              const Spacer(),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: kWhite,
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                  side: BorderSide(color: kPeachDark.withOpacity(0.4)),
                                ),
                                icon: const Icon(
                                  Icons.favorite_outlined,
                                  color: kPeachDark,
                                  size: 24,
                                ),
                                label: Text(
                                  "save_for_later".tr(),
                                  style: Theme.of(context).textTheme.button!.copyWith(color: kPeachDark, fontSize: 16, fontWeight: FontWeight.w600),
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
        ));
  }

  //detect card's outside tap
  void onTapUp(BuildContext context, TapUpDetails details) {
    if (key.currentContext != null) {
      final containerBox = key.currentContext!.findRenderObject() as RenderBox;
      final isHit = containerBox.hitTest(BoxHitTestResult(), position: details.localPosition);
      if (_showPay == true && !isHit) {
        setState(() {
          _showPay = false;
        });
      }
    }
  }
}
