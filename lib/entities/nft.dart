import 'dart:core';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

enum NftType {
  TYPE_RECIPE,
  TYPE_ITEM,
  TYPE_TRADE,
}

class NFT extends Equatable {
  String url = "";
  String name = "";
  String description = "";
  String denom = "";
  String price = "";
  String creator = "";
  String owner = "";
  int amountMinted = 0;
  int quantity = 0;
  String tradePercentage = "0";
  String cookbookID = "";
  String recipeID = "";
  String itemID = "";
  String width = "";
  String height = "";
  String appType = "";
  String tradeID = "";
  String ownerAddress = "";

  NftType type = NftType.TYPE_ITEM;

  NFT(
      {this.url = "",
      this.name = "",
      this.description = "",
      this.denom = "",
      this.price = "",
      this.type = NftType.TYPE_ITEM,
      this.creator = "",
      this.itemID = "",
      this.cookbookID = "",
      this.recipeID = "",
      this.owner = "",
      this.width = "",
      this.height = "",
      this.tradePercentage = "0",
      this.amountMinted = 0,
      this.quantity = 0,
      this.appType = "",
      this.tradeID = ""});





  Future<String> getCreator() async {
    if (creator == "") {
      final walletsStore = GetIt.I.get<WalletsStore>();
      final cookbook = await walletsStore.getCookbookById(cookbookID);
      creator = cookbook?.creator ?? "";
    }
    return creator;
  }






   Future<String> getOwnerAddress() async {
     if(ownerAddress == ""){
       final walletsStore = GetIt.I.get<WalletsStore>();
       final cookbook = await walletsStore.getCookbookById(cookbookID);
       ownerAddress = cookbook?.creator ?? "";
     }
     return ownerAddress;
   }




  static Future<NFT> fromItem(Item item) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final owner = await walletsStore.getAccountNameByAddress(item.owner);

    return NFT(
      name: item.strings
          .firstWhere((strKeyValue) => strKeyValue.key == "Name")
          .value,
      url: item.strings
          .firstWhere((strKeyValue) => strKeyValue.key == "NFT_URL")
          .value,
      description: item.strings
          .firstWhere((strKeyValue) => strKeyValue.key == "Description")
          .value,
      creator: item.strings
          .firstWhere((strKeyValue) => strKeyValue.key == "Creator",
              orElse: () => StringKeyValue(key: "Creator", value: ""))
          .value,
      appType: item.strings
          .firstWhere((strKeyValue) => strKeyValue.key == "App_Type",
              orElse: () => StringKeyValue(key: "App_Type", value: ""))
          .value,
      width: item.longs
          .firstWhere((longKeyValue) => longKeyValue.key == "Width",
              orElse: () => LongKeyValue(key: "Width", value: Int64()))
          .value
          .toString(),
      height: item.longs
          .firstWhere((longKeyValue) => longKeyValue.key == "Height",
              orElse: () => LongKeyValue(key: "Height", value: Int64()))
          .value
          .toString(),
      itemID: item.iD,
      cookbookID: item.cookbookID,
      owner: owner,
    );
  }

  static Future<NFT> fromTrade(Trade trade) async {
    final walletsStore = GetIt.I.get<WalletsStore>();



    //retrieve Item
    final cookbookID = trade.itemOutputs.first.cookbookID;
    final itemID = trade.itemOutputs.first.itemID;
    final item =
        await walletsStore.getItem(cookbookID, itemID) ?? Item.create();
    final owner = await walletsStore.getAccountNameByAddress(trade.creator);

    return NFT(
        type: NftType.TYPE_TRADE,
        name: item.strings
            .firstWhere((strKeyValue) => strKeyValue.key == "Name")
            .value,
        url: item.strings
            .firstWhere((strKeyValue) => strKeyValue.key == "NFT_URL")
            .value,
        description: item.strings
            .firstWhere((strKeyValue) => strKeyValue.key == "Description")
            .value,
        creator: item.strings
            .firstWhere((strKeyValue) => strKeyValue.key == "Creator",
                orElse: () => StringKeyValue(key: "Creator", value: ""))
            .value,
        appType: item.strings
            .firstWhere((strKeyValue) => strKeyValue.key == "App_Type",
                orElse: () => StringKeyValue(key: "App_Type", value: ""))
            .value,
        width: item.longs
            .firstWhere((longKeyValue) => longKeyValue.key == "Width",
                orElse: () => LongKeyValue(key: "Width", value: Int64()))
            .value
            .toString(),
        height: item.longs
            .firstWhere((longKeyValue) => longKeyValue.key == "Height",
                orElse: () => LongKeyValue(key: "Height", value: Int64()))
            .value
            .toString(),
        price: trade.coinInputs.first.coins.first.amount.toString(),
        denom: trade.coinInputs.first.coins.first.denom.toString(),
        itemID: item.iD,
        cookbookID: item.cookbookID,
        owner: owner,
        tradeID: trade.iD.toString());
  }

   static NFT fromRecipe(Recipe recipe) {

     return NFT(
       type: NftType.TYPE_RECIPE,
       recipeID: recipe.iD,
       cookbookID: recipe.cookbookID,
       name: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == "Name", orElse: ()=>StringParam()).value ?? "",
       url: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == "NFT_URL", orElse: ()=>StringParam()).value ?? "",
       description: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == "Description", orElse: ()=>StringParam()).value ?? "",
       appType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == "App_Type", orElse: ()=>StringParam()).value ?? "",
       creator: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == "Creator", orElse: ()=>StringParam()).value ?? "",
       width: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == "Width", orElse: ()=>LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
       height: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == "Height", orElse: ()=>LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
       amountMinted:int.parse(recipe.entries.itemOutputs.firstOrNull?.amountMinted.toString() ?? "0") ,
       quantity: recipe.entries.itemOutputs.firstOrNull?.quantity.toInt() ?? 0,
       tradePercentage: recipe.entries.itemOutputs.firstOrNull?.tradePercentage.toString().fromBigInt().toString() ?? "0",
       price: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.amount.toString() ?? "0",
       denom: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom.toString() ?? "",
     );
   }

  static Future<NFT> fromItemID(String cookbookID, String itemID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final item = await walletsStore.getItem(cookbookID, itemID);
    return await NFT.fromItem(item!);
  }

  static Future<NFT> fromTradeByID(Int64 tradeID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final trade = await walletsStore.getTradeByID(tradeID);
    return await NFT.fromTrade(trade!);
  }

  @override
  List<Object?> get props => [
        url,
        name,
        description,
        denom,
        price,
        type,
        creator,
        itemID,
        owner,
      ];
}

extension NFTValue on NFT {
  String getPriceFromRecipe(Recipe recipe) {
    if(recipe.coinInputs.isEmpty) {
      return "0";
    }
    if(recipe.coinInputs.first.coins.isEmpty) {
      return "0";
    }
    return recipe.coinInputs.first.coins.first.amount.toString();
  }
}

extension ValueConvertor on String {
  double fromBigInt() {
    if(this == "") {
      return 0;
    }
    return BigInt.parse(this).toDouble() / 1000000000000000000;
  }
}
