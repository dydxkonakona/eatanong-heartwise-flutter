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

  MedicationReminder({
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
  });
}
