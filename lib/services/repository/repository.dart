import 'package:dartz/dartz.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

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



}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;

  final pylons.QueryClient queryClient;

  RepositoryImp({required this.networkInfo, required this.queryClient});

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
    } on Exception catch(_){
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
    } on Exception catch(_){
      return const Left(RecipeNotFoundFailure(USERNAME_NOT_FOUND));
    }

  }
}
