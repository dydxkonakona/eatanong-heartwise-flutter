import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart'; // Import the FoodItem model
import 'package:final_eatanong_flutter/screens/food_details.dart'; // Import the FoodDetails screen
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive for accessing the database

class HealthyRecipesScreen extends StatelessWidget {
  // A hardcoded list of food recipes with names and image paths
  final List<Map<String, String>> recipes = [
    {'name': 'Fish Cardillo (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/fish_cardillo.jpg'},
    {'name': 'Adobong Manok (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/adobong_manok.jpg'},
    {'name': 'Fresh Lumpia (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/fresh_lumpia.jpg'},
    {'name': 'Pesang Isda (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/pesang_isda.jpg'},
    {'name': 'Munggo Guisado (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/munggo_guisado.jpg'},
    {'name': 'Ampalaya with Pork (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/ampalaya_with_pork.jpg'},
    {'name': 'Cantaloupe Crush (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/cantaloupe_crush.jpg'},
    {'name': 'Vegetable Kare-Kare (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/vegetable_karekare.jpg'},
  ];

  HealthyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Healthy Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0, // Keep app bar clean with no shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body content
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Display 1 tile per row
            crossAxisSpacing: 16.0, // Space between columns
            mainAxisSpacing: 16.0, // Space between rows
            childAspectRatio: 1, // Make tiles square
          ),
          itemCount: recipes.length, // Set the item count to the number of recipes
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            final String foodName = recipe['name']!;
            final String imagePath = recipe['imagePath']!;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the food image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ), // Show fallback icon if the image is not found
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Wrap the Column in a SingleChildScrollView to handle overflow
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        foodName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensure long text doesn't overflow
                        maxLines: 2, // Limit text to two lines
                      ),
                    ),
                  ),
                  // Center and resize the Log Food Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Access the Hive box that contains the food items
                          var foodBox = await Hive.openBox<FoodItem>('foodBox');
                          print("foodBox is loaded: ${foodBox.isOpen}");

                          // Search for the food item using a case-insensitive comparison
                          FoodItem? foodItem = foodBox.values.firstWhere(
                            (item) => item.name.toLowerCase() == foodName.toLowerCase(),
                            orElse: () => FoodItem(
                              name: foodName,
                              calories: 0,
                              protein: 0,
                              fat: 0,
                              carbohydrates: 0,
                              sodium: 0,
                              cholesterol: 0,
                            ), // Return a default FoodItem if no match found
                          );

                          if (foodItem.name.toLowerCase() != foodName.toLowerCase()) {
                            // If the foodItem is a default one, show an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Food item "$foodName" not found in the database'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // If a valid foodItem is found, pass it to the FoodDetails screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetails(foodItem: foodItem),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0), // Smaller padding
                          backgroundColor: const Color(0xFFFF6363), // Soft red background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow effect
                          elevation: 3, // Slight elevation
                          side: BorderSide(
                            color: const Color(0xFFFF6363),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'Log Food',
                          style: TextStyle(
                            fontSize: 14, // Smaller font size
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      drawer: NavBar(),
    );
  }
}