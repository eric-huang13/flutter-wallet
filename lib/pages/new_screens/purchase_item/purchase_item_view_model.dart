import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/entities/nft.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class PurchaseItemViewModel extends ChangeNotifier {
  NFT nft = NFT();

  WalletsStore walletsStore;

  ValueNotifier<bool> shouldShowBuyNow = ValueNotifier(false);

  PurchaseItemViewModel(this.walletsStore);

  void setNFT(NFT nft) {
    this.nft = nft;
    final walletsList = walletsStore.getWallets().value;
    final isCurrentUserNotOwner = walletsList.where((element) => element.publicAddress == nft.ownerAddress).isEmpty;

    final isMaxNFtNotMinted = nft.quantity - nft.amountMinted > 0;

    switch (nft.type) {
      case NftType.TYPE_RECIPE:
        shouldShowBuyNow.value = isMaxNFtNotMinted && isCurrentUserNotOwner;
        break;
      case NftType.TYPE_ITEM:
      case NftType.TYPE_TRADE:
        shouldShowBuyNow.value = isCurrentUserNotOwner;
        break;
    }

    notifyListeners();
  }

  Future<void> paymentForRecipe() async {
    const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbookID": "",
        "recipeID": "",
        "coinInputsIndex": 0
        }
        ''';

    final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
    jsonMap["cookbookID"] = nft.cookbookID;
    jsonMap["recipeID"] = nft.recipeID;

    final showLoader = Loading()..showLoading();

    final response = await walletsStore.executeRecipe(jsonMap);



    showLoader.dismiss();

    SnackbarToast.show(response.success ? "purchase_nft_success".tr() : response.error);
    showLoader.dismiss();
  }

  Future<void> paymentForTrade() async {
    final showLoader = Loading()..showLoading();
    const json = '''
        {
          "ID": 0
        }
        ''';
    final jsonMap = jsonDecode(json) as Map;
    jsonMap["ID"] = nft.tradeID;
    final response = await walletsStore.fulfillTrade(jsonMap);

    showLoader.dismiss();

    SnackbarToast.show(response.success ? "purchase_nft_success".tr() : response.error);

    showLoader.dismiss();
  }


}
