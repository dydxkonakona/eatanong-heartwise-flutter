import 'package:final_eatanong_flutter/models/person.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/exercise.dart';

part 'logged_exercise.g.dart';

@HiveType(typeId: 4) // Assign a unique typeId for the LoggedExercise model
class LoggedExercise {
  @HiveField(0)
  final double duration; // Duration in minutes

  @HiveField(1)
  final DateTime loggedTime;

  @HiveField(2)
  final Exercise exercise; // Reference to Exercise model

  // Reference to the Person (you may pass the person or access via a provider)
  @HiveField(3)
  final Person person;

  LoggedExercise({
    required this.duration,
    required this.loggedTime,
    required this.exercise,
    required this.person,
  });

  // Getter to calculate calories burned
  double get caloriesBurned {
    return exercise.calculateCaloriesBurned(person.weight, duration); // Example weight 70 kg
  }

  double calculateCaloriesBurned(double weightInKg) {
    // Calories burned = MET * weight * duration (in hours)
    return exercise.calculateCaloriesBurned(weightInKg, duration);
  }
}
