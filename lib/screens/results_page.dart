import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart'; // Import the FoodItem model
import 'package:final_eatanong_flutter/screens/food_details.dart'; // Import the FoodDetails screen
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive for accessing the database

class ResultsPage extends StatelessWidget {
  final List<dynamic> recognitions;

  const ResultsPage({super.key, required this.recognitions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification Results', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0, // Keep app bar clean with no shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body content
        child: SingleChildScrollView( // Ensure content is scrollable to avoid overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true, // Prevent overflow and ensure list can be wrapped in a scrollable view
                physics: NeverScrollableScrollPhysics(), // Disable scroll within ListView itself, scroll handled by SingleChildScrollView
                itemCount: recognitions.length,
                itemBuilder: (context, index) {
                  final recognition = recognitions[index];
                  // Clean and normalize the label
                  String label = recognition['label'].replaceAll(RegExp(r'^\d+\s*'), '').trim();
                  String normalizedLabel = label.toLowerCase(); // Normalize label to lowercase


                  // Generate the image path using the label (formatted for the file names)
                  String imagePath = 'assets/food_images/${label.toLowerCase().replaceAll(' ', '_')}.jpg';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
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
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ), // Show fallback icon if the image is not found
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Display the food name
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Display the confidence score
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Confidence: ${(recognition['confidence'] * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Log Food Button with updated style
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center( // Center the button within the column
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Access the Hive box that contains the food items
                                  var foodBox = await Hive.openBox<FoodItem>('foodBox');
                                  print("foodBox is loaded: ${foodBox.isOpen}");
                                  
                                  // Search for the food item using a case-insensitive comparison
                                  FoodItem? foodItem = foodBox.values.firstWhere(
                                    (item) => item.name.toLowerCase().trim() == normalizedLabel.trim(),
                                    orElse: () => FoodItem(
                                      name: label, 
                                      calories: 0, 
                                      protein: 0, 
                                      fat: 0, 
                                      carbohydrates: 0, 
                                      sodium: 0, 
                                      cholesterol: 0,
                                    ), // Return a default FoodItem if no match found
                                  );

                                  print("Label: $label");
                                  print("FoodItem: ${foodItem.name}");
                                  print("Normalized Label: $normalizedLabel");
                                  print("FoodItem: ${foodItem.name.toLowerCase()}");
                                  if (foodItem.name.toLowerCase() != normalizedLabel) {
                                    print("Mismatched food item found, returning default.");
                                  }

                                  if (foodItem.name.toLowerCase() != normalizedLabel) {
                                    // If the foodItem is a default one, show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Food item "$label" not found in the database'),
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
                                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0), // Adjust padding
                                  backgroundColor: const Color(0xFFFF6363), // Soft red background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                                  ),
                                  shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow effect
                                  elevation: 5, // Add elevation for 3D effect
                                  side: BorderSide(
                                    color: const Color(0xFFFF6363), // Border color to match button
                                    width: 2, // Thin border for subtle effect
                                  ),
                                ),
                                child: const Text(
                                  'Log Food',
                                  style: TextStyle(
                                    fontSize: 18, // Slightly larger font size
                                    fontWeight: FontWeight.w600, // Medium weight for emphasis
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0), // Extra space to ensure button is not too close to content
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
