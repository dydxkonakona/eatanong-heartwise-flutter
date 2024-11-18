import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:provider/provider.dart';

class FoodDetails extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetails({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Log Food', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food title
              Text(
                '${foodItem.name}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                ' per 100g',
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),),
               SizedBox(height: 10),
              // Nutritional information
              Text('Calories: ${foodItem.calories} kcal', style: _buildNutritionalTextStyle()),
              Text('Protein: ${foodItem.protein} g', style: _buildNutritionalTextStyle()),
              Text('Fat: ${foodItem.fat} g', style: _buildNutritionalTextStyle()),
              Text('Carbohydrates: ${foodItem.carbohydrates} g', style: _buildNutritionalTextStyle()),
              Text('Sodium: ${foodItem.sodium} mg', style: _buildNutritionalTextStyle()),
              Text('Cholesterol: ${foodItem.cholesterol} mg', style: _buildNutritionalTextStyle()),
              Text(
                'Food Nutrition Values based on Philippine Food Composition Table (PhilFCT) Online Database',
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),),
               SizedBox(height: 30),
              // Quantity input field
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity (in grams)',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                  ),
                  prefixIcon: Icon(Icons.scale, color: Color.fromARGB(255, 251, 98, 98)),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),

              // Center the Log Food Button and add padding
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    var foodProvider = Provider.of<FoodProvider>(context, listen: false);

                    // Parse quantity input and log food item
                    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
                    if (quantity > 0) {
                      foodProvider.addLoggedFood(foodItem, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${foodItem.name} logged with quantity: $quantity grams'),
                          behavior: SnackBarBehavior.floating, // Custom positioning
                          margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green, // Green color for success
                        ),
                      );
                      _quantityController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid quantity'),
                          behavior: SnackBarBehavior.floating, // Custom positioning
                          margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.redAccent, // Red color for error
                        ),
                      );
                    }
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/calendar");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0), // Increased horizontal padding
                    backgroundColor: Color(0xFFFF6363), // Softer, pastel-like red
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners for modern look
                    ),
                    shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for depth
                    elevation: 5, // Add elevation for 3D effect
                    side: BorderSide(
                      color: Color(0xFFFF6363), // Matching border color
                      width: 2, // Subtle border
                    ),
                  ),
                  child: Text(
                    'Log Food',
                    style: TextStyle(
                      fontSize: 18, // Slightly larger font size for emphasis
                      fontWeight: FontWeight.w600, // Medium weight for readability
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent nutritional text style
  TextStyle _buildNutritionalTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );
  }
}
