import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart'; // Import the FoodItem model
import 'package:final_eatanong_flutter/screens/food_details.dart'; // Import the FoodDetails screen
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive for accessing the database

class HealthyRecipesScreen extends StatelessWidget {
  // A hardcoded list of food recipes with names and image paths
  final List<Map<String, String>> recipes = [
    {'name': 'Fish Cardillo (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/fish_cardillo.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/fcardillo_i.png', 'stepsImage': 'assets/heart_healthy_recipes/fcardillo_s.png', 'source': 'Philippine Heart Center’s Healthy Heart Cookbook.'},
    {'name': 'Adobong Manok (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/adobong_manok.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/adobo_i.png', 'stepsImage': 'assets/heart_healthy_recipes/adobo_s.png', 'source': 'Filipino-American Nutrition and Fitness Teacher’s Guide, Kalusugan Community Services, San Diego, CA.'},
    {'name': 'Fresh Lumpia (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/fresh_lumpia.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/flumpia_i.png', 'stepsImage': 'assets/heart_healthy_recipes/flumpia_s.png', 'source': 'Mula sa Puso, Heart Healthy Traditional Filipino Recipes, American Heart Association, 1999.'},
    {'name': 'Pesang Isda (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/pesang_isda.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/pisda_i.png', 'stepsImage': 'assets/heart_healthy_recipes/pisda_s.png', 'source': 'Filipino American Food Practices, Customs, and Holidays, American Dietetic Association, 1994.'},
    {'name': 'Munggo Guisado (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/munggo_guisado.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/mguisado_i.png', 'stepsImage': 'assets/heart_healthy_recipes/mguisado_s.png', 'source': 'Filipino American Food Practices, Customs, and Holidays, American Dietetic Association, 1994. '},
    {'name': 'Ampalaya with Pork (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/ampalaya_with_pork.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/ampalaya_i.png', 'stepsImage': 'assets/heart_healthy_recipes/ampalaya_s.png', 'source': 'Adapted from Mula Sa Puso, Heart Healthy Traditional Filipino Recipes, American Heart Association, 1999.'},
    {'name': 'Cantaloupe Crush (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/cantaloupe_crush.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/cantaloupe_i.png', 'stepsImage': 'assets/heart_healthy_recipes/cantaloupe_s.png', 'source': 'Adapted from the National Cancer Institute and InteliHealth (intelihealth.com), 2013.'},
    {'name': 'Vegetable Kare-Kare (Heart Healthy Version)', 'imagePath': 'assets/heart_healthy_food_images/vegetable_karekare.jpg', 'ingredientsImage': 'assets/heart_healthy_recipes/vkarekare_i.png', 'stepsImage': 'assets/heart_healthy_recipes/vkarekare_s.png', 'source': 'PHC Alive Diet, Division of Nutrition and Dietetics, Philippine Heart Center, East Avenue, Quezon City, Philippines, page 91.'},
  ];

  HealthyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
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
            final String ingredientsImage = recipe['ingredientsImage'] ?? '';
            final String stepsImage = recipe['stepsImage'] ?? '';
            final String source = recipe['source'] ?? '';

            return GestureDetector(
              onTap: () {
                // Navigate to the RecipeDetailScreen when the tile is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(
                      ingredientsImage: ingredientsImage,
                      stepsImage: stepsImage,
                      foodName: foodName,
                      source: source,
                    ),
                  ),
                );
              },
              child: Card(
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
                        height: 220,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
      drawer: NavBar(),
    );
  }
}


class RecipeDetailScreen extends StatelessWidget {
  final String ingredientsImage;
  final String stepsImage;
  final String foodName;  // Add foodName to track which food item is being logged
  final String source;

  const RecipeDetailScreen({
    super.key,
    required this.ingredientsImage,
    required this.stepsImage,
    required this.foodName, // Pass foodName to identify the recipe
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(  // Use SingleChildScrollView to make the content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$foodName',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ) ?? const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),  // Add spacing between title and image
              Image.asset(
                ingredientsImage,
                fit: BoxFit.contain,  // Use BoxFit.contain to scale the image while maintaining aspect ratio
                width: double.infinity,  // Make image take up full width of the screen
                height: 290,  // Set a fixed height for the image to avoid overflow
              ),
              const SizedBox(height: 16),  // Add spacing between images
              const SizedBox(height: 8),  // Add spacing between title and image
              Image.asset(
                stepsImage,
                fit: BoxFit.contain,  // Use BoxFit.contain to scale the image while maintaining aspect ratio
                width: double.infinity,  // Make image take up full width of the screen
                height: 290,  // Set a fixed height for the image to avoid overflow
              ),
              const SizedBox(height: 16),
              Text(
                'Source: $source',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40), // Add space before the button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
              fontSize: 16, // Adjusted for readability
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
