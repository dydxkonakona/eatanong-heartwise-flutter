import 'package:final_eatanong_flutter/models/person.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PersonProvider extends ChangeNotifier {
  final Box<Person> _personBox = Hive.box<Person>('personBox');

  // Getter to retrieve all persons stored in Hive
  List<Person> get persons => _personBox.values.toList();

  // Add person method
  void addPerson(Person person) {
    // Store the person in the Hive box
    _personBox.add(person);
    // Notify listeners to update the UI
    notifyListeners();
  }

  // Delete person method
  void deletePerson(int index) {
    _personBox.deleteAt(index);
    notifyListeners();
  }
}
