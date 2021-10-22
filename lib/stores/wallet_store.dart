
import 'package:fixnum/fixnum.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/modules/cosmos.authz.v1beta1/module/export.dart';
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
  Future<WalletPublicInfo> importAlanWallet(
    String mnemonic,
    String userName,
  );

  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered
  Future<void> broadcastWalletCreationMessageOnBlockchain(AlanPrivateWalletCredentials creds, String creatorAddress, String userName);

  /// This method creates the custom signing Gateway for the user
  /// Output : [TransactionSigningGateway] custom signing Gateway with custom logic
  TransactionSigningGateway createCustomSigningGateway();

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
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> createCookBook(Map json);

  /// This method is for create recipe
  /// MsgCreateRecipe proto
  /// request fields: { String creator, String cookbookID, String ID, String name, String description, String version, List<CoinInput> coinInputs, List<ItemInput> itemInput, List<EntriesList> entries, List<WeightedOutputs> outputs, Int64 blockInterval}
  /// Input : [Map] containing the info related to the creation of recipe
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> createRecipe(Map json);

  /// This method is for execute recipe
  /// MsgExecuteRecipe proto
  /// request fields: {String creator, String cookbookID, String recipeID, List<String> itemIDs}
  /// Input : [Map] containing the info related to the execution of recipe
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> executeRecipe(Map json);

  /// This method is for create Trade
  /// MsgCreateTrade proto
  /// request fields: {String creator, list<CoinInput> coinInputs, List<ItemInputs> itemInputs, List<Coin> coinOutputs, List<ItemRef> itemOutputs, String extraInfo}
  /// Input : [Map] containing the info related to the creation of Trade
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> createTrade(Map json);

  /// This method is for fulfillTrade
  /// MsgFulfillTrade proto
  /// request fields: {String creator, Int64 ID, List<ItemRef> items, Int64 coinInputIndex ???}
  /// Input : [Map] containing the info related to the fulfillTrade
  /// Output : [TransactionHash] hash of the transaction
  Future<TransactionHash> fulfillTrade(Map json);

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

  /// This method is for get Recipe Info
  /// Input : [cookbookID, recipeID]
  /// Output : [Recipe] return Recipe of cookbookID, recipeID, return null if not exists
  Future<Recipe?> getRecipe(String cookbookID, String recipeID);

  /// This method is for get List of Recipe of cookbookID
  /// Input : [cookbookID]
  /// Output : [List<Recipe>] return List of Recipes of cookbookID
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID);

  /// This method is for get Item info of cookbookID, itemID
  /// Input : [cookbookID, itemID]
  /// Output : [Item?] return Item info, return null if not exists
  Future<Item?> getItem(String cookbookID, String itemID);

  /// This method is for get list of Items info by owner
  /// Input : [owner] owner iD
  /// Output : [Item?] return list of Items owned by owner
  Future<List<Item>> getItemsByOwner(String owner);


  Observable<List<WalletPublicInfo>> getWallets();


  Observable<bool> getAreWalletsLoading();
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure();

}
