import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/enable_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/execute_recipe_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_recipes_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_cookbook_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/update_recipe_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

void main(){



  test('should return CreateCookBookHandler on TX_CREATE_COOKBOOK action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_CREATE_COOKBOOK, sender: ''));
    expect(true, handler is CreateCookBookHandler);
  });


  test('should return CreateRecipeHandler on TX_CREATE_RECIPE action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_CREATE_RECIPE, sender: ''));
    expect(true, handler is CreateRecipeHandler);
  });


  test('should return UpdateRecipeHandler on TX_UPDATE_RECIPE action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_UPDATE_RECIPE, sender: ''));
    expect(true, handler is UpdateRecipeHandler);
  });


  test('should return Enable recipe on TX_ENABLE_RECIPE action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_ENABLE_RECIPE, sender: ''));
    expect(true, handler is EnableRecipeHandler);
  });


  test('should return ExecuteRecipeHandler on TX_ENABLE_RECIPE action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_EXECUTE_RECIPE, sender: ''));
    expect(true, handler is ExecuteRecipeHandler);
  });



  test('should return GetRecipesHandler on GET_RECIPES action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.GET_RECIPES, sender: ''));
    expect(true, handler is GetRecipesHandler);
  });


  test('should return UpdateCookBookHander on TX_UPDATE_COOKBOOK action', (){
    final handler = HandlerFactory().getHandler(SDKIPCMessage(json: '', action: HandlerFactory.TX_UPDATE_COOKBOOK, sender: ''));
    expect(true, handler is UpdateCookBookHandler);
  });


}