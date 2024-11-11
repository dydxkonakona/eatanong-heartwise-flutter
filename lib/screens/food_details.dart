import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart'; // Import the provider
import 'package:provider/provider.dart'; // Import provider package

class FoodDetails extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetails({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a TextEditingController to manage the quantity input
    final TextEditingController _quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Food'),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${foodItem.name} per 100g', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Calories: ${foodItem.calories} kcal'),
            Text('Protein: ${foodItem.protein} g'),
            Text('Fat: ${foodItem.fat} g'),
            Text('Carbohydrates: ${foodItem.carbohydrates} g'),
            Text('Sodium: ${foodItem.sodium} mg'),
            Text('Cholesterol: ${foodItem.cholesterol} mg'),
            SizedBox(height: 20),

            // Quantity input field
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity (in grams)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Log Food Button
            ElevatedButton(
              onPressed: () {
                // Get the FoodProvider
                var foodProvider = Provider.of<FoodProvider>(context, listen: false);

                // Parse the quantity input and log the food item
                double quantity = double.tryParse(_quantityController.text) ?? 0.0;
                if (quantity > 0) {
                  foodProvider.addLoggedFood(foodItem, quantity);
                  // Optionally show a message or navigate back
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${foodItem.name} logged with quantity: $quantity grams')),
                  );
                  // Clear the quantity input field
                  _quantityController.clear();
                } else {
                  // Show an error if quantity is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid quantity')),
                  );
                }
              },
              child: Text('Log Food Item'),
            ),
          ],
        ),
      ),
    );
  }
}
