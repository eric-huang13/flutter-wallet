import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/model/execution_list_by_recipe_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:http/http.dart' as http;

abstract class Repository {
  /// This method returns the recipe based on cookbook id and recipe Id
  /// Input : [cookBookId] id of the cookbook that contains recipe, [recipeId] id of the recipe
  /// Output: if successful the output will be [pylons.Recipe] recipe else
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Recipe>> getRecipe({required String cookBookId, required String recipeId});

  /// This method returns the user name associated with the id
  /// Input : [address] address of the user
  /// Output: if successful the output will be [String] username of the user
  /// will return error in the form of failure
  Future<Either<Failure, String>> getUsername({required String address});

  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId});

  /// This method returns the cookbook
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be  [pylons.Cookbook]
  /// will return error in the form of failure
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId({required String cookBookId});

  /// check if account with username exists
  /// Input:[String] username
  /// Output: [bool] if exists true, else false
  /// will return error in form of failure
  Future<Either<Failure, bool>> isAccountExists(String username);

  /// THis method returns list of balances against an address
  /// Input:[address] public address of the user
  /// Output : returns the list of [Balance] els throws an error
  Future<Either<Failure, List<Balance>>> getBalance(String address);

  /// THis method returns execution based on the recipe id
  /// Input:[cookBookId] the id of the cookbook that contains recipe, [recipeId] the id of the recipe whose list of execution you want
  /// Output : returns the [ExecutionListByRecipeResponse] else throws an error
  Future<Either<Failure, ExecutionListByRecipeResponse>> getExecutionsByRecipeId({required String cookBookId, required String recipeId});

  /// This method returns list of balances against an address
  /// Input:[address] to which amount is to sent, [denom] tells denomination of the fetch coins
  /// Output : returns new balance in case of success else failure
  Future<Either<Failure, int>> getFaucetCoin({required String address, String? denom});

  /// This method returns the Item based on id
  /// Input : [cookBookId] the id of the cookbook which contains the cookbook, [itemId] the id of the item
  /// Output: [pylons.Item] returns the item
  Future<Either<Failure, pylons.Item>> getItem({required String cookBookId, required String itemId});

  /// This method returns the list of items based on id
  /// Input : [owner] the id of the owner
  /// Output: [List][pylons.Item] returns the item list
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner({required String owner});

  /// This method returns the execution based on id
  /// Input : [id] the id of the execution
  /// Output: [pylons.Execution] returns execution
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId({required String id});
}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;

  final pylons.QueryClient queryClient;

  final bank.QueryClient bankQueryClient;

  final QueryHelper queryHelper;

  RepositoryImp({required this.networkInfo, required this.queryClient, required this.bankQueryClient, required this.queryHelper});

  @override
  Future<Either<Failure, pylons.Recipe>> getRecipe({required String cookBookId, required String recipeId}) async {
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
      final request = pylons.QueryGetUsernameByAddressRequest.create()..address = address;

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
  Future<Either<Failure, List<pylons.Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryListRecipesByCookbookRequest.create()..cookbookID = cookBookId;

      final response = await queryClient.listRecipesByCookbook(request);

      return Right(response.recipes);
    } on Exception catch (_) {
      return const Left(CookBookNotFoundFailure(COOK_BOOK_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, pylons.Cookbook>> getCookbookBasedOnId({required String cookBookId}) async {
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
  Future<Either<Failure, bool>> isAccountExists(String username) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    try {
      final request = pylons.QueryGetAddressByUsernameRequest.create()..username = username;

      final response = await queryClient.addressByUsername(request);

      if (!response.hasAddress()) {
        return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
      }

      return Right(response.hasAddress());
    } on Exception catch (_) {
      return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
    }
  }

  @override
  Future<Either<Failure, List<Balance>>> getBalance(String walletAddress) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryAllBalancesRequest = bank.QueryAllBalancesRequest.create()..address = walletAddress;

    final response = await bankQueryClient.allBalances(queryAllBalancesRequest);

    final balances = <Balance>[];
    if (response.balances.isEmpty || response.balances.indexWhere((element) => element.denom == 'upylon') == -1) {
      balances.add(Balance(denom: "upylon", amount: Amount(Decimal.zero)));
    }
    for (final balance in response.balances) {
      balances.add(Balance(denom: balance.denom, amount: Amount(Decimal.parse(balance.amount))));
    }
    return Right(balances);
  }

  @override
  Future<Either<Failure, ExecutionListByRecipeResponse>> getExecutionsByRecipeId({required String cookBookId, required String recipeId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryExecutionListByRecipe = pylons.QueryListExecutionsByRecipeRequest()
      ..cookbookID = cookBookId
      ..recipeID = recipeId;
    final response = await queryClient.listExecutionsByRecipe(queryExecutionListByRecipe);

    return Right(ExecutionListByRecipeResponse(completedExecutions: response.completedExecutions, pendingExecutions: response.pendingExecutions));
  }

  @override
  Future<Either<Failure, int>> getFaucetCoin({required String address, String? denom}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final faucetUrl = "http://34.132.229.23:8080/coins?address=$address";

    final result = await queryHelper.queryGet(faucetUrl);

    if (!result.isSuccessful) {
      return Left(FaucetServerFailure(result.error ?? ''));
    }

    if(result.value!['success'] == false){
      return Left(FaucetServerFailure(result.value!['error'] as String));
    }

    const amount = 1000000;
    return const Right(amount);
  }

  @override
  Future<Either<Failure, pylons.Item>> getItem({required String cookBookId, required String itemId}) async {
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
  Future<Either<Failure, List<pylons.Item>>> getListItemByOwner({required String owner}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NoInternetFailure(NO_INTERNET));
    }

    final queryListItemByOwner = pylons.QueryListItemByOwnerRequest()..owner = owner;

    final response = await queryClient.listItemByOwner(queryListItemByOwner);

    return Right(response.items);
  }

  @override
  Future<Either<Failure, pylons.Execution>> getExecutionBasedOnId({required String id}) async {
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
}
