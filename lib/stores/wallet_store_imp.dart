import 'package:alan/alan.dart' as alan;
import 'package:cosmos_utils/extensions.dart';
import 'package:cosmos_utils/future_either.dart';
import 'package:mobx/mobx.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/custom_transaction_signing_gateaway/custom_transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/token_sender.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class WalletsStoreImp implements WalletsStore {
  final TransactionSigningGateway _transactionSigningGateway;
  final CustomTransactionSigningGateway _customTransactionSigningGateway;
  final BaseEnv baseEnv;

  WalletsStoreImp(this._transactionSigningGateway, this.baseEnv, this._customTransactionSigningGateway);

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

    WalletLookupKey walletLookupKey = createWalletLookUp(info);

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);

    final result = await _customTransactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey).mapError<dynamic>((error) {
      throw error;
    }).flatMap(
      (signed) => _customTransactionSigningGateway.broadcastTransaction(
        walletLookupKey: walletLookupKey,
        transaction: signed,
      ),
    );
    print(result);
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

  /// This method creates the cookbook
  /// Input : [Map] containing the info related to the creation of cookbook
  /// Output : [TransactionHash] hash of the transaction
  @override
  Future<SDKIPCResponse> createCookBook(Map json) async {
    final msgObj = pylons.MsgCreateCookbook.create()..mergeFromProto3Json(json);

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);

    final walletsResultEither = await _customTransactionSigningGateway.getWalletsList();

    if (walletsResultEither.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while fetching wallets', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final accountsList = walletsResultEither.getOrElse(() => []);
    if (accountsList.isEmpty) {
      return SDKIPCResponse.failure(sender: '', error: 'No profile found in wallet', errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST, transaction: '');
    }

    final info = accountsList.last;

    final walletLookupKey = createWalletLookUp(info);

    msgObj.creator = info.publicAddress;

    final signedTransaction = await _transactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey);

    if (signedTransaction.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while signing transaction', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final response = await _customTransactionSigningGateway.broadcastTransaction(
      walletLookupKey: walletLookupKey,
      transaction: signedTransaction.toOption().toNullable()!,
    );

    if (response.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: response.swap().toOption().toNullable().toString(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    return SDKIPCResponse.success(sender: '', data: response.getOrElse(() => TransactionResponse.initial()).hash, transaction: '');
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
  Future<SDKIPCResponse> createRecipe(Map<dynamic, dynamic> json) async {
    final msgObj = pylons.MsgCreateRecipe.create()..mergeFromProto3Json(json);

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);

    final walletsResultEither = await _customTransactionSigningGateway.getWalletsList();

    if (walletsResultEither.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while fetching wallets', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final accountsList = walletsResultEither.getOrElse(() => []);
    if (accountsList.isEmpty) {
      return SDKIPCResponse.failure(sender: '', error: 'No profile found in wallet', errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST, transaction: '');
    }

    final info = accountsList.last;

    final walletLookupKey = createWalletLookUp(info);

    msgObj.creator = info.publicAddress;


    final signedTransaction = await _transactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey);


    if (signedTransaction.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while signing transaction', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final response = await _customTransactionSigningGateway.broadcastTransaction(
      walletLookupKey: walletLookupKey,
      transaction: signedTransaction.toOption().toNullable()!,
    );

    if (response.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: response.swap().toOption().toNullable().toString(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    return SDKIPCResponse.success(sender: '', data: response.getOrElse(() => TransactionResponse.initial()).hash, transaction: '');
  }

  WalletLookupKey createWalletLookUp(WalletPublicInfo info) {
    final walletLookupKey = WalletLookupKey(
      walletId: info.walletId,
      chainId: info.chainId,
      password: '',
    );
    return walletLookupKey;
  }

  @override
  Future<SDKIPCResponse> executeRecipe(Map json) async{
    // print(json);
    final msgObj = pylons.MsgExecuteRecipe.create()..mergeFromProto3Json(json);

    final unsignedTransaction = UnsignedAlanTransaction(messages: [msgObj]);

    final walletsResultEither = await _customTransactionSigningGateway.getWalletsList();

    if (walletsResultEither.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while fetching wallets', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final accountsList = walletsResultEither.getOrElse(() => []);
    if (accountsList.isEmpty) {
      return SDKIPCResponse.failure(sender: '', error: 'No profile found in wallet', errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST, transaction: '');
    }

    final info = accountsList.last;

    final walletLookupKey = createWalletLookUp(info);

    msgObj.creator = info.publicAddress;

    print(msgObj.toProto3Json());

    final signedTransaction = await _transactionSigningGateway.signTransaction(transaction: unsignedTransaction, walletLookupKey: walletLookupKey);


    if (signedTransaction.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: 'Something went wrong while signing transaction', errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    final response = await _customTransactionSigningGateway.broadcastTransaction(
      walletLookupKey: walletLookupKey,
      transaction: signedTransaction.toOption().toNullable()!,
    );

    if (response.isLeft()) {
      return SDKIPCResponse.failure(sender: '', error: response.swap().toOption().toNullable().toString(), errorCode: HandlerFactory.ERR_SOMETHING_WENT_WRONG, transaction: '');
    }

    return SDKIPCResponse.success(sender: '', data: response.getOrElse(() => TransactionResponse.initial()).hash, transaction: '');
  }
}
