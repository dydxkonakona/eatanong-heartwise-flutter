import 'package:hive/hive.dart';

part 'daily_totals.g.dart'; 

@HiveType(typeId: 3)
class DailyTotals extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  double totalCalories;

  @HiveField(2)
  double totalFat;

  @HiveField(3)
  double totalProtein;

  @HiveField(4)
  double totalCarbohydrates;

  @HiveField(5)
  double totalSodium;

  @HiveField(6)
  double totalCholesterol;

  DailyTotals({
    required this.date,
    this.totalCalories = 0,
    this.totalFat = 0,
    this.totalProtein = 0,
    this.totalCarbohydrates = 0,
    this.totalSodium = 0,
    this.totalCholesterol = 0,
  });
}
