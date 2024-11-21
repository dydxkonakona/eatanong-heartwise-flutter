import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/models/logged_food.dart';

class FoodProvider extends ChangeNotifier {
  final Box<FoodItem> _foodBox = Hive.box<FoodItem>('foodBox');
  final Box<LoggedFood> _loggedFoodBox = Hive.box<LoggedFood>('loggedFoodBox');

  List<FoodItem> _filteredFoods = [];

  List<FoodItem> get foods => _foodBox.values.toList();
  List<FoodItem> get filteredFoods => _filteredFoods.isEmpty ? foods : _filteredFoods;

  FoodProvider() {
    _initializePresetData();
  }

  Future<void> _initializePresetData() async {
    if (_foodBox.isEmpty) {
      try {
        final data = await rootBundle.loadString('assets/food_data.json');
        print("JSON Data Loaded: $data");

        List<dynamic> jsonData = jsonDecode(data);
        print("Total items in JSON: ${jsonData.length}");

        for (var item in jsonData) {
          try {
            final food = FoodItem(
              name: item['Food Name'] ?? 'Unknown', // Default value if null
              calories: safeParse(item['Calories(kcal)']?.toString() ?? '0'), // Fallback if null
              protein: safeParse(item['Protein(g)']?.toString() ?? '0'),
              fat: safeParse(item['Total Fat(g)']?.toString() ?? '0'),
              carbohydrates: safeParse(item['Carbohydrates(g)']?.toString() ?? '0'),
              sodium: safeParse(item['Sodium(mg)']?.toString() ?? '0'),
              cholesterol: safeParse(item['Cholesterol (mg)']?.toString() ?? '0'),
            );

            _foodBox.add(food);
            print("Added food: ${food.name}");
          } catch (e) {
            print("Error parsing food item: ${item['Food Name']}");
            print("Error: $e");
          }
        }

        printFoodItems(); // Function to log food items in Hive

        notifyListeners();
      } catch (e) {
        print("Error loading preset data: $e");
      }
    } else {
      print("FoodBox is not empty.");
    }
  }


  double safeParse(String value) {
    if (value.isEmpty || value == "-" || value == "NaN") return 0.0; // Treat "-" and NaN as 0.0
    try {
      return double.parse(value);
    } catch (e) {
      print("Failed to parse '$value': $e");
      return 0.0; // Default value if parsing fails
    }
  }

  // Function to log all items in the FoodBox
  void printFoodItems() {
    final foods = _foodBox.values.toList();
    for (var food in foods) {
      print("Food in Hive: ${food.name}"); // Log each food item
    }
  }

  void addFood(FoodItem food) {
    _foodBox.add(food);
    notifyListeners();
  }

  void deleteFood(BuildContext context, FoodItem foodItem) {
    final index = _foodBox.values.toList().indexOf(foodItem);
    if (index != -1) {
      _foodBox.deleteAt(index);
      notifyListeners();

      // // Show a Snackbar confirming the deletion
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${foodItem.name} has been deleted.'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    } else {
      print("FoodItem not found in the box.");
    }
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
    // Normalize date for comparison
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
