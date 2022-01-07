import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/model/stripe_loginlink_request.dart';
import 'package:pylons_wallet/model/stripe_loginlink_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart'
    as pylons;
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:transaction_signing_gateway/model/private_wallet_credentials.dart';

class MockRepository extends Repository {
  @override
  Future<Either<Failure, StripeCreatePaymentIntentResponse>>
      CreatePaymentIntent(StripeCreatePaymentIntentRequest req) async {
    return Right(StripeCreatePaymentIntentResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeGeneratePaymentReceiptResponse>>
      GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req) async {
    return Right(StripeGeneratePaymentReceiptResponse(
      success: true,
    ));
  }

  @override
  Future<Either<Failure, StripeGeneratePayoutTokenResponse>>
      GeneratePayoutToken(StripeGeneratePayoutTokenRequest req) async {
    return Right(StripeGeneratePayoutTokenResponse(
        success: true, RedeemAmount: Int64.ONE));
  }

  @override
  Future<Either<Failure, StripeGenerateRegistrationTokenResponse>>
      GenerateRegistrationToken(String address) async {
    return Right(StripeGenerateRegistrationTokenResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeGenerateUpdateTokenResponse>>
      GenerateUpdateToken(String address) async {
    return Right(StripeGenerateUpdateTokenResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeAccountLinkResponse>> GetAccountLink(
      StripeAccountLinkRequest req) async {
    return Right(StripeAccountLinkResponse(success: true));
  }

  @override
  Future<Either<Failure, StripePayoutResponse>> Payout(
      StripePayoutRequest req) async {
    return Right(StripePayoutResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeRegisterAccountResponse>> RegisterAccount(
      StripeRegisterAccountRequest req) async {
    return Right(StripeRegisterAccountResponse(success: true));
  }

  @override
  Future<Either<Failure, StripeUpdateAccountResponse>> UpdateAccount(
      StripeUpdateAccountRequest req) async {
    return Right(StripeUpdateAccountResponse(success: true));
  }

  @override
  Future<Either<Failure, String>> getAddressBasedOnUsername(String username) {
    // TODO: implement getAddressBasedOnUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Balance>>> getBalance(String address) {
    // TODO: implement getBalance
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Cookbook>> getCookbookBasedOnId(
      {required String cookBookId}) {
    // TODO: implement getCookbookBasedOnId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Execution>> getExecutionBasedOnId(
      {required String id}) {
    // TODO: implement getExecutionBasedOnId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExecutionListByRecipeResponse>>
      getExecutionsByRecipeId(
          {required String cookBookId, required String recipeId}) {
    // TODO: implement getExecutionsByRecipeId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin(
      {required String address, String? denom}) {
    // TODO: implement getFaucetCoin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Item>> getItem(
      {required String cookBookId, required String itemId}) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Item>>> getListItemByOwner(
      {required String owner}) {
    // TODO: implement getListItemByOwner
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PrivateWalletCredentials>> getPrivateCredentials(
      {required String mnemonic, required String username}) {
    // TODO: implement getPrivateCredentials
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe(
      {required String cookBookId, required String recipeId}) {
    // TODO: implement getRecipe
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId(
      {required String cookBookId}) {
    // TODO: implement getRecipesBasedOnCookBookId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Trade>>> getTradesBasedOnCreator(
      {required String creator}) {
    // TODO: implement getTradesBasedOnCreator
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getUsername({required String address}) {
    // TODO: implement getUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, StripeLoginLinkResponse>> StripeGetLoginLink(
      StripeLoginLinkRequest req) {
    // TODO: implement StripeGetLoginLink
    throw UnimplementedError();
  }
}
