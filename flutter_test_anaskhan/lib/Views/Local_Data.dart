import 'package:flutter/material.dart';
import 'package:flutter_test_anaskhan/Models/Recipe_details.dart';

class LocalDataDetailsScreen extends StatefulWidget {
  final Recipes_Info recipe;

  LocalDataDetailsScreen({required this.recipe});

  @override
  State<LocalDataDetailsScreen> createState() => _LocalDataDetailsScreenState();
}

class _LocalDataDetailsScreenState extends State<LocalDataDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // print(widget.widget.recipe.extendedIngredients![0].original);
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Data Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe!.image != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.recipe.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              'Title: ${widget.recipe.title}',
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
                  'Ready in ${widget.recipe.readyInMinutes} minutes',
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
                  'Servings: ${widget.recipe.servings}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
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
                    widget.recipe.summary ?? 'No summary available',
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
                  if (widget.recipe.extendedIngredients != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.recipe.extendedIngredients!
                          .map((ingredient) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '- ${ingredient.original ?? ''}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
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
                  if (widget.recipe.analyzedInstructions != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.recipe.analyzedInstructions!
                          .expand((instruction) => instruction.steps ?? [])
                          .map((step) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '${step.number}: ${step.step}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
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
                  if (widget.recipe.nutrition != null &&
                      widget.recipe.nutrition!.nutrients != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.recipe.nutrition!.nutrients!
                          .map((nutrient) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '${nutrient.name}: ${nutrient.amount} ${nutrient.unit}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
