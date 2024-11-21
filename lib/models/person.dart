import 'package:hive/hive.dart';

// The part directive generates the necessary serialization code
part 'person.g.dart';

// Mark the Person class for Hive serialization
@HiveType(typeId: 0)
class Person {
  // Constructor now takes a birthdate instead of age
  Person({
    required this.name,
    required this.birthdate,  // Replacing age with birthdate
    required this.gender,
    required this.weight,
    required this.height,
  });

  @HiveField(0)
  String name;

  // Change 'age' to 'birthdate' (type DateTime)
  @HiveField(1)
  DateTime birthdate; // Birthdate is now stored

  @HiveField(2)
  String gender;

  @HiveField(3)
  double weight;

  @HiveField(4)
  double height;

  // Getter to calculate age from the birthdate
  int get age {
    final today = DateTime.now();
    final difference = today.difference(birthdate);
    return (difference.inDays / 365.25).floor(); // Calculate age in years
  }
}
