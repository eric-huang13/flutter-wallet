import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/image_widgets.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/model/recipe_json.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class AssetDetailViewScreen extends StatefulWidget {
  const AssetDetailViewScreen({Key? key,}) : super(key: key);

  @override
  State<AssetDetailViewScreen> createState() => _AssetDetailViewScreenState();
}

class _AssetDetailViewScreenState extends State<AssetDetailViewScreen> {
  bool _showPay = true;

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
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.black,)),
        ],
      ),
      body: Stack(
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
                      child: _ImageWidget(imageUrl: kImage2),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showPay ? _PayByCardWidget() : const SizedBox(),
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
                      Text("Mona Lisa", style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600,
                      ),),
                      const VerticalSpace(4),
                      RichText(
                        text: TextSpan(text: "${"created_by".tr()} ",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                        ),
                        children: const [
                          TextSpan(text: "Flowtys Studio", style: TextStyle(color: kBlue))
                        ]),
                      ),
                      const VerticalSpace(20),
                      Row(
                        children: [
                          UserImageWidget(imageUrl: kImage2, radius: 10,),
                          const HorizontalSpace(6),
                          RichText(
                            text: TextSpan(text: "${"owned_by".tr()} ",
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontSize: 14
                                ),
                                children: const [
                                  TextSpan(text: "you", style: TextStyle(color: kBlue))
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
                                child: Text("description".tr()),
                              ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("nft_details".tr()),
                                ),],
                            ),
                            body: TabBarView(
                              children: [Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Lorem ipsum"),
                                  Text("Current Price: 10.87 Pylon"),
                                  Text("Size: 1092x1082"),
                                ],
                              ), Text("Details")],
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
    );
  }

}

class _ImageWidget extends StatelessWidget {
  final String imageUrl;
  _ImageWidget({
    Key? key,
    required this.imageUrl
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
        child: CachedNetworkImage(imageUrl: imageUrl,
        width: screenSize.width(),
          errorWidget: (a, b, c) => Center(child: Text("unable_to_fetch_nft_item".tr(), style: Theme.of(context).textTheme.bodyText1,)),
          height: screenSize.height(percent: 0.30),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class _PayByCardWidget extends StatelessWidget {
  const _PayByCardWidget({
    Key? key}) : super(key: key);


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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    height: screenSize.height(percent: 0.35),
                    // width: screenSize.width(),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
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
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(0.5),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Create Trade", style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w600,
                ),),

                TextFormField(
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.white, fontSize: 18,
                  ),
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      enabledBorder:const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        //  when the TextFormField in focused
                      ),
                      focusedBorder:const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        //  when the TextFormField in focused
                      ),
                      suffix: DropdownButton<String>(
                        value: "USD",
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
                        elevation: 16,
                        underline: const SizedBox(),
                        focusColor: const Color(0xFF1212C4),
                        dropdownColor: Color(0xFF1212C4).withOpacity(0.4),
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        onChanged: (String? data) {

                        },
                        items: ["USD", "Pylon"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, -10),
                      filled: true,
                      labelText: "Price",
                      labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.white,
                      ),
                      hintText: "Expecting Price",
                      hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Color(0xFFC4C4C4), fontSize: 16
                      ),),
                ),



                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.35),
                    side: BorderSide(color: Color(0xFFFFFFFF).withOpacity(0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),

                  ),
                  icon: Image.asset('assets/icons/trade.png', width: 20,),
                  label: Text("List NFT", style: Theme.of(context).textTheme.button!.copyWith(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600
                  ),), onPressed: (){},),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
