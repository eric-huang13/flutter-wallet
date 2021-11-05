import 'package:fixnum/fixnum.dart';
import 'package:collection/collection.dart';
import 'dart:core';
import 'package:alan/proto/cosmos/base/v1beta1/coin.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

enum nftType {
  type_recipe,
  type_item,
  type_trade,
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

  nftType type = nftType.type_item;

  NFT({
    this.url= "",
    this.name = "",
    this.description = "",
    this.denom = "",
    this.price = "",
    this.type = nftType.type_item,
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
    this.tradeID = ""
  });



  Future<String> getCreator() async {
    if(creator == ""){
      final walletsStore = GetIt.I.get<WalletsStore>();
      final cookbook = await walletsStore.getCookbookById(cookbookID);
      creator = cookbook?.creator ?? "";
    }
    return creator;
  }


  static Future<NFT> fromItem(Item item) async  {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final owner = await walletsStore.getAccountNameByAddress(item.owner);

    return NFT(
      type: nftType.type_item,
      name: item.strings.firstWhere((e) => e.key == "Name").value,
      url: item.strings.firstWhere((e) => e.key == "NFT_URL").value,
      description: item.strings.firstWhere((e) => e.key == "Description").value,
      creator: item.strings.firstWhere((e) => e.key == "Creator", orElse:()=> StringKeyValue(key:"Creator", value: "")).value,
      appType: item.strings.firstWhere((e) => e.key == "App_Type", orElse: ()=>StringKeyValue(key: "App_Type", value: "")).value,
      width: item.longs.firstWhere((e) => e.key == "Width", orElse: ()=>LongKeyValue(key: "Width", value: Int64(0))).value.toString(),
      height: item.longs.firstWhere((e) => e.key == "Height", orElse: ()=>LongKeyValue(key: "Height", value: Int64(0))).value.toString(),
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
    final item = await walletsStore.getItem(cookbookID, itemID) ?? Item.create();
    print('owner ${cookbookID} ${itemID} ${trade.creator}');
    final owner = await walletsStore.getAccountNameByAddress(trade.creator);
    //print('owner ${cookbookID} ${itemID} ${item.owner} ${owner}');

    return NFT(
      type: nftType.type_trade,
      name: item.strings.firstWhere((e) => e.key == "Name").value,
      url: item.strings.firstWhere((e) => e.key == "NFT_URL").value,
      description: item.strings.firstWhere((e) => e.key == "Description").value,
      creator: item.strings.firstWhere((e) => e.key == "Creator", orElse:()=> StringKeyValue(key:"Creator", value: "")).value,
      appType: item.strings.firstWhere((e) => e.key == "App_Type", orElse: ()=>StringKeyValue(key: "App_Type", value: "")).value,
      width: item.longs.firstWhere((e) => e.key == "Width", orElse: ()=>LongKeyValue(key: "Width", value: Int64(0))).value.toString(),
      height: item.longs.firstWhere((e) => e.key == "Height", orElse: ()=>LongKeyValue(key: "Height", value: Int64(0))).value.toString(),
      price: trade.coinInputs.first.coins.first.amount.toString(),
      denom: trade.coinInputs.first.coins.first.denom.toString(),
      itemID: item.iD,
      cookbookID: item.cookbookID,
      owner: owner,
      tradeID: trade.iD.toString()
    );
  }


   static NFT fromRecipe(Recipe recipe) {
     return NFT(
       type: nftType.type_recipe,
       recipeID: recipe.iD,
       cookbookID: recipe.cookbookID,
       name: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((e) => e.key == "Name", orElse: ()=>StringParam()).value ?? "",
       url: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((e) => e.key == "NFT_URL", orElse: ()=>StringParam()).value ?? "",
       description: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((e) => e.key == "Description", orElse: ()=>StringParam()).value ?? "",
       appType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((e) => e.key == "App_Type", orElse: ()=>StringParam()).value ?? "",
       creator: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((e) => e.key == "Creator", orElse: ()=>StringParam()).value ?? "",
       width: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((e) => e.key == "Width", orElse: ()=>LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
       height: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((e) => e.key == "Height", orElse: ()=>LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
       amountMinted:int.parse(recipe.entries.itemOutputs.firstOrNull?.amountMinted.toString() ?? "0") ,
       quantity: int.parse(recipe.entries.itemOutputs.firstOrNull?.quantity.toString() ?? "0"),
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
    if(recipe.coinInputs.isEmpty)
      return "0";
    if(recipe.coinInputs.first.coins.isEmpty)
      return "0";
    return recipe.coinInputs.first.coins.first.amount.toString();
  }
}

extension ValueContertor on String {
  double fromBigInt() {
    if(this == "")
      return 0;
    return BigInt.parse(this).toDouble() / 1000000000000000000;
  }
}