import 'package:alan/alan.dart' as alan;
import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/stripe_loginlink_request.dart';
import 'package:pylons_wallet/model/stripe_loginlink_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart'
    as pylons;
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

abstract class Repository {
  /// This method returns the recipe based on cookbook id and recipe Id
  /// Input : [cookBookId] id of the cookbook that contains recipe, [recipeId] id of the recipe
  /// Output: if successful the output will be [pylons.Recipe] recipe else
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Recipe>> getRecipe(
      {required String cookBookId, required String recipeId});

  /// This method returns the user name associated with the id
  /// Input : [address] address of the user
  /// Output: if successful the output will be [String] username of the user
  /// will return error in the form of failure
  Future<Either<Failure, String>> getUsername({required String address});

  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId(
      {required String cookBookId});

  /// This method returns the cookbook
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be  [pylons.Cookbook]
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId(
      {required String cookBookId});

  /// check if account with username exists
  /// Input:[String] username
  /// Output: [String] if exists returns the address
  /// will return error in form of failure
  Future<Either<Failure, String>> getAddressBasedOnUsername(String username);

  /// THis method returns list of balances against an address
  /// Input:[address] public address of the user
  /// Output : returns the list of [Balance] els throws an error
  Future<Either<Failure, List<Balance>>> getBalance(String address);

  /// THis method returns execution based on the recipe id
  /// Input:[cookBookId] the id of the cookbook that contains recipe, [recipeId] the id of the recipe whose list of execution you want
  /// Output : returns the [ExecutionListByRecipeResponse] else throws an error
  Future<Either<Failure, ExecutionListByRecipeResponse>>
      getExecutionsByRecipeId(
          {required String cookBookId, required String recipeId});

  /// This method returns list of balances against an address
  /// Input:[address] to which amount is to sent, [denom] tells denomination of the fetch coins
  /// Output : returns new balance in case of success else failure
  Future<Either<Failure, int>> getFaucetCoin(
      {required String address, String? denom});

  /// This method returns the Item based on id
  /// Input : [cookBookId] the id of the cookbook which contains the cookbook, [itemId] the id of the item
  /// Output: [pylons.Item] returns the item
  Future<Either<Failure, pylons.Item>> getItem(
      {required String cookBookId, required String itemId});

  /// This method returns the list of items based on id
  /// Input : [owner] the id of the owner
  /// Output: [List][pylons.Item] returns the item list
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner(
      {required String owner});

  /// This method returns the execution based on id
  /// Input : [id] the id of the execution
  /// Output: [pylons.Execution] returns execution
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId(
      {required String id});

  /// Get all current trades against the given creator
  /// Input : [creator] the id of the creator
  /// Output: [List<pylons.Trade>] returns a list of trades
  Future<Either<Failure, List<pylons.Trade>>> getTradesBasedOnCreator(
      {required String creator});

  /// This method returns the private credentials based on the mnemonics
  /// Input : [mnemonic] mnemonics of the imported account, [username] user name of the user
  /// Output: [PrivateWalletCredentials] of the user account
  /// else will give [Failure]
  Future<Either<Failure, PrivateWalletCredentials>> getPrivateCredentials(
      {required String mnemonic, required String username});

  /// Stripe Backend API to Create PaymentIntent
  /// Input: [StripeCreatePaymentIntentRequest]
  /// return [StripeCreatePaymentIntentResponse]
  Future<Either<Failure, StripeCreatePaymentIntentResponse>>
      CreatePaymentIntent(StripeCreatePaymentIntentRequest req);

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest]
  /// return [StripeGeneratePaymentReceiptResponse]
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>>
      GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req);

  /// Stripe Backend API to Generate Registration Token
  /// Input: [address]
  /// return [StripeGenerateRegistrationTokenResponse]
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>>
      GenerateRegistrationToken(String address);

  /// Stripe Backend API to Register Stripe connected Account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(
      StripeRegisterAccountRequest req);

  /// Stripe Backend API to Generate Updated Token for Connected Account
  /// Input: [address]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>>
      GenerateUpdateToken(String address);

  /// Stripe Backend API to Update Stripe Connected Account
  /// Input: [req]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(
      StripeUpdateAccountRequest req);

  /// Stripe Backend API to Generate Payout Token
  /// Input: [StripeGeneratePayoutTokenRequest]
  /// return [StripeGeneratePayoutTokenResponse]
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>>
      GeneratePayoutToken(StripeGeneratePayoutTokenRequest req);

  /// Stripe Backend API to Payout request
  /// Input: [StripePayoutRequest]
  /// return [StripePayoutResponse]
  Future<Either<Failure, StripePayoutResponse>> Payout(StripePayoutRequest req);

  /// Stripe Backend API to Get Connected Account Link matched to the wallet address
  /// Input: [StripeAccountLinkRequest] wallet account
  /// return [StripeAccountLinkResponse] accountLink matchedto wallet account
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(
      StripeAccountLinkRequest req);

  /// Stripe Backend API to Get Stripe Connected Account Login Link
  /// Input: [StripeLoginLinkRequest]
  /// return [StripeLoginLinkResponse]
  Future<Either<Failure, StripeLoginLinkResponse>> StripeGetLoginLink(
      StripeLoginLinkRequest req);
}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;

  final pylons.QueryClient queryClient;

  final bank.QueryClient bankQueryClient;

  final BaseEnv baseEnv;

  final QueryHelper queryHelper;

  RepositoryImp(
      {required this.networkInfo,
      required this.queryClient,
      required this.bankQueryClient,
      required this.queryHelper,
      required this.baseEnv});

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe(
      {required String cookBookId, required String recipeId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryGetRecipeRequest.create()
        ..cookbookID = cookBookId
        ..iD = recipeId;

      final response = await queryClient.recipe(request);

      if (!response.hasRecipe()) {
        return const Left(RecipeNotFoundFailure(RECIPE_NOT_FOUND));
      }

      return Right(response.recipe);
    } on Exception catch (_) {
      return const Left(RecipeNotFoundFailure(RECIPE_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, String>> getUsername({required String address}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryGetUsernameByAddressRequest.create()
        ..address = address;

      final response = await queryClient.usernameByAddress(request);

      if (!response.hasUsername()) {
        return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
      }

      return Right(response.username.value);
    } on Exception catch (_) {
      return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId(
      {required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryListRecipesByCookbookRequest.create()
        ..cookbookID = cookBookId;

      final response = await queryClient.listRecipesByCookbook(request);

      return Right(response.recipes);
    } on Exception catch (_) {
      return const Left(CookBookNotFoundFailure(COOK_BOOK_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId(
      {required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryGetCookbookRequest.create()..iD = cookBookId;

      final response = await queryClient.cookbook(request);
      if (!response.hasCookbook()) {
        return const Left(CookBookNotFoundFailure(COOK_BOOK_NOT_FOUND));
      }

      return Right(response.cookbook);
    } on Exception catch (_) {
      return const Left(CookBookNotFoundFailure(COOK_BOOK_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressBasedOnUsername(
      String username) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryGetAddressByUsernameRequest.create()
        ..username = username;

      final response = await queryClient.addressByUsername(request);

      if (!response.hasAddress()) {
        return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
      }

      return Right(response.address.value);
    } on Exception catch (_) {
      return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, List<Balance>>> getBalance(
      String walletAddress) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryAllBalancesRequest = bank.QueryAllBalancesRequest.create()
      ..address = walletAddress;

    final response = await bankQueryClient.allBalances(queryAllBalancesRequest);

    final balances = <Balance>[];
    if (response.balances.isEmpty ||
        response.balances.indexWhere((element) => element.denom == 'upylon') ==
            -1) {
      balances.add(Balance(denom: "upylon", amount: Amount(Decimal.zero)));
    }

    if (response.balances
            .indexWhere((element) => element.denom == 'ustripeusd') ==
        -1) {
      balances.add(Balance(denom: "ustripeusd", amount: Amount(Decimal.zero)));
    }
    for (final balance in response.balances) {
      balances.add(Balance(
          denom: balance.denom, amount: Amount(Decimal.parse(balance.amount))));
    }
    return Right(balances);
  }

  @override
  Future<Either<Failure, ExecutionListByRecipeResponse>>
      getExecutionsByRecipeId(
          {required String cookBookId, required String recipeId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryExecutionListByRecipe =
        pylons.QueryListExecutionsByRecipeRequest()
          ..cookbookID = cookBookId
          ..recipeID = recipeId;
    final response =
        await queryClient.listExecutionsByRecipe(queryExecutionListByRecipe);

    return Right(ExecutionListByRecipeResponse(
        completedExecutions: response.completedExecutions,
        pendingExecutions: response.pendingExecutions));
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin(
      {required String address, String? denom}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final faucetUrl = "http://34.132.229.23:8080/coins?address=$address";

    final result = await queryHelper.queryGet(faucetUrl);

    if (!result.isSuccessful) {
      return Left(FaucetServerFailure(result.error ?? ''));
    }

    if (result.value!['success'] == false) {
      return Left(FaucetServerFailure(result.value!['error'] as String));
    }

    const amount = 1000000;
    return const Right(amount);
  }

  @override
  Future<Either<Failure, pylons.Item>> getItem(
      {required String cookBookId, required String itemId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryGetItemRequest = pylons.QueryGetItemRequest()
      ..cookbookID = cookBookId
      ..iD = itemId;

    final response = await queryClient.item(queryGetItemRequest);

    if (!response.hasItem()) {
      return const Left(ItemNotFoundFailure(ITEM_NOT_FOUND));
    }

    return Right(response.item);
  }

  @override
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner(
      {required String owner}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryListItemByOwner = pylons.QueryListItemByOwnerRequest()
      ..owner = owner;

    final response = await queryClient.listItemByOwner(queryListItemByOwner);

    return Right(response.items);
  }

  @override
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId(
      {required String id}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryExecutionById = pylons.QueryGetExecutionRequest()..iD = id;

    final response = await queryClient.execution(queryExecutionById);

    if (!response.hasExecution()) {
      return const Left(ItemNotFoundFailure(EXECUTION_NOT_FOUND));
    }
    return Right(response.execution);
  }

  @override
  Future<Either<Failure, List<pylons.Trade>>> getTradesBasedOnCreator(
      {required String creator}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryListTradesByCreatorRequest.create()
        ..creator = creator;

      final response = await queryClient.listTradesByCreator(request);

      if (response.trades.isEmpty) {
        return const Left(TradeNotFoundFailure(TRADE_NOT_FOUND));
      }

      return Right(response.trades);
    } on Exception catch (_) {
      return const Left(TradeNotFoundFailure(TRADE_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, PrivateWalletCredentials>> getPrivateCredentials(
      {required String mnemonic, required String username}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final wallet =
          alan.Wallet.derive(mnemonic.split(" "), baseEnv.networkInfo);
      final creds = AlanPrivateWalletCredentials(
        publicInfo: WalletPublicInfo(
          chainId: 'pylons',
          walletId: username,
          name: username,
          publicAddress: wallet.bech32Address,
        ),
        mnemonic: mnemonic,
      );

      return Right(creds);
    } on Exception catch (_) {
      return const Left(TradeNotFoundFailure(TRADE_NOT_FOUND));
    }
  }

  /// Stripe Backend API to Payout request
  /// Input: [StripeCreatePaymentIntentRequest] {address:, productID:, coin_inputs_index:}
  /// return [StripeCreatePaymentIntentResponse] {client_secret}
  @override
  Future<Either<Failure, StripeCreatePaymentIntentResponse>>
      CreatePaymentIntent(StripeCreatePaymentIntentRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/create-payment-intent", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? CREATE_PAYMENTINTENT_FAILED));
      }
      return Right(StripeCreatePaymentIntentResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(CREATE_PAYMENTINTENT_FAILED));
    }
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest] {pament_intent_id:, client_secret}
  /// return [StripeGeneratePaymentReceiptResponse]
  /// response: {
  ///    purchaseID: String,
  ///    processorName: String
  ///    payerAddr: String
  ///    amount: String
  ///    productID: String,
  ///    signature: String
  /// }
  @override
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>>
      GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/generate-payment-receipt", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GEN_PAYMENTRECEIPT_FAILED));
      }
      return Right(StripeGeneratePaymentReceiptResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(GEN_PAYMENTRECEIPT_FAILED));
    }
  }

  /// Stripe Backend API to Generate payout token
  /// Input: [StripeGeneratePayoutTokenRequest] {address: String, amount: int}
  /// return [StripeGeneratePayoutTokenResponse] {token: String, RedeemAmount: int64}
  @override
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>>
      GeneratePayoutToken(StripeGeneratePayoutTokenRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryGet(
          "${baseEnv.baseStripeUrl}/generate-payout-token?address=${req.address}&amount=${req.amount}");
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GEN_PAYOUTTOKEN_FAILED));
      }
      return Right(StripeGeneratePayoutTokenResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(GEN_PAYOUTTOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [address] wallet address
  /// return [StripeGenerateRegistrationTokenResponse]
  @override
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>>
      GenerateRegistrationToken(String address) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryGet(
          "${baseEnv.baseStripeUrl}/generate-registration-token?address=$address");
      if (!result.isSuccessful) {
        return Left(
            StripeFailure(result.error ?? GEN_REGISTRATIONTOKEN_FAILED));
      }
      return Right(StripeGenerateRegistrationTokenResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(GEN_REGISTRATIONTOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Generate UpdatedToken for ConnectedAccount
  /// Input: [address] wallet address
  /// return [StripeGenerateUpdateTokenResponse]
  @override
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>>
      GenerateUpdateToken(String address) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryGet(
          "${baseEnv.baseStripeUrl}/generate-update-token?address=$address");
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GEN_UPDATETOKEN_FAILED));
      }
      return Right(StripeGenerateUpdateTokenResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(GEN_UPDATETOKEN_FAILED));
    }
  }

  /// Stripe Backend API to Get Stripe Connected Account Link
  /// Input: [StripeAccountLinkRequest]
  /// return [StripeAccountLinkResponse]
  @override
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(
      StripeAccountLinkRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }
    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/accountlink", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GET_ACCOUNTLINK_FAILED));
      }
      return Right(StripeAccountLinkResponse.from(result));
    } on Exception {
      return const Left(StripeFailure(GET_ACCOUNTLINK_FAILED));
    }
  }

  /// Stripe Backend API to Payout Request
  /// Input: [StripePayoutRequest] {address:String, token:String, signature:String, amount:int}
  /// return [StripePayoutResponse] {transfer_id:String}
  @override
  Future<Either<Failure, StripePayoutResponse>> Payout(
      StripePayoutRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }
    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/payout", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? PAYOUT_FAILED));
      }
      return Right(StripePayoutResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(PAYOUT_FAILED));
    }
  }

  /// Stripe Backend API to Register Stripe connected account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  @override
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(
      StripeRegisterAccountRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }
    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/register-account", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? REGISTERACCOUNT_FAILED));
      }
      return Right(StripeRegisterAccountResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(REGISTERACCOUNT_FAILED));
    }
  }

  /// Stripe Backend API to Update Stripe update account
  /// Input: [StripeUpdateAccountRequest] {address:String, token: String, signature: String}
  /// return [StripeUpdateAccountResponse] redirectURL
  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(
      StripeUpdateAccountRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/update-account", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? UPDATEACCOUNT_FAILED));
      }
      return Right(StripeUpdateAccountResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(UPDATEACCOUNT_FAILED));
    }
  }

  /// Stripe Backend API to Get Stripe Connected Account Login Link
  /// Input: [StripeLoginLinkRequest]
  /// return [StripeLoginLinkResponse]
  @override
  Future<Either<Failure, StripeLoginLinkResponse>> StripeGetLoginLink(
      StripeLoginLinkRequest req) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }
    try {
      final result = await queryHelper.queryPost(
          "${baseEnv.baseStripeUrl}/loginlink", req.toJson());
      if (!result.isSuccessful) {
        return Left(StripeFailure(result.error ?? GET_LOGINLINK_FAILED));
      }
      return Right(StripeLoginLinkResponse.from(result));
    } on Exception catch (_) {
      return const Left(StripeFailure(GET_LOGINLINK_FAILED));
    }
  }
}
