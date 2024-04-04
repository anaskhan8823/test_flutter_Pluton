import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_anaskhan/API_Base_Helper/api_base_helper.dart';
import 'package:flutter_test_anaskhan/Models/Search_Recipes_List.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;

class Recipies_list_controller extends GetxController {
  Rx<bool> isProcessed = false.obs, isLoading = false.obs;

  final query = TextEditingController().obs;
  Future<Search_Recipes_List> getRecipiesList() async {
    HashMap<String, String> params = new HashMap();

    print(query.value.text.toString());

    Http.Response response = await ApiHelper().initGet(
        "$search_recipes?query=${query.value.text.toString()}", params);

    if (response.statusCode == 200) {
      // Parse the response JSON into CarsData
      final jsonData = response.body;
      print("$search_recipes?query=${query.value.text.toString()}");

      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      final recipies = Search_Recipes_List.fromJson(jsonMap);

      return recipies; // Return the parsed CarsData object
    } else {
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
  }
}
