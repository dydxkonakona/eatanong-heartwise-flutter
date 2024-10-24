import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:hive/hive.dart';

part 'logged_food.g.dart'; // Ensure this file is generated

@HiveType(typeId: 2) // Ensure this matches your registration
class LoggedFood {
  @HiveField(0)
  final double quantity; // in grams

  @HiveField(1)
  final DateTime loggedTime;

  @HiveField(2)
  final FoodItem foodItem; // Reference to FoodItem

  LoggedFood({
    required this.quantity,
    required this.loggedTime,
    required this.foodItem,
  });

  double get totalCalories => (foodItem.calories / 100) * quantity;
  double get totalCarbohydrates => (foodItem.carbohydrates / 100) * quantity;
  double get totalProtein => (foodItem.protein / 100) * quantity;
  double get totalFat => (foodItem.fat / 100) * quantity;
  double get totalSodium => (foodItem.sodium / 100) * quantity;
  double get totalCholesterol => (foodItem.cholesterol / 100) * quantity;
}
