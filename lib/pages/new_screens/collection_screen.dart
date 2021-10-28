import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/pages/new_screens/asset_detail_view.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

import '../../pylons_app.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

const collectionType = [
  "ownedNFT", //item List
  "listNFT", //Trade list
];

class _CollectionScreenState extends State<CollectionScreen>{
  final walletsStore = GetIt.I.get<WalletsStore>();
  List<NFT> assets =[];

  String colType = "ownedNFT";


  @override
  void initState() {
    super.initState();
    listOwnedNFTs();
  }
  Future listOwnedNFTs() async {
    setState((){
      colType = 'ownedNFT';
    });
    loadData(colType);

  }

  Future listNFTs() async {
    setState(()=>{
      colType = "listNFT"
    });
    loadData(colType);

  }


  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "default_cookbooks".tr(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: const Color(0xffA9A6A6),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const VerticalSpace(6),
          Row(
            children: [
              _CardWidget(
                text: "art".tr(),
                icon: "art",
                selected: colType == "ownedNFT",
                onTap: () {
                  listOwnedNFTs();
                  // navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => PurchaseItemScreen(recipe: null,)));
                },
              ),
              const Spacer(),
              _CardWidget(
                text: "tickets".tr(),
                icon: "tickets",
                onTap: () {},
              ),
              const Spacer(),
              _CardWidget(
                text: "transfer".tr(),
                icon: "transfer",
                onTap: () {},
              ),
            ],
          ),
          const VerticalSpace(20),
          Text(
            "your_pylons_app".tr(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: const Color(0xffA9A6A6), fontWeight: FontWeight.w500),
          ),
          const VerticalSpace(6),
          Row(
            children: [
              _CardWidget(
                text: "Easel",
                icon: "pylons",
                onTap: () {},
              ),
              const Spacer(),
              _CardWidget(
                text: "Avatar",
                icon: "pylons",
                onTap: () {},
              ),
              const Spacer(),
              _CardWidget(
                text: "ListNFT",
                icon: "pylons",
                selected: colType == "listNFT",
                onTap: () {
                  listNFTs();
                },
              ),
            ],
          ),
          const VerticalSpace(20),
          Expanded(
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>  AssetDetailViewScreen(nftItem: assets[index])));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: CachedNetworkImage(
                          //imageUrl: _getImage(index),
                          imageUrl: assets[index].url,
                          fit: BoxFit.cover),
                    ),
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count((index == 1 || index == 6) ? 2 : 1,
                      (index == 1 || index == 6) ? 2 : 1);
                }),
          )
        ],
      ),
    );
  }

  Future loadData(String _colType) async {
    assets.clear();
    List<NFT> _assets = [];
    if(_colType == "ownedNFT"){
      walletsStore.getItemsByOwner(PylonsApp.currentWallet.publicAddress).then((items)
      {
        items.forEach((e) async {
          final nft = await NFT.fromItem(e);
          print(nft);
          setState((){
            assets.add(nft);
          });

        });

      });
    }else if(_colType == "listNFT"){

      walletsStore.getTrades(PylonsApp.currentWallet.publicAddress).then((trades){
        trades.forEach((trade) async {
            final nft = await NFT.fromTrade(trade);
            setState((){
              assets.add(nft);
            });
        });
      });

    }
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);
  final bool selected;
  final String text;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenSize.width(percent: 0.3),
            height: screenSize.width(percent: 0.3),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFFC4C4C4).withOpacity(selected ? 0.5: 0.25),
            ),
            child: Image.asset(
              "assets/icons/$icon.png",
              fit: BoxFit.contain,
              width: 10,
              height: 70,
            ),
          ),
        ),
        const VerticalSpace(6),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
