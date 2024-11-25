import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/medication_reminder.dart';

class MedicationProvider with ChangeNotifier {
  final Box<MedicationReminder> _medicationBox = Hive.box<MedicationReminder>('medicationBox');

  List<MedicationReminder> getMedicationRemindersForDay(DateTime date) {
    return _medicationBox.values.where((reminder) =>
      reminder.time.year == date.year &&
      reminder.time.month == date.month &&
      reminder.time.day == date.day
    ).toList();
  }

  void addMedicationReminder(MedicationReminder reminder) {
    _medicationBox.add(reminder);
    notifyListeners();
  }

  void deleteMedicationReminder(int index) {
    _medicationBox.deleteAt(index);
    notifyListeners();
  }

  void toggleMedicationTakenStatus(int index) {
    final reminder = _medicationBox.getAt(index);
    if (reminder != null) {
      reminder.isTaken = !reminder.isTaken;
      reminder.save();
      notifyListeners();
    }
  }
}
