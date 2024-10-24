import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFood extends StatelessWidget {
  AddFood({super.key});
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
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
            child: ListView.builder(
              itemCount: foodProvider.filteredFoods.length,
              itemBuilder: (context, index) {
                final foodItem = foodProvider.filteredFoods[index];
                return ListTile(
                  title: Text(foodItem.name),
                  subtitle: Text('Calories: ${foodItem.calories}'),
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

          // Log food item
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: 'Quantity (in grams)'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              if (foodProvider.foods.isNotEmpty) {
                final foodItem = foodProvider.foods[0]; // Example: logging the first food item
                double quantity = double.tryParse(_quantityController.text) ?? 100.0;
                foodProvider.addLoggedFood(foodItem, quantity);
                _quantityController.clear();
              }
            },
            child: Text('Log Food Item'),
          ),
        ],
      ),
    );
  }
}