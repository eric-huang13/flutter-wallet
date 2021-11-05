import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/model/recipe_json.dart';
import 'package:pylons_wallet/pages/new_screens/asset_detail_view.dart';
import 'package:pylons_wallet/pages/new_screens/purchase_item_screen.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/transactions/get_recipe.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

import '../../pylons_app.dart';

class Collection {
  final String icon;
  final String title;
  final String type; // cookbook | app
  final String app_name;
  Collection({
    required this.icon,
    required this.title,
    required this.type,
    this.app_name="",
  });

}

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

List<Collection> collectionType = [
  Collection(title: "art".tr(), icon: "art" ,type: 'cookbook', ),
  Collection(title: "tickets".tr(), icon: "tickets" ,type: 'cookbook'),
  Collection(title: "transfer".tr(), icon: "transfer" ,type: 'cookbook'),
  Collection(title: "Easel", icon: "pylons", type: 'app', app_name: "easel"),
  Collection(title: "Avatar", icon: "pylons", type: 'app', app_name: "avatar"),
];

class _CollectionScreenState extends State<CollectionScreen>{
  final walletsStore = GetIt.I.get<WalletsStore>();
  List<NFT> assets =[];
  //big issue - should replace or unify into one
  List<NFT> recipes = [];

  String colType = collectionType[0].title;



  @override
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 100), (){
      loadData(colType);
    }
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                ...<Widget>[...collectionType.where((col) => col.type == 'cookbook').map((e) =>
                    _CardWidget(
                      text: e.title,
                      icon: e.icon,
                      selected: colType == e.title,
                      onTap: () {
                        setState((){
                          colType = e.title;
                        });
                        loadData(colType);
                        // navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => PurchaseItemScreen(recipe: null,)));
                      },
                    ),
                  ).toList()],
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _CardWidget(
                text: "Easel",
                selected: colType == 'Easel',
                icon: "pylons",
                onTap: () {
                  setState((){
                    colType = 'Easel';
                  });
                  loadData(colType);
                },
              ),
              const SizedBox(width: 10),
              _CardWidget(
                text: "Avatar",
                selected: colType == 'Avatar',
                icon: "pylons",
                onTap: () {
                  setState((){
                    colType = 'Avatar';
                  });
                  loadData(colType);
                },
              ),
            ],
          ),
          const VerticalSpace(20),
          if(assets.length > 0)
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
            ),
          if(recipes.length > 0)
            Expanded(
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>  PurchaseItemScreen(
                              nft: recipes[index],)));
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: CachedNetworkImage(
                          //imageUrl: _getImage(index),
                            imageUrl: recipes[index].url,
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
    final loading = Loading().showLoading();
    assets.clear();
    recipes.clear();

    if(_colType == collectionType[0].title){ //Art
      final items = await walletsStore.getItemsByOwner(PylonsApp.currentWallet.publicAddress);
      items.forEach((e) async {
        final nft = await NFT.fromItem(e);
        setState((){
          assets.add(nft);
        });
      });

      final trades = await walletsStore.getTrades(PylonsApp.currentWallet.publicAddress);
      trades.forEach((trade) async {
        final nft = await NFT.fromTrade(trade);
        setState((){
          assets.add(nft);
        });
      });
    }else if(_colType == collectionType[1].title) { //ticket
    }else if(_colType == collectionType[2].title) { //transfer
    }else if(_colType == collectionType[3].title){ // easel
      final recipeList = await walletsStore.getRecipes();
      recipeList.forEach((element) {
        final nft = NFT.fromRecipe(element);
        if(nft.appType.toLowerCase() == "easel"){
          setState((){
            recipes.add(nft);
          });
        }
      });
    }else if(_colType == collectionType[4].title){ // avatar
      final recipeList = await walletsStore.getRecipes();

      recipeList.forEach((element) {
        final nft = NFT.fromRecipe(element);
        if(nft.appType.toLowerCase() == "avatar"){
          setState((){
            recipes.add(nft);
          });
        }
      });
    }
    loading.dismiss();
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
              color: selected? Color(0x401212C4) : Color(0x80C4C4C4), // const Color(0xFFC4C4C4).withOpacity(selected ? 0.5: 0.25),
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
