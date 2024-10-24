import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyIntakeScreen extends StatelessWidget {
  final DateTime selectedDate;

  DailyIntakeScreen({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final dailyIntakes = foodProvider.getIntakesForDay(selectedDate);
    final dailyMacros = foodProvider.calculateDailyMacros(selectedDate);

    return Scaffold(
      appBar: AppBar(title: Text('Daily Intake for ${selectedDate.toLocal()}')),
      body: Column(
        children: [
          // Display total macros
          ListTile(
            title: Text('Total Calories: ${dailyMacros['calories']}'),
          ),
          ListTile(
            title: Text('Total Carbohydrates: ${dailyMacros['carbohydrates']}'),
          ),
          ListTile(
            title: Text('Total Protein: ${dailyMacros['protein']}'),
          ),
          ListTile(
            title: Text('Total Fat: ${dailyMacros['fat']}'),
          ),
          // List of logged foods
          Expanded(
            child: ListView.builder(
              itemCount: dailyIntakes.length,
              itemBuilder: (context, index) {
                final loggedFood = dailyIntakes[index];
                return ListTile(
                  title: Text('${loggedFood.foodItem.name} (${loggedFood.quantity}g)'),
                  subtitle: Text('Calories: ${loggedFood.totalCalories}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
