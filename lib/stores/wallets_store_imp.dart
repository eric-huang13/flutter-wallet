import 'package:fixnum/fixnum.dart';
import 'package:alan/alan.dart' as alan;
import 'package:http/http.dart' as http;
import 'package:cosmos_utils/extensions.dart';
import 'package:cosmos_utils/future_either.dart';
import 'package:mobx/mobx.dart';
import 'package:protobuf/protobuf.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/modules/cosmos.authz.v1beta1/module/client/cosmos/base/abci/v1beta1/abci.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/transactions/pylons_balance.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/token_sender.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';

class WalletsStoreImp implements WalletsStore {
  final TransactionSigningGateway _transactionSigningGateway;
  final BaseEnv baseEnv;

  WalletsStoreImp(this._transactionSigningGateway, this.baseEnv);

  late pylons.QueryClient _queryClient;
  final http.Client  _httpClient = http.Client();

  final Observable<bool> isSendMoneyLoading = Observable(false);
  final Observable<bool> isSendMoneyError = Observable(false);
  final Observable<bool> isBalancesLoading = Observable(false);
  final Observable<bool> isError = Observable(false);

  final Observable<List<Balance>> balancesList = Observable([]);

  final Observable<CredentialsStorageFailure?> loadWalletsFailureObservable = Observable(null);

  Observable<List<WalletPublicInfo>> wallets = Observable([]);


  final Observable<bool> areWalletsLoadingObservable = Observable(false);


  /// This method loads the user stored wallets.
  @override
  Future<void> loadWallets() async {
    areWalletsLoadingObservable.value = true;
    final walletsResultEither = await _transactionSigningGateway.getWalletsList();
    walletsResultEither.fold(
      (fail) => loadWalletsFailureObservable.value = fail,
      (newWallets) => wallets.value = newWallets,
    );
    areWalletsLoadingObservable.value = false;
    _queryClient = pylons.QueryClient(this.baseEnv.networkInfo.gRPCChannel);
  }




  /// This method creates uer wallet and broadcast it in the blockchain
  /// Input: [mnemonic] mnemonic for creating user account, [userName] is the user entered nick name
  /// Output: [WalletPublicInfo] contains the address of the wallet
  @override
  Future<WalletPublicInfo> importAlanWallet(
    String mnemonic,
    String userName,
  ) async {
    final wallet = alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);
    final creds = AlanPrivateWalletCredentials(
      publicInfo: WalletPublicInfo(
        chainId: 'pylons',
        walletId: userName,
        name: userName,
        publicAddress: wallet.bech32Address,
      ),
      mnemonic: mnemonic,
    );


    wallets.value.add(creds.publicInfo);

    await broadcastWalletCreationMessageOnBlockchain(creds, wallet.bech32Address, userName);



    return creds.publicInfo;
  }



  /// This method broadcast the wallet creation message on the blockchain
  /// Input: [AlanPrivateWalletCredentials] credential of the newly created wallet
  /// [creatorAddress] The address of the new wallet
  /// [userName] The name that the user entered
  @override
  Future<void> broadcastWalletCreationMessageOnBlockchain(AlanPrivateWalletCredentials creds, String creatorAddress, String userName) async {
    await _transactionSigningGateway.storeWalletCredentials(
      credentials: creds,
      password: '',
    );

    final info = wallets.value.last;


    final msgObj = pylons.MsgCreateAccount.create()..mergeFromProto3Json({'creator': creatorAddress, 'username': userName});

    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);



    final customSigningGateway = createCustomSigningGateway();



    final result = await customSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey).mapError<dynamic>((error) {

      throw error;
    }).flatMap(
          (signed) => customSigningGateway.broadcastTransaction(
        walletLookupKey: walletLookupKey,
        transaction: signed,
      ),
    );
    print(result);
  }

  QueryClient? getQueryClient() {
    if (_queryClient == null){
      _queryClient = pylons.QueryClient(baseEnv.networkInfo.gRPCChannel);
    }
    return _queryClient;
  }

  /// This method creates the custom signing Gateway for the user
  /// Output : [TransactionSigningGateway] custom signing Gateway with custom logic
  @override
  TransactionSigningGateway createCustomSigningGateway() {
    return  TransactionSigningGateway(
      transactionSummaryUI: NoOpTransactionSummaryUI(),
      signers: [
        CustomTransactionSigner(baseEnv.networkInfo),
      ],
      broadcasters: [
        AlanTransactionBroadcaster(baseEnv.networkInfo),
      ],
      infoStorage: MobileKeyInfoStorage(
        serializers: [AlanCredentialsSerializer()],
      ),
    );
  }




  /// This method sends the money from one address to another
  /// Input : [WalletPublicInfo] contains the info regarding the current network
  /// [balance] the amount that we want to send
  /// [toAddress] the address to which we want to send
  @override
  Future<void> sendCosmosMoney(
    WalletPublicInfo info,
    Balance balance,
    String toAddress,
  ) async {
    isSendMoneyLoading.value = true;
    isSendMoneyError.value = false;
    try {
      await TokenSender(_transactionSigningGateway).sendCosmosMoney(
        info,
        balance,
        toAddress,
      );
    } catch (ex) {
      isError.value = true;
    }
    isSendMoneyLoading.value = false;
  }

  Future<TransactionHash> _signAndBroadcast(GeneratedMessage message)async {
    final unsignedTransaction = UnsignedAlanTransaction(messages: [message]);

    final info = wallets.value.last;

    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );


    final result = await _transactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey).mapError<dynamic>((error) {
      print(error);
      throw error;
    }).flatMap(
          (signed) => _transactionSigningGateway.broadcastTransaction(
        walletLookupKey: walletLookupKey,
        transaction: signed,
      ),
    );

    return result.getOrElse(() => TransactionHash(txHash: ''));
  }

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [TransactionHash] hash of the transaction
  @override
  Future<TransactionHash> createCookBook(Map json) async {
    final msgObj = pylons.MsgCreateCookbook.create()..mergeFromProto3Json(json);
    msgObj.creator = wallets.value.last.publicAddress;
    return await _signAndBroadcast(msgObj);
  }

  @override
  Observable<List<WalletPublicInfo>> getWallets() {
    return wallets;
  }

  @override
  Observable<bool> getAreWalletsLoading() {
    return areWalletsLoadingObservable;
  }

  @override
  Observable<CredentialsStorageFailure?> getLoadWalletsFailure() {
    return loadWalletsFailureObservable;
  }

  @override
  Future<TransactionHash> createRecipe(Map json) async {
    final msgObj = pylons.MsgCreateRecipe.create()..mergeFromProto3Json(json);
    return await _signAndBroadcast(msgObj);
  }

  @override
  Future<TransactionHash> createTrade(Map json) async {
    final msgObj = pylons.MsgCreateTrade.create()..mergeFromProto3Json(json);
    return await _signAndBroadcast(msgObj);
  }

  @override
  Future<TransactionHash> executeRecipe(Map json) async {
    final msgObj = pylons.MsgExecuteRecipe.create()..mergeFromProto3Json(json);
    return await _signAndBroadcast(msgObj);
  }

  @override
  Future<TransactionHash> fulfillTrade(Map json) async {
    final msgObj = pylons.MsgFulfillTrade.create()..mergeFromProto3Json(json);
    return await _signAndBroadcast(msgObj);
  }

  @override
  Future<Cookbook?> getCookbookById(String cookbookID) async {
    final request = pylons.QueryGetCookbookRequest.create()
      ..iD=cookbookID;

    final response = await _queryClient.cookbook(request);
    if(!response.hasCookbook()){
      return null;
    }
    return response.cookbook;
  }

  @override
  Future<List<Cookbook>> getCookbooksByCreator(String creator) async {
    final request = pylons.QueryListCookbooksByCreatorRequest.create()
    ..creator=creator;
    final response = await _queryClient.listCookbooksByCreator(request);
    return response.cookbooks;
  }

  @override
  Future<Item?> getItem(String cookbookID, String itemID) async {
    final request = pylons.QueryGetItemRequest.create()
        ..cookbookID=cookbookID
        ..iD=itemID;
    final response = await _queryClient.item(request);
    if(!response.hasItem()){
      return null;
    }
    return response.item;
  }

  @override
  Future<List<Item>> getItemsByOwner(String owner) async {
    final request = pylons.QueryListItemByOwnerRequest.create()
        ..owner=owner;
    final response = await _queryClient.listItemByOwner(request);
    return response.items;
  }

  @override
  Future<Recipe?> getRecipe(String cookbookID, String recipeID) async {
    final request = pylons.QueryGetRecipeRequest.create()
        ..cookbookID=cookbookID
        ..iD=recipeID;
    final response = await _queryClient.recipe(request);
    if(!response.hasRecipe()){
      return null;
    }
    return response.recipe;
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookbookID) async {
    final request = pylons.QueryListRecipesByCookbookRequest.create()
        ..cookbookID=cookbookID;
    final response = await _queryClient.listRecipesByCookbook(request);
    return response.recipes;
  }

  @override
  Future<Trade?> getTradeByID(Int64 ID) async {
    final request = pylons.QueryGetTradeRequest.create()
        ..iD= ID;
    final response = await _queryClient.trade(request);
    if(!response.hasTrade()){
      return null;
    }
    return response.trade;
  }

  @override
  Future<TxResponse> getTxs(String txHash) {
    // TODO: implement getTradesByCreator
    throw UnimplementedError();
  }

  @override
  Future<String> getAccountAddressByName(String username) async {
    final request = pylons.QueryGetAddressByUsernameRequest.create()
        ..username=username;
    final response = await _queryClient.addressByUsername(request);
    if(!response.hasAddress()){
      return "";
    }
    return response.address.value;
  }

  @override
  Future<String> getAccountNameByAddress(String address) async {
    final request = pylons.QueryGetUsernameByAddressRequest.create()
        ..address=address;
    final response = await _queryClient.usernameByAddress(request);
    if(!response.hasUsername()){
      return "";
    }

    return response.username.value;
  }

  @override
  Future<bool> getFaucetCoin({String? denom}) async {
    Map data = {
      "address": wallets.value.last.publicAddress,
    };
    if(denom != null){
      data["coins"] = [denom];
    }
    final helper = QueryHelper( httpClient: _httpClient);
    final result = await helper.queryPost(this.baseEnv.baseFaucetUrl, data);
    if(!result.isSuccessful){
      return false;
    }
    return true;
  }

}
