import 'package:hive/hive.dart';

part 'logged_food.g.dart'; 

@HiveType(typeId: 2)
class LoggedFood extends HiveObject {
  @HiveField(0)
  final String foodName;

  @HiveField(1)
  final double quantity; // In grams or any unit

  @HiveField(2)
  final DateTime date;

  LoggedFood({required this.foodName, required this.quantity, required this.date});
}
