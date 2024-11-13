import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:final_eatanong_flutter/screens/food_details.dart'; // Import the new screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFood extends StatelessWidget {
  AddFood({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Log Food', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Adjust padding for overall body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field with updated modern styling
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Food Items',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 251, 98, 98)), // Search icon with custom color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                  ),
                ),
                onChanged: (value) {
                  foodProvider.searchFood(value);
                },
              ),
            ),

            // Food items list with better list item styling
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(
                      child: Text(
                        'Please enter a search term.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : foodProvider.filteredFoods.isEmpty
                      ? Center(
                          child: Text(
                            'No food items found.',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: foodProvider.filteredFoods.length,
                          itemBuilder: (context, index) {
                            final foodItem = foodProvider.filteredFoods[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                title: Text(
                                  foodItem.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Calories: ${foodItem.calories}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                onTap: () {
                                  // Navigate to food details screen on tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetails(foodItem: foodItem),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    foodProvider.deleteFood(context, foodItem);
                                    // Clear the search text after deleting the food item
                                    _searchController.clear();

                                    // Show SnackBar at the top when food is deleted
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Food item deleted!'),
                                        behavior: SnackBarBehavior.floating, // Custom positioning
                                        margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      drawer: NavBar(),
    );
  }
}
