import 'package:hive/hive.dart';

part 'water_intake.g.dart';

@HiveType(typeId: 5)
class WaterIntake {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double amount; // in milliliters

  WaterIntake({required this.date, required this.amount});
}
