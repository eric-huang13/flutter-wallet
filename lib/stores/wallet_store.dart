import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.authz.v1beta1/module/export.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

abstract class WalletsStore {
  /// This method loads the user stored wallets.
  Future<void> loadWallets();

  /// This method creates uer wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  Future<Either<Failure, WalletPublicInfo>> importAlanWallet(
    String mnemonic,
    String userName,
  );

  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered
  Future<SDKIPCResponse> broadcastWalletCreationMessageOnBlockchain(
      AlanPrivateWalletCredentials creds,
      String creatorAddress,
      String userName);

  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  Future<void> sendCosmosMoney(
    WalletPublicInfo info,
    Balance balance,
    String toAddress,
  );

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [String] response
  Future<SDKIPCResponse> createCookBook(Map json);

  /// This method is for create recipe
  /// MsgCreateRecipe proto
  /// request fields: { String creator, String cookbookID, String ID, String name, String description, String version, List<CoinInput> coinInputs, List<ItemInput> itemInput, List<EntriesList> entries, List<WeightedOutputs> outputs, Int64 blockInterval}
  /// Input : [Map] containing the info related to the creation of recipe
  /// Output : [TransactionHash] hash of the transaction
  Future<SDKIPCResponse> createRecipe(Map json);

  /// This method is for execute recipe
  /// MsgExecuteRecipe proto
  /// request fields: {String creator, String cookbookID, String recipeID, List<String> itemIDs}
  /// Input : [Map] containing the info related to the execution of recipe
  /// Output : [TransactionHash] hash of the transaction
  Future<SDKIPCResponse> executeRecipe(Map json);

  /// This method is for create Trade
  /// MsgCreateTrade proto
  /// request fields: {String creator, list<CoinInput> coinInputs, List<ItemInputs> itemInputs, List<Coin> coinOutputs, List<ItemRef> itemOutputs, String extraInfo}
  /// Input : [Map] containing the info related to the creation of Trade
  /// Output : [TransactionHash] hash of the transaction
  Future<SDKIPCResponse> createTrade(Map json);

  /// This method is for fulfillTrade
  /// MsgFulfillTrade proto
  /// request fields: {String creator, Int64 ID, List<ItemRef> items, Int64 coinInputIndex ???}
  /// Input : [Map] containing the info related to the fulfillTrade
  /// Output : [TransactionHash] hash of the transaction
  Future<SDKIPCResponse> fulfillTrade(Map json);

  /// This method is for get Transaction info
  /// Input : [txHash] txHash
  /// Output : [TxResponse] Tx response
  Future<TxResponse> getTxs(String txHash);

  /// This method is for get Cookbook info by cookbookID
  /// Input : [cookbookID] cookbookID
  /// Output : [Cookbook?] return Cookbook for cookbookID, return null if not exists
  Future<Cookbook?> getCookbookById(String cookbookID);

  /// This method is for get list of cookbooks
  /// Input : [creator] creator ID
  /// Output : [List<Cookbook>] return list of Cookbooks created by creatorID
  Future<List<Cookbook>> getCookbooksByCreator(String creator);

  /// This method is for get Trade Info
  /// Input : [ID] tradeID
  /// Output : [Trade?] return Trade Info of the tradeID, reutrn null if not exists
  Future<Trade?> getTradeByID(Int64 ID);

  Future<List<Trade>> getTrades(String creator);

  /// This method is for get Recipe Info
  /// Input : [cookbookID, recipeID]
  /// Output : [Recipe] return Recipe of cookbookID, recipeID,
  /// else throws error
  Future<Either<Failure, Recipe>> getRecipe(String cookbookID, String recipeID);

  /// This method is for getting all Recipes in the chain
  Future<List<Recipe>> getRecipes();

  /// This method is for get Item info of cookbookID, itemID
  /// Input : [cookbookID, itemID]
  /// Output : [Item?] return Item info, return null if not exists
  Future<Item?> getItem(String cookbookID, String itemID);

  /// This method is for get list of Items info by owner
  /// Input : [owner] owner iD
  /// Output : [Item?] return list of Items owned by owner
  Future<List<Item>> getItemsByOwner(String owner);

  /// This method is for get account name from wallet address
  /// Input : [address] target wallet address
  /// Output : [String] return account name of the wallet address
  Future<String> getAccountNameByAddress(String address);

  /// This method is for get wallet address from account name
  /// Input : [username] target account name
  /// Output : [String] return wallet address from account name
  Future<String> getAccountAddressByName(String username);

  /// This method is get list of itemID's executions
  /// Input : [cookbookID, itemID] target cookbookID itemID
  /// Output : [List<Execution>] return wallet address from account name
  Future<List<Execution>> getItemExecutions(String cookbookID, String itemID);

  Future<List<Execution>> getRecipeEexecutions(
      String cookbookID, String recipeID);

  /// This method is used for getting faucet token for the user
  /// Input : [denom]
  /// Output : [int] the amount that the user has in its wallet
  Future<int> getFaucetCoin({String denom = ""});

  /// check if account with username exists
  /// Input:[String] username
  /// Output" [bool] if exists true, else false
  Future<bool> isAccountExists(String username);

  /// This method updates the recipe in the block chain
  /// Input : [Map] containing the info related to the updation of recipe
  /// Output : [SDKIPCResponse] response
  Future<SDKIPCResponse> updateRecipe(Map<dynamic, dynamic> jsonMap);

  Observable<List<WalletPublicInfo>> getWallets();

  Observable<bool> getAreWalletsLoading();

  Observable<CredentialsStorageFailure?> getLoadWalletsFailure();

  /// This method enables the recipe int the recipe in the blockchain
  /// Input : [Map] containing the info related to the updation of recipe
  /// Output : [SDKIPCResponse] response
  Future<SDKIPCResponse> enableRecipe(Map<dynamic, dynamic> jsonMap);

  /// This method updates the cookbook in the block chain
  /// Input : [Map] containing the info related to the updation of cookbook
  /// Output : [SDKIPCResponse] response
  Future<SDKIPCResponse> updateCookBook(Map<dynamic, dynamic> jsonMap);

  /// This method returns the user profile
  /// Output : [SDKIPCResponse] contains the info related to the profile.
  Future<SDKIPCResponse> getProfile();

  Future<String> signPureMessage(String message);
  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] id of the cookbook
  /// Output : [SDKIPCResponse] returns the recipes
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID);

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] id of the cookbook
  /// Output : [SDKIPCResponse] returns the recipes
  Future<SDKIPCResponse> getAllRecipesByCookBookId(
      {required String cookbookId});

  /// This method returns the recipes based on cookbook
  /// Input : [cookbookId] id of the cookbook
  /// Output : [SDKIPCResponse] returns the cookbook
  Future<SDKIPCResponse> getCookbookByIdForSDK({required String cookbookId});



  Observable<bool> getStateUpdatedFlag();
}
