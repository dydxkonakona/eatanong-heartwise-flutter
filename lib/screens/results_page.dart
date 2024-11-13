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
                  // Remove leading numbers from the label
                  String label = recognition['label'].replaceAll(RegExp(r'^\d+\s*'), '');
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
