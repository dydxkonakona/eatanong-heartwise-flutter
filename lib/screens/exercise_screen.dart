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
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
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
                  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 251, 98, 98)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                onChanged: (query) {
                  exerciseProvider.searchExercise(query);
                },
              ),
            ),
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
                            onPressed: () => _deleteExercise(context, exerciseProvider, index),
                          ),
                          onTap: () => _showExerciseDetails(context, exercise),
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
                    color: Color.fromARGB(255, 251, 98, 98), // Match with the theme color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16), // Add some space between title and fields
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.fitness_center, color: Color.fromARGB(255, 251, 98, 98)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
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
                    prefixIcon: Icon(Icons.accessibility_new, color: Color.fromARGB(255, 251, 98, 98)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
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
                        backgroundColor: Color.fromARGB(255, 251, 98, 98), // Custom button color
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
  void _showExerciseDetails(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: Text('MET Value: ${exercise.metValue}\nCalories Burned: ${exercise.calculateCaloriesBurned(70, 5).toStringAsFixed(2)}'),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
