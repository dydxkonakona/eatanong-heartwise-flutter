import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:provider/provider.dart';

class WaterProvider with ChangeNotifier {
  final Box<WaterIntake> _waterBox = Hive.box<WaterIntake>('waterIntakeBox');

  List<WaterIntake> getWaterIntakesForDay(DateTime date) {
    return _waterBox.values.where((intake) => 
      intake.date.year == date.year &&
      intake.date.month == date.month &&
      intake.date.day == date.day
    ).toList();
  }

  void addWaterIntake(WaterIntake intake) {
    _waterBox.add(intake);
    notifyListeners();
  }

  void deleteWaterIntake(int index) {
    _waterBox.deleteAt(index);
    notifyListeners();
  }

  double calculateTotalWaterIntake(DateTime date) {
    return getWaterIntakesForDay(date).fold(0.0, (sum, intake) => sum + intake.amount);
  }

  // Method to get the water intake progress and return a string
  String getWaterIntakeProgress(BuildContext context, DateTime date) {
    // Access PersonProvider to get the user's details (age and weight)
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    final person = personProvider.persons.isNotEmpty ? personProvider.persons.last : null;

    if (person == null) {
      return "Person data not available";
    }

    // Calculate recommended intake based on the user's age
    double recommendedIntake = _calculateRecommendedIntake(person);

    // Calculate total water intake for the day
    double totalIntake = calculateTotalWaterIntake(date);

    // Calculate the percentage of the recommended intake achieved
    double progressPercentage = (totalIntake / recommendedIntake) * 100;

    // Return a formatted string showing the water intake progress
    return "${totalIntake.toStringAsFixed(1)} ml / ${recommendedIntake.toStringAsFixed(1)} ml (${progressPercentage.toStringAsFixed(1)}%)";
  }

  // Helper method to calculate recommended intake based on age and weight
  double _calculateRecommendedIntake(Person person) {
    int age = person.age; // Access the person's age using the getter

    if (age >= 65) {
      return 1500.0; // Recommended intake for 65 and up
    } else if (age >= 19) {
      return 2500.0; // Recommended intake for 19 and up
    } else if (age >= 1 && age <= 18) {
      // Recommended intake for age 1-18
      return 1000.0 + (50.0 * person.weight); // 50 ml per kg of body weight
    } else {
      // If age is below 1, recommend a default value or an error message
      return 1000.0;
    }
  }
}
