import 'package:final_eatanong_flutter/models/person.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PersonProvider extends ChangeNotifier {
  /*This line creates a new instance of a Box (a type of data storage) named _personBox that is specific to storing Person objects.
   The Hive.box method is used to create the box, and 'personBox' is the name of the box.
   The final keyword means that the _personBox variable cannot be reassigned to a different value.*/
  final Box<Person> _personBox = Hive.box<Person>('personBox');
  
  /* This line defines a getter method named persons that returns a list of all Person objects stored in the _personBox.
   The get keyword is used to define a getter method, which is a method that returns a value without taking any arguments.
   The => symbol is used to define a concise getter method that simply returns the result of the expression on the right-hand side.
   _personBox.values returns a iterable of all values stored in the box, and toList() converts that iterable to a list.*/
  List<Person> get persons => _personBox.values.toList();

  /*
    This line defines a method named addPerson that takes a single argument of type Person.
    The void return type means that this method does not return any value.
  */
  void addPerson(Person person) {
    // This line adds the person object passed as an argument to the _personBox.
    _personBox.add(person);
    // This line notifies any listeners that the data managed by this class has changed.
    notifyListeners();
  }

  /*
    This line defines a method named deletePerson that takes a single argument of type int, 
    which represents the index of the Person object to delete.
  */
  void deletePerson(int index) {
    // This line deletes the Person object at the specified index from the _personBox.
    _personBox.deleteAt(index);
    // This line notifies any listeners that the data managed by this class has changed.
    notifyListeners();
  }
}