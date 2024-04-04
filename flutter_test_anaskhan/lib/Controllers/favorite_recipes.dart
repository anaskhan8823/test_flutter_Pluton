import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/Search_Recipes_List_controller.dart';
import '../Controllers/Recipe_details.dart';
import '../Models/Recipe_details.dart';
import '../Models/Search_Recipes_List.dart';
import '../Views/recipe_details_screen.dart';
import '../Views/Local_Data.dart';

class Recipies_Favorites extends GetxController {
  RxList<Recipes_Info> favoriteRecipes = <Recipes_Info>[].obs;
  RxList<Recipes_Info> recipes = <Recipes_Info>[].obs;
  void fetchFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String key in prefs.getKeys()) {
      if (key.startsWith('recipe_')) {
        String? recipeJson = prefs.getString(key);
        String favoriteKey = 'is_favorite_${key.substring(7)}';
        bool? isFavorite = prefs.getBool(favoriteKey);

        if (isFavorite == true && recipeJson != null) {
          Map<String, dynamic> recipeMap = jsonDecode(recipeJson);
          Recipes_Info recipe = Recipes_Info.fromJson(recipeMap);
          recipes.add(recipe);
        }
      }
    }

    favoriteRecipes = recipes;
  }
}
