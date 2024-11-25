import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/models/exercise.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/services.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 222, 174, 255), // Custom color for AppBar
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddExerciseDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding around the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search field with custom focused border
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Exercises',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 177, 60, 255)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 222, 174, 255)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                onChanged: (query) {
                  exerciseProvider.searchExercise(query);
                },
              ),
            ),
            Text(
              'Calories burned calculated based on METs. Calories burned = METs * Weight (kg) * Time (minutes)/60',
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            // List of exercises
            Expanded(
              child: Consumer<ExerciseProvider>(
                builder: (context, provider, _) {
                  // Sort exercises alphabetically before displaying
                  final exercises = List<Exercise>.from(provider.filteredExercises);
                  exercises.sort((a, b) => a.name.compareTo(b.name)); // Sorting alphabetically

                  if (exercises.isEmpty) {
                    return Center(
                      child: Text(
                        'No exercises found.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final mainIndex = provider.exercises.indexOf(exercise); // Get the corresponding index in the main list

                      return Card(
                        margin: EdgeInsets.only(bottom: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          title: Text(
                            exercise.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('MET: ${exercise.metValue}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteExercise(context, provider, mainIndex), // Use the correct index
                          ),
                          onTap: () => _showExerciseDetails(
                            context, 
                            exercise, 
                            Provider.of<PersonProvider>(context, listen: false)
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const NavBar(),
    );
  }

  // Add Exercise Dialog
  void _showAddExerciseDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController metController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for the dialog
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the dialog content
          child: SingleChildScrollView( // Make content scrollable to avoid overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Exercise',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 177, 60, 255), // Match with the theme color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16), // Add some space between title and fields
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.fitness_center, color: Color.fromARGB(255, 177, 60, 255)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 222, 174, 255)),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 16), // Add space between fields
                TextField(
                  controller: metController,
                  decoration: InputDecoration(
                    labelText: 'MET Value',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.accessibility_new, color: Color.fromARGB(255, 177, 60, 255)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 222, 174, 255)),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))], // Allow numbers and decimals only
                ),
                SizedBox(height: 24), // Add space between the last input and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final met = double.tryParse(metController.text.trim()) ?? 0.0;

                        if (name.isNotEmpty && met > 0) {
                          Provider.of<ExerciseProvider>(context, listen: false).addExercise(
                            Exercise(name: name, metValue: met),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all fields properly')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 177, 60, 255), // Custom button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded button corners
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete Exercise
  void _deleteExercise(BuildContext context, ExerciseProvider provider, int index) {
    provider.deleteExercise(index);

    // Show SnackBar at the top when exercise is deleted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exercise deleted!'),
        behavior: SnackBarBehavior.floating, // Custom positioning
        margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Show Exercise Details
  void _showExerciseDetails(
      BuildContext context, Exercise exercise, PersonProvider personProvider) {
    // Get the weight of the first person (adjust logic if needed for multiple persons)
    double weight = personProvider.persons.isNotEmpty
        ? personProvider.persons.first.weight
        : 70; // Default weight if none available

    final TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for the dialog
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the dialog content
          child: SingleChildScrollView( // Make content scrollable to avoid overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 177, 60, 255), // Match with the theme color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8), // Add some space between title and details
                Text('MET Value: ${exercise.metValue}', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  'based on 2024 Adult Compendium of Physical Activities',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),),
                SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter duration (minutes)',
                    hintText: 'e.g., 30',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.timer, color: Color.fromARGB(255, 177, 60, 255)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 222, 174, 255)),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))], // Allow only numbers and decimals
                ),
                SizedBox(height: 24), // Space between the input field and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final double? duration = double.tryParse(durationController.text);
                        if (duration != null) {
                          _showLogOrCloseDialog(context, exercise, weight, duration, personProvider.persons.first);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 177, 60, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Log or Close Dialog
  void _showLogOrCloseDialog(BuildContext context, Exercise exercise, double weight, double duration, Person person) {
    final double caloriesBurned = exercise.calculateCaloriesBurned(weight, duration);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Calories Burned',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 177, 60, 255),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'You burned ${caloriesBurned.toStringAsFixed(2)} calories.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Log the exercise action here, such as saving it to the database or other actions.
                      var exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
                      if (duration > 0) {
                        exerciseProvider.addLoggedExercise(exercise, duration, person);
                      }
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/calendar");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Calories burned added successfully!'),
                            behavior: SnackBarBehavior.floating, // Custom positioning
                            margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green, // Green color for success
                          ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 177, 60, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Log Exercise',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
