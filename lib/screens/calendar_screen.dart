import 'package:final_eatanong_flutter/models/logged_exercise.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/providers/food_ai.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    
    // water stuff
    final waterProvider = Provider.of<WaterProvider>(context);
    final loggedWaterIntakes = waterProvider.getWaterIntakesForDay(normalizedSelectedDay);
    final totalWaterIntake = waterProvider.calculateTotalWaterIntake(normalizedSelectedDay);

    // Calculate total macros for the selected day
    final dailyMacros = foodProvider.calculateDailyMacros(normalizedSelectedDay);
    // Calculate total calories burned for the selected day (pass weight in kg)
    final dailyCaloriesBurned = exerciseProvider.calculateDailyCaloriesBurned(normalizedSelectedDay, weightInKg); // Example: 70 kg user weight

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
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
                    const SizedBox(height: 16),
                    Text('Logged Foods for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildLoggedFoods(loggedFoods), // Display logged foods for the selected day
                    const SizedBox(height: 16),
                    _buildTotalMacros(dailyMacros), // Display total macros for the selected day
                    const SizedBox(height: 16),
                    Container(
                      height: 5.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFFF6363), Color.fromARGB(255, 255, 198, 198)], // Custom gradient
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Logged Exercises for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildLoggedExercises(loggedExercises), // Display logged exercises for the selected day
                    const SizedBox(height: 16),
                    _buildTotalCaloriesBurned(dailyCaloriesBurned), // Display total calories burned for the selected day
                    const SizedBox(height: 16),
                    Container(
                      height: 5.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFFF6363), Color.fromARGB(255, 255, 198, 198)], // Custom gradient
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Logged Water Intake for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildLoggedWaterIntakes(loggedWaterIntakes), // New widget for water intake
                    const SizedBox(height: 16),
                    _buildTotalWaterIntake(totalWaterIntake), // Display total water intake
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
          _imageClassifier.classifyImageFromCamera();
        },
        tooltip: 'Add Food',
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Customize your button color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Image.asset('assets/logo.png'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 50.0, // Set your desired height here
        child: BottomAppBar(
          color: Color.fromARGB(255, 255, 198, 198),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pop(context);
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
        child: Text('No food logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return SizedBox(
      height: loggedFoods.length > 3 ? 300.0 : 200.0, // Dynamically adjust height based on list length
      child: ListView.builder(
        itemCount: loggedFoods.length,
        itemBuilder: (context, index) {
          final loggedFood = loggedFoods[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              elevation: 4.0, // Shadow effect
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out content vertically
                  children: [
                    // Food name at the top
                    Text(
                      loggedFood.foodItem.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Prevent overflow if the text is too long
                      maxLines: 2,
                    ),
                    SizedBox(height: 8), // Add space between the food name and details

                    // Quantity and Calories information at the bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0), // Space between text elements
                          child: Text(
                            'Quantity: ${loggedFood.quantity.toStringAsFixed(1)} g',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          'Calories: ${loggedFood.totalCalories.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Carbohydrates: ${loggedFood.totalCarbohydrates.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Protein: ${loggedFood.totalProtein.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Fat: ${loggedFood.totalFat.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Sodium: ${loggedFood.totalSodium.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Cholesterol: ${loggedFood.totalCholesterol.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),

                    // Delete button at the bottom-right corner
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Delete the logged food
                          Provider.of<FoodProvider>(context, listen: false)
                              .deleteLoggedFood(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
          Text('Total Nutrients for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          _buildMacroRow('Calories (kcal)', dailyMacros['calories']),
          _buildMacroRow('Carbohydrates (g)', dailyMacros['carbohydrates']),
          _buildMacroRow('Protein (g)', dailyMacros['protein']),
          _buildMacroRow('Fat (g)', dailyMacros['fat']),
          _buildMacroRow('Sodium (mg)', dailyMacros['sodium']),
          _buildMacroRow('Cholesterol (mg)', dailyMacros['cholesterol']),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value != null ? value.toStringAsFixed(1) : '0.0', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLoggedExercises(List<LoggedExercise> loggedExercises) {
    if (loggedExercises.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No exercise logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return SizedBox(
      height: loggedExercises.length > 3 ? 300.0 : 200.0, // Dynamically adjust height based on list length
      child: ListView.builder(
        itemCount: loggedExercises.length,
        itemBuilder: (context, index) {
          final loggedExercise = loggedExercises[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 3, // Adds a slight shadow to each card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners for a clean look
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out content vertically
                  children: [
                    // Exercise name
                    Text(
                      loggedExercise.exercise.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Truncate long names
                      maxLines: 2,
                    ),
                    SizedBox(height: 8), // Add space between name and details

                    // Exercise details (Duration and Calories Burned) at the bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0), // Space between text elements
                          child: Text(
                            'Duration: ${loggedExercise.duration.toStringAsFixed(0)} min',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          'Calories Burned: ${loggedExercise.caloriesBurned.toStringAsFixed(1)} kcal',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),

                    // Delete button at the bottom-right corner
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Delete the logged exercise
                          Provider.of<ExerciseProvider>(context, listen: false)
                              .deleteLoggedExercise(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
          _buildMacroRow('Calories Burned', dailyCaloriesBurned['calories_burned']),
        ],
      ),
    );
  }

  Widget _buildLoggedWaterIntakes(List<WaterIntake> loggedWaterIntakes) {
    if (loggedWaterIntakes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No water intake logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return SizedBox(
      height: loggedWaterIntakes.length > 3 ? 300.0 : 200.0,
      child: ListView.builder(
        itemCount: loggedWaterIntakes.length,
        itemBuilder: (context, index) {
          final loggedWater = loggedWaterIntakes[index];

          // Format the date and time
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(loggedWater.date);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 3, // Consistent elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners for consistency
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                  children: [
                    // Display water amount
                    Text(
                      '${loggedWater.amount.toStringAsFixed(1)} ml',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8), // Space between amount and date/time

                    // Display formatted date and time
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    // Delete button at the bottom-right corner
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Remove the water intake at the specified index
                          Provider.of<WaterProvider>(context, listen: false)
                              .deleteWaterIntake(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalWaterIntake(double totalWaterIntake) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Water Intake for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          _buildMacroRow('Water Intake (ml)', totalWaterIntake),
        ],
      ),
    );
  }


}
