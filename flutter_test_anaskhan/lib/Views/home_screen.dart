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

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());
  Recipies_list_controller recipieslistcontroller =
      Get.put(Recipies_list_controller());
  Recipies_details recipiesdetails = Get.put(Recipies_details());
  Future<Search_Recipes_List>? recipydata;

  List<Recipes_Info> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    recipieslistcontroller.query.value.clear();
    fetchFavoriteRecipes();
  }

  void fetchFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Recipes_Info> recipes = [];

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

    setState(() {
      favoriteRecipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0XFF611A20), // Customizing app bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: recipieslistcontroller.query.value,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded border
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      recipydata = recipieslistcontroller.getRecipiesList();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder<Search_Recipes_List>(
                future: recipydata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Fetching recipes...",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'No data available.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    var recipes = snapshot.data!.results;
                    return ListView.builder(
                      itemCount: recipes!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(RecipeDetails(
                              title: recipes[index].id.toString(),
                            ));
                          },
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: Colors.grey[
                                      300]!), // Add border for better distinction
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    children: [
                                      Container(
                                        foregroundDecoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                        child: Image.network(
                                          recipes[index].image.toString(),
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Title Section
                                Positioned.fill(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        recipes[index].title.toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Prominent white text
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign
                                            .center, // Center align the text
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Favorite Recipes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      Recipes_Info recipe = favoriteRecipes[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            LocalDataDetailsScreen(recipe: recipe),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              left: index == 0 ? 16 : 0, right: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(
                                      0XFF611A20), // Placeholder for image
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 50,
                                    color: Colors.white,
                                  ), // Custom icon
                                ),
                                SizedBox(height: 8),
                                Text(
                                  recipe.title ?? 'Untitled Recipe',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
