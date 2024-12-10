import 'package:hive/hive.dart';

part 'medication_reminder.g.dart';

@HiveType(typeId: 6)
class MedicationReminder extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String dosage;

  @HiveField(2)
  DateTime time;

  @HiveField(3)
  bool isTaken;

  @HiveField(4)
  String? specialInstructions;

  @HiveField(5)
  DateTime? takenTimestamp;  // New field to track when the medication was taken

  MedicationReminder({
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
    this.specialInstructions,
    this.takenTimestamp,  // New field in the constructor
  });

  // Method to mark the medication as taken and store the time
  void markAsTaken() {
    isTaken = true;
    takenTimestamp = DateTime.now();  // Store the current time when medication is taken
  }
}
