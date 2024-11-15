import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:final_eatanong_flutter/models/exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  final Box<Exercise> _exerciseBox = Hive.box<Exercise>('exerciseBox');
  List<Exercise> _filteredExercises = [];

  List<Exercise> get exercises => _exerciseBox.values.toList();
  List<Exercise> get filteredExercises => _filteredExercises.isEmpty ? exercises : _filteredExercises;

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
    notifyListeners();
  }

  void updateExercise(int index, Exercise updatedExercise) {
    _exerciseBox.putAt(index, updatedExercise);
    notifyListeners();
  }

  void deleteExercise(int index) {
    _exerciseBox.deleteAt(index);
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
}
