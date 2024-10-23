// lib/models/food.dart
import 'package:hive/hive.dart';

part 'food.g.dart'; // Generated adapter part

@HiveType(typeId: 1)
class Food {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int calories;

  @HiveField(2)
  final double fat;

  @HiveField(3)
  final double protein;

  @HiveField(4)
  final double carbohydrates;

  @HiveField(5)
  final double sodium;

  @HiveField(6)
  final double cholesterol;

  Food({
    required this.name,
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbohydrates,
    required this.sodium,
    required this.cholesterol,
  });
}
