import 'dart:convert';
import 'package:final_eatanong_flutter/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/exercise.dart';
import 'package:final_eatanong_flutter/models/logged_exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  final Box<Exercise> _exerciseBox = Hive.box<Exercise>('exerciseBox');
  final Box<LoggedExercise> _loggedExerciseBox = Hive.box<LoggedExercise>('loggedExerciseBox');
  List<Exercise> _filteredExercises = [];

  List<Exercise> get exercises => _exerciseBox.values.toList();
  List<Exercise> get filteredExercises => _filteredExercises.isEmpty ? exercises : _filteredExercises;
  List<LoggedExercise> get loggedExercises => _loggedExerciseBox.values.toList();

  ExerciseProvider() {
    _initializePresetData();
  }

  Future<void> _initializePresetData() async {
    if (_exerciseBox.isEmpty) {
      try {
        final data = await rootBundle.loadString('assets/exercise_data.json');
        final List<dynamic> jsonData = jsonDecode(data);

        for (var item in jsonData) {
          try {
            final exercise = Exercise(
              name: item['Exercise name'],
              metValue: _safeParse(item['MET'].toString()),
            );
            _exerciseBox.add(exercise);
          } catch (e) {
            print("Error parsing exercise item: ${item['Exercise name']} - $e");
          }
        }
        notifyListeners();
      } catch (e) {
        print("Error loading exercise preset data: $e");
      }
    }
  }

  double _safeParse(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  void addExercise(Exercise exercise) {
    _exerciseBox.add(exercise);
    _filteredExercises = _exerciseBox.values.toList();
    notifyListeners();
  }

  void updateExercise(int index, Exercise updatedExercise) {
    _exerciseBox.putAt(index, updatedExercise);
    notifyListeners();
  }

  void deleteExercise(int index) {
    _exerciseBox.deleteAt(index);
    _filteredExercises = _exerciseBox.values.toList();

    notifyListeners();
  }

  void searchExercise(String query) {
    if (query.isEmpty) {
      _filteredExercises = [];
    } else {
      _filteredExercises = _exerciseBox.values
          .where((exercise) => exercise.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Add a logged exercise entry
  void addLoggedExercise(Exercise exercise, double duration, Person person) {
    final loggedExercise = LoggedExercise(
      duration: duration,
      loggedTime: DateTime.now(),
      exercise: exercise,
      person: person,
    );

    _loggedExerciseBox.add(loggedExercise);
    notifyListeners();
  }

  // Delete a logged exercise entry
  void deleteLoggedExercise(int index) {
    _loggedExerciseBox.deleteAt(index);
    notifyListeners();
  }

  // Get exercises logged for a specific day
  List<LoggedExercise> getLoggedExercisesForDay(DateTime date) {
    return _loggedExerciseBox.values.where((loggedExercise) {
      final loggedDate = DateTime(loggedExercise.loggedTime.year, loggedExercise.loggedTime.month, loggedExercise.loggedTime.day);
      return loggedDate == date;
    }).toList();
  }

  // Calculate total calories burned on a specific day
  Map<String, double> calculateDailyCaloriesBurned(DateTime date, double weightInKg) {
    final dailyExercises = getLoggedExercisesForDay(date);

    double totalCaloriesBurned = 0;

    for (var loggedExercise in dailyExercises) {
      totalCaloriesBurned += loggedExercise.calculateCaloriesBurned(weightInKg);
    }

    return {
      'calories_burned': totalCaloriesBurned,
    };
  }
}
