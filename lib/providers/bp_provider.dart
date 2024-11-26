import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/blood_pressure.dart';

class BloodPressureProvider with ChangeNotifier {
  final Box<BloodPressure> _bloodPressureBox = Hive.box<BloodPressure>('bloodPressureBox');

  // Get all blood pressure readings for a specific day
  List<BloodPressure> getBloodPressuresForDay(DateTime date) {
    return _bloodPressureBox.values.where((reading) =>
      reading.date.year == date.year &&
      reading.date.month == date.month &&
      reading.date.day == date.day
    ).toList();
  }

  // Add a new blood pressure reading
  void addBloodPressure(BloodPressure reading) {
    _bloodPressureBox.add(reading);
    notifyListeners();
  }

  // Delete a blood pressure reading
  Future<void> deleteBloodPressure(int index) async {
    _bloodPressureBox.deleteAt(index);
    notifyListeners();
  }
}
