import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';

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
}
