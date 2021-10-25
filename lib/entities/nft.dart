import 'dart:core';
import 'package:alan/proto/cosmos/base/v1beta1/coin.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';


class NFT extends Equatable {

  late String url;
  late String name;
  late String description;
  late String denom;
  late String price;
  late String creator;
  late String owner;
  late int amountMinted;
  late String tradePercentage;

  late String cookbookID;
  late String recipeID;

  NFT({
    url,
    name,
    description,
    denom,
    price,
  });

  factory NFT._fromRecipe(Recipe recipe) {
    final denom = recipe.coinInputs[0].coins[0].denom;
    final price = recipe.coinInputs[0].coins[0].amount;

    recipe.entries.itemOutputs[0].longs.forEach((_long) {

    });

    recipe.entries.itemOutputs[0].strings.forEach((_string) {


    });

    recipe.entries.itemOutputs[0].doubles.forEach((_double) {

    });

    return NFT();
  }

  factory NFT._fromItem(Item item) {

    return NFT();
  }


  static Future<NFT> fromRecipe(String cookbookID, String recipeID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final recipe = await walletsStore.getRecipe(cookbookID, recipeID);


    return NFT();
  }

  static Future<NFT> fromItem(String cookbookID, String itemiD) async {
    return NFT();
  }



  @override
  List<Object?> get props => [
    url,
    name,
    description,

  ];
}
