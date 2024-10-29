import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart'; // Import the FoodItem model
import 'package:final_eatanong_flutter/screens/food_details.dart'; // Import the FoodDetails screen

class ResultsPage extends StatelessWidget {
  final List<dynamic> recognitions;

  const ResultsPage({super.key, required this.recognitions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification Results'),
      ),
      body: ListView.builder(
        itemCount: recognitions.length,
        itemBuilder: (context, index) {
          final recognition = recognitions[index];
          // Remove leading numbers from the label
          String label = recognition['label'].replaceAll(RegExp(r'^\d+\s*'), '');
          // Generate the image path using the label (formatted for the file names)
          String imagePath = 'assets/food_images/${label.toLowerCase().replaceAll(' ', '_')}.jpg';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  // Display the food image
                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ), // Show fallback icon if the image is not found
                  ),
                  const SizedBox(height: 25),
                  // Display the food name
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display the confidence score
                  Text(
                    'Confidence: ${(recognition['confidence'] * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Log Food Button
                  ElevatedButton(
                    onPressed: () {
                      // Create a FoodItem instance using the recognition data
                      FoodItem foodItem = FoodItem(
                        name: label,
                        calories: 0, // Set default or fetched values as needed
                        protein: 0, // Set default or fetched values as needed
                        fat: 0, // Set default or fetched values as needed
                        carbohydrates: 0, // Set default or fetched values as needed
                        sodium: 0, // Set default or fetched values as needed
                        cholesterol: 0, // Set default or fetched values as needed
                      );

                      // Navigate to FoodDetails screen with the created FoodItem
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetails(foodItem: foodItem),
                        ),
                      );
                    },
                    child: const Text('Log Food Item'),
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
