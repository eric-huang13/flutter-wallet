import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
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




  /// This method creates the recipe in the block chain
  /// Input : [Map] containing the info related to the creation of recipe
  /// Output : [String] response
  Future<SDKIPCResponse> createRecipe(Map json);


  /// This method creates the recipe in the block chain
  /// Input : [Map] containing the info related to the execution of recipe
  /// Output : [SDKIPCResponse] response
  Future<SDKIPCResponse> executeRecipe(Map json);



  /// This method creates the recipe in the block chain
  /// Input : [Map] containing the info related to the updation of recipe
  /// Output : [SDKIPCResponse] response
  Future<SDKIPCResponse> updateRecipe(Map<dynamic, dynamic> jsonMap);



  Observable<List<WalletPublicInfo>> getWallets();


  Observable<bool> getAreWalletsLoading();
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure();



}
