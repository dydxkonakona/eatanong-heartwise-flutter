// lib/models/food.dart
import 'package:hive/hive.dart';

part 'food_item.g.dart'; // Generated adapter part

@HiveType(typeId: 1)
class FoodItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double calories; // per 100 grams

  @HiveField(2)
  final double carbohydrates; // per 100 grams

  @HiveField(3)
  final double protein; // per 100 grams

  @HiveField(4)
  final double fat; // per 100 grams

  @HiveField(5)
  final double sodium; // per 100 grams

  @HiveField(6)
  final double cholesterol; // per 100 grams

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.sodium,
    required this.cholesterol,
  });
}

