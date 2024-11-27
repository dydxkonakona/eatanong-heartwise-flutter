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

    // Function to classify blood pressure based on the systolic and diastolic values
  Map<String, dynamic> classifyBloodPressure(double systolic, double diastolic) {
    // Step 1: Input validation
    if (systolic < 0 || diastolic < 0) {
      return {
        'message': 'Invalid Blood Pressure Reading: Blood pressure cannot be negative.',
        'color': Color.fromARGB(255, 128, 128, 128)
      };
    }

    // Step 2: Hypertensive Crisis
    if (systolic > 180 || diastolic > 120) {
      return {
        'message': 'HYPERTENSIVE CRISIS (consult your doctor immediately)',
        'color': Color.fromARGB(255, 153, 7, 17)
      };
    }

    // Step 3: High Blood Pressure (Hypertension) Stage 2
    if (systolic >= 140 || diastolic >= 90) {
      return {
        'message': 'HIGH BLOOD PRESSURE (HYPERTENSION) STAGE 2',
        'color': Color.fromARGB(255, 187, 58, 1)
      };
    }

    // Step 4: High Blood Pressure (Hypertension) Stage 1
    if ((systolic >= 130 && systolic <= 139) || (diastolic >= 80 && diastolic <= 89)) {
      return {
        'message': 'HIGH BLOOD PRESSURE (HYPERTENSION) STAGE 1',
        'color': Color.fromARGB(255, 255, 182, 0)
      };
    }

    // Step 5: Elevated Blood Pressure
    if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      return {
        'message': 'ELEVATED',
        'color': Color.fromARGB(255, 255, 236, 1)
      };
    }

    // Step 6: Normal Blood Pressure
    if (systolic < 120 && diastolic < 80) {
      return {
        'message': 'NORMAL',
        'color': Color.fromARGB(255, 166, 206, 57)
      };
    }

    // Step 7: If no category matches (which shouldn't happen with valid input)
    return {
      'message': 'Invalid Blood Pressure Reading: Unexpected input.',
      'color': Color.fromARGB(255, 128, 128, 128)
    };
  }

  // Method to classify the latest blood pressure reading
  Map<String, dynamic> classifyLatestBloodPressure() {
    // Get the latest blood pressure reading (most recent entry)
    if (_bloodPressureBox.isEmpty) {
      return {
        'message': "No blood pressure readings found.",
        'color': Color.fromARGB(255, 128, 128, 128) // Default color (grey)
      };
    }


    // Get the latest reading (last one added)
    final latestReading = _bloodPressureBox.values.last;

    // Classify the latest reading
    return classifyBloodPressure(latestReading.systolic, latestReading.diastolic);
  }

}
