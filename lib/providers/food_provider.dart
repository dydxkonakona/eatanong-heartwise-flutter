import 'package:final_eatanong_flutter/models/food.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FoodProvider extends ChangeNotifier {
  final Box<Food> _foodBox = Hive.box<Food>('foodBox');

  List<Food> get foods => _foodBox.values.toList();

  void addFood(Food food) {
    _foodBox.add(food);
    notifyListeners();
  }

  void deleteFood(int index) {
    _foodBox.deleteAt(index);
    notifyListeners();
  }
}