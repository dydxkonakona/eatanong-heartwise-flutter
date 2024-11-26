import 'package:hive/hive.dart';

part 'blood_pressure.g.dart';

@HiveType(typeId: 7)
class BloodPressure {
  @HiveField(0)
  final DateTime date; // Date of the reading

  @HiveField(1)
  final double systolic; // Systolic value

  @HiveField(2)
  final double diastolic; // Diastolic value

  BloodPressure({
    required this.date,
    required this.systolic,
    required this.diastolic,
  });
}
