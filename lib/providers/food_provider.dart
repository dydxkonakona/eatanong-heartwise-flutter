import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/models/logged_food.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FoodProvider extends ChangeNotifier {
  final Box<FoodItem> _foodBox = Hive.box<FoodItem>('foodBox');
  final Box<LoggedFood> _loggedFoodBox = Hive.box<LoggedFood>('loggedFoodBox');

  List<FoodItem> _filteredFoods = [];

  List<FoodItem> get foods => _foodBox.values.toList();
  List<FoodItem> get filteredFoods => _filteredFoods.isEmpty ? foods : _filteredFoods;

  FoodProvider() {
    _initializePresetData();
  }

  void _initializePresetData() {
    if (_foodBox.isEmpty) {
      // Add preset food items
      final List<FoodItem> presetFoods = [
        FoodItem(name: 'Apple', calories: 52, carbohydrates: 14, protein: 0.3, fat: 0.2, sodium: 1, cholesterol: 0),
        FoodItem(name: 'Banana', calories: 89, carbohydrates: 23, protein: 1.1, fat: 0.3, sodium: 1, cholesterol: 0),
        FoodItem(name: 'Chicken Breast', calories: 165, carbohydrates: 0, protein: 31, fat: 3.6, sodium: 74, cholesterol: 85),
        // Add more preset items as needed
      ];

      for (var food in presetFoods) {
        _foodBox.add(food);
      }
      notifyListeners();
    }
  }

  void addFood(FoodItem food) {
    _foodBox.add(food);
    notifyListeners();
  }

  void deleteFood(int index) {
    _foodBox.deleteAt(index);
    notifyListeners();
  }

  void updateFood(int index, FoodItem updatedFood) {
    _foodBox.putAt(index, updatedFood);
    notifyListeners();
  }

  void searchFood(String query) {
    if (query.isEmpty) {
      _filteredFoods = [];
    } else {
      _filteredFoods = _foodBox.values
          .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addLoggedFood(FoodItem foodItem, double quantity) {
    final loggedFood = LoggedFood(
      quantity: quantity,
      loggedTime: DateTime.now(),
      foodItem: foodItem,
    );

    _loggedFoodBox.add(loggedFood);
    notifyListeners();
  }

  void deleteLoggedFood(int index) {
    _loggedFoodBox.deleteAt(index);
    notifyListeners();
  }

  List<LoggedFood> get loggedFoods => _loggedFoodBox.values.toList();

  List<LoggedFood> getIntakesForDay(DateTime date) {
    return _loggedFoodBox.values.where((loggedFood) {
      final loggedDate = DateTime(loggedFood.loggedTime.year, loggedFood.loggedTime.month, loggedFood.loggedTime.day);
      return loggedDate == date;
    }).toList();
  }

  Map<String, double> calculateDailyMacros(DateTime date) {
    final dailyIntakes = getIntakesForDay(date);

    double totalCalories = 0;
    double totalCarbohydrates = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalSodium = 0;
    double totalCholesterol = 0;

    for (var loggedFood in dailyIntakes) {
      totalCalories += (loggedFood.foodItem.calories / 100) * loggedFood.quantity;
      totalCarbohydrates += (loggedFood.foodItem.carbohydrates / 100) * loggedFood.quantity;
      totalProtein += (loggedFood.foodItem.protein / 100) * loggedFood.quantity;
      totalFat += (loggedFood.foodItem.fat / 100) * loggedFood.quantity;
      totalSodium += (loggedFood.foodItem.sodium / 100) * loggedFood.quantity;
      totalCholesterol += (loggedFood.foodItem.cholesterol / 100) * loggedFood.quantity;
    }

    return {
      'calories': totalCalories,
      'carbohydrates': totalCarbohydrates,
      'protein': totalProtein,
      'fat': totalFat,
      'sodium': totalSodium,
      'cholesterol': totalCholesterol,
    };
  }
}
