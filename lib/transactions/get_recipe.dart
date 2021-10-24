import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/model/recipe_json.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:http/http.dart' as http;

class GetRecipe {
  BaseEnv baseEnv;

  GetRecipe(this.baseEnv);

  Future<RecipeJson?> getRecipe(String cookbookID, String recipeID)async{

    try {
      final uri = Uri.parse(
        "${baseEnv.baseApiUrl}/pylons/recipe/$cookbookID/$recipeID",);
      debugPrint(uri.toString());
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final recipeMap = jsonDecode(response.body) as Map<String, dynamic>;
        final recipeJson = RecipeJson.fromJson(recipeMap);
        return recipeJson;
      }

      return null;
    }catch(e){
      debugPrint(e.toString());
      return null;
    }

  }
}