import 'dart:convert';

import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/enable_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/execute_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipes_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

import 'handlers/get_profile_handler.dart';

class HandlerFactory {
  static const String GET_COOKBOOKS = 'getCookbooks';
  static const String GET_PROFILE = 'getProfile';
  static const String GET_RECIPES = 'getRecipes';
  static const String GET_TRADES = 'getTrades';
  static const String TX_BUY_ITEMS = 'txBuyItem';
  static const String TX_BUY_PYLONS = 'txBuyPylons';
  static const String TX_CREATE_COOKBOOK = 'txCreateCookbook';
  static const String TX_CREATE_RECIPE = 'txCreateRecipe';
  static const String TX_UPDATE_COOKBOOK = 'txUpdateCookbook';
  static const String TX_UPDATE_RECIPE = 'txUpdateRecipe';
  static const String TX_ENABLE_RECIPE = 'txEnableRecipe';
  static const String TX_DISABLE_RECIPE = 'txDisableRecipe';
  static const String TX_EXECUTE_RECIPE = 'txExecuteRecipe';
  static const String TX_PLACE_FOR_SALE = 'txPlaceForSale';
  static const String ERR_NODE = 'node';
  static const String ERR_PROFILE_DOES_NOT_EXIST = 'profileDoesNotExist';
  static const String ERR_PAYMENT_NOT_VALID = 'paymentNotValid';
  static const String ERR_INSUFFICIENT_FUNDS = 'insufficientFunds';
  static const String ERR_COOKBOOK_ALREADY_EXISTS = 'cookbookAlreadyExists';
  static const String ERR_COOKBOOK_DOES_NOT_EXIST = 'cookbookDoesNotExist';
  static const String ERR_COOKBOOK_NOT_OWNED = 'cookbookNotOwned';
  static const String ERR_RECIPE_ALREADY_EXISTS = 'recipeAlreadyExists';
  static const String ERR_RECIPE_DOES_NOT_EXIST = 'recipeDoesNotExist';
  static const String ERR_RECIPE_NOT_OWNED = 'recipeNotOwned';
  static const String ERR_RECIPE_ALREADY_ENABLED = 'recipeAlreadyEnabled';
  static const String ERR_RECIPE_ALREADY_DISABLED = 'recipeAlreadyDisabled';
  static const String ERR_ITEM_DOES_NOT_EXIST = 'itemDoesNotExist';
  static const String ERR_ITEM_NOT_OWNED = 'itemNotOwned';
  static const String ERR_MISSING_ITEM_INPUTS = 'missingItemInputs';
  static const String ERR_SOMETHING_WENT_WRONG = 'somethingWentWrong';
  static const String ERR_FETCHING_WALLETS = 'walletsNotFetched';
  static const String ERR_CANNOT_FETCH_RECIPE = 'recipeCannotBeFetched';
  static const String ERR_SIG_TRANSACTION = 'errorSigningTransaction';
  static const String ERR_CANNOT_FETCH_USERNAME = 'cannotFetchUsername';
  static const String ERR_CANNOT_FETCH_RECIPES = 'cannotFetchRecipes';

  BaseHandler getHandler(SDKIPCMessage sdkipcMessage) {

    if (sdkipcMessage.action == TX_CREATE_COOKBOOK) {
      return CreateCookBookHandler(sdkipcMessage);
    }

    if (sdkipcMessage.action == TX_UPDATE_COOKBOOK) {
      return UpdateCookBookHandler(sdkipcMessage);
    }

    if (sdkipcMessage.action == TX_CREATE_RECIPE) {
      return CreateRecipeHandler(sdkipcMessage);
    }

    if (sdkipcMessage.action == TX_EXECUTE_RECIPE) {
      return ExecuteRecipeHandler(sdkipcMessage);
    }

    if (sdkipcMessage.action == TX_UPDATE_RECIPE) {
      return UpdateRecipeHandler(sdkipcMessage);
    }


    if (sdkipcMessage.action == TX_ENABLE_RECIPE) {
      return EnableRecipeHandler(sdkipcMessage);
    }


    if (sdkipcMessage.action == GET_PROFILE) {
      return GetProfileHandler(sdkipcMessage);
    }


    if (sdkipcMessage.action == GET_RECIPES) {
      return GetRecipesHandler(sdkipcMessage);
    }



    return CreateCookBookHandler(sdkipcMessage);
  }
}

extension HandlerValues on BaseHandler {
  String getName(){
    final json = jsonDecode(this.sdkipcMessage.json) as Map;
    if(json.keys.contains("name")){
      return json["name"].toString();
    }
    return "";
  }
}
