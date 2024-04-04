import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_anaskhan/API_Base_Helper/api_base_helper.dart';
import 'package:flutter_test_anaskhan/Models/Recipe_details.dart';
import 'package:flutter_test_anaskhan/Models/Search_Recipes_List.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;

class Recipies_details extends GetxController {
  Rx<bool> isProcessed = false.obs, isLoading = false.obs;

  final query = TextEditingController().obs;

  Future<Recipes_Info> getRecipiesdetails(String id) async {
    HashMap<String, String> params = new HashMap();

    Http.Response response = await ApiHelper().initGet(
        "recipes/informationBulk?ids=$id&includeNutrition=true", params);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.isNotEmpty) {
        return Recipes_Info.fromJson(jsonResponse.first);
      } else {
        throw Exception('Recipe not found');
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
