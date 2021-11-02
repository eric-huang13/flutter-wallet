import 'package:fixnum/fixnum.dart';
import 'package:mobx/src/core.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.authz.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:transaction_signing_gateway/alan/alan_private_wallet_credentials.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:pylons_wallet/modules/cosmos.authz.v1beta1/module/export.dart';

import 'mock_constants.dart';

class MockWalletStore implements WalletsStore {
  @override
  Future<SDKIPCResponse> broadcastWalletCreationMessageOnBlockchain(
      AlanPrivateWalletCredentials creds,
      String creatorAddress,
      String userName) {
    // TODO: implement broadcastWalletCreationMessageOnBlockchain
    throw UnimplementedError();
  }

  @override
  Observable<bool> getAreWalletsLoading() {
    // TODO: implement getAreWalletsLoading
    throw UnimplementedError();
  }

  @override
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure() {
    // TODO: implement getLoadWalletsFailure
    throw UnimplementedError();
  }

  @override
  Observable<List<WalletPublicInfo>> getWallets() {
    // TODO: implement getWallets
    throw UnimplementedError();
  }

  @override
  Future<WalletPublicInfo> importAlanWallet(String mnemonic, String userName) {
    // TODO: implement importAlanWallet
    throw UnimplementedError();
  }

  @override
  Future<void> loadWallets() {
    // TODO: implement loadWallets
    throw UnimplementedError();
  }

  @override
  Future<void> sendCosmosMoney(
      WalletPublicInfo info, Balance balance, String toAddress) {
    // TODO: implement sendCosmosMoney
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> createRecipe(Map json) {
    // TODO: implement createRecipe
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> createTrade(Map json) {
    // TODO: implement createTrade
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> executeRecipe(Map json) {
    // TODO: implement executeRecipe
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> fulfillTrade(Map json) {
    // TODO: implement fulfillTrade
    throw UnimplementedError();
  }

  @override
  Future<Cookbook> getCookbookById(String cookbookID) {
    // TODO: implement getCookbookById
    throw UnimplementedError();
  }

  @override
  Future<List<Cookbook>> getCookbooksByCreator(String creator) {
    // TODO: implement getCookbooksByCreator
    throw UnimplementedError();
  }

  @override
  Future<Item> getItem(String cookbookID, String itemID) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  Future<List<Item>> getItemsByOwner(String owner) {
    // TODO: implement getItemsByOwner
    throw UnimplementedError();
  }

  @override
  Future<Recipe> getRecipe(String cookbookID, String recipeID) {
    // TODO: implement getRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID) {
    // TODO: implement getRecipesByCookbookID
    throw UnimplementedError();
  }

  @override
  Future<Trade?> getTradeByID(Int64 ID) {
    // TODO: implement getTradeByID
    throw UnimplementedError();
  }

  @override
  Future<TxResponse> getTxs(String txHash) {
    // TODO: implement getTxs
    throw UnimplementedError();
  }

  @override
  Future<String> getAccountAddressByName(String username) {
    // TODO: implement getAccountAddressByName
    throw UnimplementedError();
  }

  @override
  Future<String> getAccountNameByAddress(String address) {
    // TODO: implement getAccountNameByAddress
    throw UnimplementedError();
  }

  @override
  Future<int> getFaucetCoin({String? denom}) {
    // TODO: implement getFaucetCoin
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> getRecipes() {
    // TODO: implement getRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<Execution>> getItemExecutions(String cookbookID, String itemID) {
    // TODO: implement getItemExecutions
    throw UnimplementedError();
  }

  @override
  Future<List<Execution>> getRecipeEexecutions(
      String cookbookID, String recipeID) {
    // TODO: implement getRecipeEexecutions
    throw UnimplementedError();
  }

  @override
  Future<SDKIPCResponse> createCookBook(Map json) {
    // TODO: implement createCookBook
    throw UnimplementedError();
  }

  @override
  Future<bool> isAccountExists(String username) {
    // TODO: implement isAccountExists
    throw UnimplementedError();
  }

  @override
  Future<List<Trade>> getTrades(String creator) {
    // TODO: implement getTrades
    throw UnimplementedError();
  }
}
