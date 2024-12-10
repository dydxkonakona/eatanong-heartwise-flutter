import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/food_details.dart';
import 'package:final_eatanong_flutter/screens/food_screen.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFood extends StatelessWidget {
  AddFood({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Food', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create a new food item (not in database)', // Tooltip added
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Adjust padding for overall body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tap + icon to create a new food item not in the database.',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            // Search Field with updated modern styling
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Food Items',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 251, 98, 98)), // Search icon with custom color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                ),
              ),
              onChanged: (value) {
                // Trigger the searchFood method in the provider
                Provider.of<FoodProvider>(context, listen: false).searchFood(value);
              },
            ),
            const SizedBox(height: 20),
            // Food items list with dynamic search
            Expanded(
              child: Consumer<FoodProvider>(
                builder: (context, foodProvider, child) {
                  final foodItems = foodProvider.filteredFoods;
                  foodItems.sort((a, b) => a.name.compareTo(b.name));
                  if (foodItems.isEmpty) {
                    return const Center(
                      child: Text(
                        'No food items found.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = foodItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          title: Text(
                            foodItem.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            'Calories: ${foodItem.calories}',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              foodProvider.deleteFood(context, foodItem);
                              // Show SnackBar at the top when food is deleted
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Food item deleted!'),
                                  behavior: SnackBarBehavior.floating, // Custom positioning
                                  margin: const EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const NavBar(),
    );
  }
}
