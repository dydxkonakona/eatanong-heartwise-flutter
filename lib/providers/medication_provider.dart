import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/medication_reminder.dart';

class MedicationProvider with ChangeNotifier {
  final Box<MedicationReminder> _medicationBox = Hive.box<MedicationReminder>('medicationBox');

  // Get all medication reminders
  List<MedicationReminder> getAllMedicationReminders() {
    return _medicationBox.values.toList();
  }

  // Get medication reminders for a specific day
  List<MedicationReminder> getMedicationRemindersForDay(DateTime date) {
    return _medicationBox.values.where((reminder) =>
      reminder.time.year == date.year &&
      reminder.time.month == date.month &&
      reminder.time.day == date.day
    ).toList();
  }

  // Add a medication reminder
  void addMedicationReminder(MedicationReminder reminder) {
    _medicationBox.add(reminder);
    notifyListeners();
  }

  // Delete a medication reminder
  void deleteMedicationReminder(int index) {
    _medicationBox.deleteAt(index);
    notifyListeners();
  }

  // Toggle the medication taken status and remove it from the list if taken
  void toggleMedicationTakenStatus(int index) {
    final reminder = _medicationBox.getAt(index);
    if (reminder != null) {
      reminder.isTaken = !reminder.isTaken;
      if (reminder.isTaken) {
        // Remove the medication from the box if taken
        _medicationBox.deleteAt(index);
      } else {
        reminder.save();  // Save it back if not taken
      }
      notifyListeners();
    }
  }

  // Function to classify medication status based on its taken status
  Map<String, dynamic> classifyMedicationStatus(MedicationReminder reminder) {
    if (reminder.isTaken) {
      return {
        'message': 'Medication Not Completed',
        'color': const Color.fromARGB(255, 0, 204, 0) // Green for taken
      };
    } else {
      return {
        'message': 'Medication Not Taken',
        'color': const Color.fromARGB(255, 255, 0, 0) // Red for not taken
      };
    }
  }

  // Method to classify the latest medication reminder
  Map<String, dynamic> classifyLatestMedicationReminder() {
    // Get the latest medication reminder (most recent entry)
    if (_medicationBox.isEmpty) {
      return {
        'message': "No medication reminder set.",
        'color': const Color.fromARGB(255, 128, 128, 128) // Default color (grey)
      };
    }

    // Get the latest reminder (last one added)
    final latestReminder = _medicationBox.values.last;

    // Classify the latest reminder based on whether it was taken
    return classifyMedicationStatus(latestReminder);
  }
}
