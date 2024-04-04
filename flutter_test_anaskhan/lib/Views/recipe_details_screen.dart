// import 'package:flutter/material.dart';
// import 'package:flutter_test_anaskhan/Controllers/Recipe_details.dart';
// import 'package:flutter_test_anaskhan/Models/Recipe_details.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class RecipeDetails extends StatefulWidget {
//   final String title;

//   RecipeDetails({Key? key, required this.title}) : super(key: key);

//   @override
//   State<RecipeDetails> createState() => _RecipeDetailsState();
// }

// class _RecipeDetailsState extends State<RecipeDetails> {
//   Recipies_details recipiesdetails = Get.put(Recipies_details());
//   late Recipes_Info recipydata;

//   @override
//   void initState() {
//     // recipydata = recipiesdetails.getRecipiesdetails(widget.title);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: FutureBuilder(
//         future: recipiesdetails.getRecipiesdetails(widget.title),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             // Assuming recipydata contains the recipe details
//             return Center(
//               child: Text('Recipe Details for ${recipydata.title}'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_anaskhan/Controllers/Recipe_details.dart';
import 'package:flutter_test_anaskhan/Models/Recipe_details.dart';
import 'package:flutter_test_anaskhan/Views/home_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetails extends StatefulWidget {
  final String title;

  RecipeDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  Recipies_details recipiesdetails = Get.put(Recipies_details());
  late Future<Recipes_Info> recipydata;

  @override
  void initState() {
    // Initialize recipydata in initState if necessary
    recipydata = recipiesdetails.getRecipiesdetails(widget.title);
    checkFavoriteStatus();
    super.initState();
  }

  bool isFavorite = false;
  void checkFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoriteKey =
        'is_favorite_${widget.title}'; // Use a consistent key format for favorite status
    setState(() {
      isFavorite = prefs.getBool(favoriteKey) ??
          false; // Retrieve the favorite status as boolean
    });
  }

  // void toggleFavoriteStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String favoriteKey =
  //       'is_favorite_${widget.title}'; // Use a consistent key format for favorite status
  //   Recipes_Info recipe =
  //       await recipydata; // Await the Future to get the actual Recipes_Info object

  void toggleFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoriteKey =
        'is_favorite_${widget.title}'; // Use a consistent key format for favorite status
    Recipes_Info recipe = await recipydata;
    String recipeKey = 'recipe_${widget.title}';
    String recipeJson = jsonEncode(recipe.toJson());
    print(recipeJson);
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(
          favoriteKey, isFavorite); // Save the favorite status as boolean
      prefs.setString(recipeKey, recipeJson);

      print('Favorite Key: $favoriteKey');
      print('Recipe Key: $recipeKey');
      print('Recipe JSON: $recipeJson');
      // Save the JSON string to local storage
    });
    Get.offAll(SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Details"),
      ),
      body: FutureBuilder<Recipes_Info>(
        future: recipydata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var recipe = snapshot.data;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recipe!.image != null)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(recipe.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'Title: ${recipe.title}',
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Ready in ${recipe.readyInMinutes} minutes',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.room_service, size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Servings: ${recipe.servings}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: toggleFavoriteStatus,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isFavorite
                            ? Colors.red.withOpacity(0.8)
                            : Colors.grey.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isFavorite
                                ? 'Remove from Favorites'
                                : 'Add to Favorites',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Summary Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipe.summary ?? 'No summary available',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[400]),

                  // Ingredients Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        if (recipe.extendedIngredients != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.extendedIngredients!
                                .map((ingredient) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        '- ${ingredient.original ?? ''}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[400]),

                  // Instructions Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        if (recipe.analyzedInstructions != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.analyzedInstructions!
                                .expand(
                                    (instruction) => instruction.steps ?? [])
                                .map((step) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        '${step.number}: ${step.step}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[400]),

                  // Nutrition Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nutrition',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        if (recipe.nutrition != null &&
                            recipe.nutrition!.nutrients != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.nutrition!.nutrients!
                                .map((nutrient) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        '${nutrient.name}: ${nutrient.amount} ${nutrient.unit}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
