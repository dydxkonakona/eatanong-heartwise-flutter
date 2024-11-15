import "package:hive/hive.dart";

part "exercise.g.dart";

@HiveType(typeId: 3) // Assign a unique typeId for the Exercise model
class Exercise {
  Exercise({
    required this.name,
    required this.metValue,
  });

  @HiveField(0)
  String name; // Exercise name

  @HiveField(1)
  double metValue; // MET value for the exercise

  // Computed property to calculate calories burned
  // Calories burned=MET value × weight in kg × duration in hours
  double calculateCaloriesBurned(double weightInKg, double durationInMins) {
    return metValue * weightInKg * (durationInMins / 60);
  }
}
