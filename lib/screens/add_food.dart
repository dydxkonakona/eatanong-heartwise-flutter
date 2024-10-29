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
      appBar: AppBar(title: Text('Food Logger')),
      body: Column(
        children: [
          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Search Food Items'),
            onChanged: (value) {
              foodProvider.searchFood(value);
            },
          ),

          // Food items list
          Expanded(
            child: _searchController.text.isEmpty
                ? Center(child: Text('Please enter a search term.')) // Message when the search field is empty
                : foodProvider.filteredFoods.isEmpty
                    ? Center(child: Text('No food items found.')) // Message when no items match the search
                    : ListView.builder(
                        itemCount: foodProvider.filteredFoods.length,
                        itemBuilder: (context, index) {
                          final foodItem = foodProvider.filteredFoods[index];
                          return ListTile(
                            title: Text(foodItem.name),
                            subtitle: Text('Calories: ${foodItem.calories}'),
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
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                foodProvider.deleteFood(index);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
