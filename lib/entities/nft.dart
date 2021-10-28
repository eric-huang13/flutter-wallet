import 'package:fixnum/fixnum.dart';
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
   String tradePercentage = "";
   String cookbookID = "";
  String recipeID = "";
  String itemID = "";
  String width = "";
  String height = "";

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
  });


  static Future<NFT> fromRecipe(String cookbookID, String recipeID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final cookbook = await walletsStore.getCookbookById(cookbookID);
    final recipe = await walletsStore.getRecipe(cookbookID, recipeID);
    return NFT(
      type: nftType.type_recipe,
      name: recipe?.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Name").value ?? "",
      url: recipe?.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "NFT_URL").value ?? "",
      description: recipe?.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Description").value ?? "",
      // why image dimension needed?
      //imageWidth = recipe?.entries.itemOutputs.first.longs.firstWhere((e) => e.key == "Width").weightRanges.first.upper.toInt();
      //imageHeight = recipe.entries.itemOutputs.first.longs.firstWhere((e) => e.key == "Height").weightRanges.first.upper.toInt();
      price: recipe?.coinInputs.first.coins.first.amount.toString() ?? "",
      denom: recipe?.coinInputs.first.coins.first.denom.toString() ?? "",
      creator: cookbook?.creator ?? "",

    );
  }

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
      width: item.longs.firstWhere((e) => e.key == "Width", orElse: ()=>LongKeyValue(key: "Width", value: Int64(0))).value.toString(),
      height: item.longs.firstWhere((e) => e.key == "Height", orElse: ()=>LongKeyValue(key: "Height", value: Int64(0))).value.toString(),
      itemID: item.iD,
      cookbookID: item.cookbookID,
      owner: owner,
    );
  }

  static Future<NFT> fromTrade(Trade trade) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    print(trade);

    //retrieve Item
    final cookbookID = trade.itemOutputs.first.cookbookID;
    final itemID = trade.itemOutputs.first.itemID;
    final item = await walletsStore.getItem(cookbookID, itemID) ?? Item.create();
    print('owner ${cookbookID} ${itemID} ${item.owner}');
    final owner = await walletsStore.getAccountNameByAddress(item.owner);
    print('owner ${cookbookID} ${itemID} ${item.owner} ${owner}');

    return NFT(
      type: nftType.type_trade,
      name: item.strings.firstWhere((e) => e.key == "Name").value,
      url: item.strings.firstWhere((e) => e.key == "NFT_URL").value,
      description: item.strings.firstWhere((e) => e.key == "Description").value,
      creator: item.strings.firstWhere((e) => e.key == "Creator", orElse:()=> StringKeyValue(key:"Creator", value: "")).value,
      width: item.longs.firstWhere((e) => e.key == "Width", orElse: ()=>LongKeyValue(key: "Width", value: Int64(0))).value.toString(),
      height: item.longs.firstWhere((e) => e.key == "Height", orElse: ()=>LongKeyValue(key: "Height", value: Int64(0))).value.toString(),
      itemID: item.iD,
      cookbookID: item.cookbookID,
      owner: owner,
    );
  }

  static Future<NFT> fromItemID(String cookbookID, String itemID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final item = await walletsStore.getItem(cookbookID, itemID);
    final cookbook = await walletsStore.getCookbookById(cookbookID);

    return NFT(
      type: nftType.type_item,
      name: item?.strings.firstWhere((e) => e.key == "Name").value ?? "",
      url: item?.strings.firstWhere((e) => e.key == "NFT_URL").value ?? "",
      description: item?.strings.firstWhere((e) => e.key == "Description").value ?? "",
      itemID: item?.iD ?? "",
      owner: item?.owner ?? "",
      creator: cookbook?.creator ?? "",
    );
  }

  static Future<NFT> fromTradeByID(Int64 tradeID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final trade = await walletsStore.getTradeByID(tradeID);
    //sell trade
    if(trade != null &&
        trade.coinInputs.isNotEmpty &&
        trade.itemOutputs.isNotEmpty
    ){
      final itemID = trade.itemOutputs.first.itemID;
      final cookbookID = trade.itemOutputs.first.cookbookID;
      final item = await walletsStore.getItem(cookbookID, itemID);
      final cookbook = await walletsStore.getCookbookById(cookbookID);

      return NFT(
        type: nftType.type_trade,
        denom: trade.coinInputs.first.coins.first.denom,
        price: trade.coinInputs.first.coins.first.amount,
        name: item?.strings.firstWhere((e) => e.key == "Name").value ?? "",
        url: item?.strings.firstWhere((e) => e.key == "NFT_URL").value ?? "",
        description: item?.strings.firstWhere((e) => e.key == "Description").value ?? "",
        itemID: item?.iD ?? "",
        owner: item?.owner ?? "",
        creator: cookbook?.creator ?? ""
      );
    }
    return NFT();
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
