import 'package:final_eatanong_flutter/models/logged_exercise.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/providers/food_ai.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class DietLogScreen extends StatefulWidget {
  @override
  _DietLogScreenState createState() => _DietLogScreenState();
}

class _DietLogScreenState extends State<DietLogScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ImageClassifier _imageClassifier;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _imageClassifier = ImageClassifier(context);
  }

  @override
  void dispose() {
    _imageClassifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    // Normalize _selectedDay for date comparison
    DateTime normalizedSelectedDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final loggedFoods = foodProvider.getIntakesForDay(normalizedSelectedDay); // Get logged foods for the selected day
    final loggedExercises = exerciseProvider.getLoggedExercisesForDay(normalizedSelectedDay); // Get logged exercises for the selected day
    final personProvider = Provider.of<PersonProvider>(context); // Access PersonProvider
    final weightInKg = personProvider.persons.isNotEmpty ? personProvider.persons[0].weight : 70.0; // Default to 70 if no person is found

    // Calculate total macros for the selected day
    final dailyMacros = foodProvider.calculateDailyMacros(normalizedSelectedDay);
     // Calculate total calories burned for the selected day (pass weight in kg)
    final dailyCaloriesBurned = exerciseProvider.calculateDailyCaloriesBurned(normalizedSelectedDay, weightInKg); // Example: 70 kg user weight

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Diet Log'),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),
      ),
      drawer: NavBar(),
      body: SafeArea( // SafeArea to avoid overlaps with system UI (e.g., notches)
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 16),
            Expanded( // Ensure this section can expand and contract based on screen size
              child: SingleChildScrollView( // Ensure scrolling if content is too large
                child: Column(
                  children: [
                    _buildLoggedFoods(loggedFoods), // Display logged foods for the selected day
                    const SizedBox(height: 16),
                    _buildTotalMacros(dailyMacros), // Display total macros for the selected day
                    const SizedBox(height: 16),
                    _buildLoggedExercises(loggedExercises), // Display logged exercises for the selected day
                    const SizedBox(height: 16),
                    _buildTotalCaloriesBurned(dailyCaloriesBurned), // Display total calories burned for the selected day
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imageClassifier.classifyImageFromCamera(); // Start image classification
        },
        tooltip: 'Add Food',
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Customize your button color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Image.asset('assets/logo.png'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 50.0,
        child: BottomAppBar(
          color: Color.fromARGB(255, 255, 198, 198),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Handle home button press
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/user profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: const Color.fromARGB(255, 255, 171, 165), shape: BoxShape.circle),
        cellMargin: EdgeInsets.all(6.0),
        defaultTextStyle: TextStyle(fontSize: 16),
        weekendTextStyle: TextStyle(fontSize: 16, color: Colors.redAccent),
      ),
      rowHeight: 45,
    );
  }

  Widget _buildLoggedFoods(List loggedFoods) {
    if (loggedFoods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No food logged for this day.'),
      );
    }

    return SizedBox(
      height: 200.0, // Set a fixed height for the ListView to fit within the scrollable area
      child: ListView.builder(
        itemCount: loggedFoods.length,
        itemBuilder: (context, index) {
          final loggedFood = loggedFoods[index];
          return ListTile(
            title: Text(loggedFood.foodItem.name),
            subtitle: Text('Quantity: ${loggedFood.quantity}g | Calories: ${loggedFood.totalCalories}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the logged food
                Provider.of<FoodProvider>(context, listen: false).deleteLoggedFood(index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalMacros(Map<String, double> dailyMacros) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Macros for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text('Calories: ${dailyMacros['calories']?.toStringAsFixed(1)} kcal'),
          Text('Carbohydrates: ${dailyMacros['carbohydrates']?.toStringAsFixed(1)} g'),
          Text('Protein: ${dailyMacros['protein']?.toStringAsFixed(1)} g'),
          Text('Fat: ${dailyMacros['fat']?.toStringAsFixed(1)} g'),
          Text('Sodium: ${dailyMacros['sodium']?.toStringAsFixed(1)} mg'),
          Text('Cholesterol: ${dailyMacros['cholesterol']?.toStringAsFixed(1)} mg'),
        ],
      ),
    );
  }
Widget _buildLoggedExercises(List<LoggedExercise> loggedExercises) {
    if (loggedExercises.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No exercise logged for this day.'),
      );
    }

    return SizedBox(
      height: 200.0, // Set a fixed height for the ListView
      child: ListView.builder(
        itemCount: loggedExercises.length,
        itemBuilder: (context, index) {
          final loggedExercise = loggedExercises[index];
          return ListTile(
            title: Text(loggedExercise.exercise.name),
            subtitle: Text('Duration: ${loggedExercise.duration} min | Calories Burned: ${loggedExercise.caloriesBurned.toStringAsFixed(1)} kcal'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the logged exercise
                Provider.of<ExerciseProvider>(context, listen: false).deleteLoggedExercise(index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalCaloriesBurned(Map<String, double> dailyCaloriesBurned) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Calories Burned for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text('Calories Burned: ${dailyCaloriesBurned['calories_burned']?.toStringAsFixed(1)} kcal'),
        ],
      ),
    );
  }
}
