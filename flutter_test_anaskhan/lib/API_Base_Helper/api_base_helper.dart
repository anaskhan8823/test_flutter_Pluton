import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_anaskhan/API_Base_Helper/app_exceptions.dart';
import 'package:flutter_test_anaskhan/supporting_widget.dart';
import 'package:get/get.dart' as Getx;
import 'package:http/http.dart';

const String baseUrl = "https://api.spoonacular.com/";

const String search_recipes = "recipes/complexSearch";

String? api_key = "751e79e598314028830293dbe5c59364";

class ApiHelper {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "x-api-key": "$api_key"
  };

  Future<Response> initPost(
      String endpoint, HashMap<String, dynamic> params) async {
    try {
      SupportWidget().myLoader();

      var url = Uri.parse(baseUrl + endpoint);

      var response =
          await post(url, body: jsonEncode(params), headers: headers);

      SupportWidget().closeLoaders();

      return response;
    } on SocketException {
      print('No net');

      throw FetchDataException('No Internet connection');
    }
  }

  Future<Response> initGet(
      String endpoint, HashMap<String, dynamic> params) async {
    try {
      SupportWidget().myLoader();

      var url = Uri.parse(baseUrl + endpoint);
      var response = await get(url, headers: headers);

      SupportWidget().closeLoaders();

      return response;
    } on SocketException {
      print('No net');

      throw FetchDataException('No Internet connection');
    }
  }
}
