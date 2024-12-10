import 'package:final_eatanong_flutter/models/logged_exercise.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/bp_provider.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/providers/food_ai.dart';
import 'package:final_eatanong_flutter/providers/medication_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:final_eatanong_flutter/screens/bp_screen.dart';
import 'package:final_eatanong_flutter/screens/exercise_screen.dart';
import 'package:final_eatanong_flutter/screens/medication_screen.dart';
import 'package:final_eatanong_flutter/screens/selection_screen.dart';
import 'package:final_eatanong_flutter/screens/water_logger_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class DietLogScreen extends StatefulWidget {
  const DietLogScreen({super.key});

  @override
  _DietLogScreenState createState() => _DietLogScreenState();
}

class _DietLogScreenState extends State<DietLogScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ImageClassifier _imageClassifier;
  
  get waterProvider => null;

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

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    DateTime normalizedSelectedDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final loggedFoods = foodProvider.getIntakesForDay(normalizedSelectedDay);
    final dailyMacros = foodProvider.calculateDailyMacros(normalizedSelectedDay);

    final bloodPressureProvider = Provider.of<BloodPressureProvider>(context);
    final bloodPressureClass = bloodPressureProvider.classifyLatestBloodPressure();

    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    final weightInKg = personProvider.persons.isNotEmpty ? personProvider.persons[0].weight : 70.0;
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final exerciseClass = exerciseProvider.calculateDailyCaloriesBurned(normalizedSelectedDay, weightInKg);

    final waterProvider = Provider.of<WaterProvider>(context);

    final loggedExercises = exerciseProvider.getLoggedExercisesForDay(normalizedSelectedDay);
    final loggedWaterIntakes = waterProvider.getWaterIntakesForDay(normalizedSelectedDay);

    final medicationClass = Provider.of<MedicationProvider>(context).classifyLatestMedicationReminder();


    String caloriesBurnedString = (exerciseClass['calories_burned'] ?? 0.0).toStringAsFixed(2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      drawer: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BloodPressureScreen()),
                        );
                      },
                      child: CustomCard(
                        title: 'Blood Pressure',
                        status: bloodPressureClass['message'], // Display message from classification
                        color: bloodPressureClass['color'], // Set color from classification
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WaterLoggerScreen()),
                        );
                      },
                      child: CustomCard(
                        title: 'Water Intake',
                        status: waterProvider.getWaterIntakeProgress(context, normalizedSelectedDay), // Display message from classification
                        color: const Color.fromARGB(255, 1, 196, 255), // Set color from classification
                      ),
                    ),
                      GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExerciseScreen()),
                        );
                      },
                      child: CustomCard(
                        title: 'Calories Burned',
                        status: '$caloriesBurnedString kcal', // Display message from classification
                        color: const Color.fromARGB(255, 177, 60, 255),// Set color from classification
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MedicationLoggerScreen()),
                        );
                      },
                      child: CustomCard(
                        title: 'Medication',
                        status: medicationClass['message'], // Display message from classification
                        color: const Color(0xFF63FFA3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Smooth Page Indicator
              Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blueGrey,
                    dotWidth: 10,
                    dotHeight: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTotalMacros(dailyMacros),
              const Divider(thickness: 1, color: Colors.grey, indent: 20, endIndent: 20),
              const Text('Logged Foods for the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              _buildLoggedFoods(loggedFoods),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Reduced padding
                  backgroundColor: const Color(0xFFFF6363), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Slightly smaller border radius for a sleeker look
                  ),
                  shadowColor: Colors.black.withOpacity(0.15), // Lighter shadow for a more subtle effect
                  elevation: 2, // Slightly lower elevation for a cleaner design
                ),
                child: const Text(
                  "Add Food",
                  style: TextStyle(
                    fontWeight: FontWeight.w600, // Slightly lighter bold font
                    fontSize: 12, // Smaller font size for a more compact button
                    color: Colors.white, // Black text for contrast
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey, indent: 20, endIndent: 20),
              const Center(
                child: Text(
                  'Logged Exercises for the Day', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              _buildLoggedExercises(loggedExercises, exerciseProvider),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExerciseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Reduced padding
                  backgroundColor: const Color.fromARGB(255, 177, 60, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Slightly smaller border radius for a sleeker look
                  ),
                  shadowColor: Colors.black.withOpacity(0.15), // Lighter shadow for a more subtle effect
                  elevation: 2, // Slightly lower elevation for a cleaner design
                ),
                child: const Text(
                  "Add Exercise",
                  style: TextStyle(
                    fontWeight: FontWeight.w600, // Slightly lighter bold font
                    fontSize: 12, // Smaller font size for a more compact button
                    color: Colors.white, // Black text for contrast
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey, indent: 20, endIndent: 20),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Logged Water Intake for the Day', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              _buildLoggedWaterIntakes(loggedWaterIntakes, waterProvider),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WaterLoggerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Reduced padding
                  backgroundColor: const Color.fromARGB(255, 1, 196, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Slightly smaller border radius for a sleeker look
                  ),
                  shadowColor: Colors.black.withOpacity(0.15), // Lighter shadow for a more subtle effect
                  elevation: 2, // Slightly lower elevation for a cleaner design
                ),
                child: const Text(
                  "Add Water",
                  style: TextStyle(
                    fontWeight: FontWeight.w600, // Slightly lighter bold font
                    fontSize: 12, // Smaller font size for a more compact button
                    color: Colors.white, // Black text for contrast
                  ),
                ),
              ),
              const SizedBox(height: 35),
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
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Color.fromARGB(255, 255, 171, 165), shape: BoxShape.circle),
        cellMargin: EdgeInsets.all(6.0),
        defaultTextStyle: TextStyle(fontSize: 16),
        weekendTextStyle: TextStyle(fontSize: 16, color: Colors.redAccent),
      ),
      rowHeight: 45,
    );
  }

  Widget _buildLoggedFoods(List loggedFoods) {
    if (loggedFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No food logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: loggedFoods.map<Widget>((loggedFood) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loggedFood.foodItem.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
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
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        Provider.of<FoodProvider>(context, listen: false)
                            .deleteLoggedFood(loggedFoods.indexOf(loggedFood));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalMacros(Map<String, double> dailyMacros) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Nutrients for the Day',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildMacroRow('Calories (kcal)', dailyMacros['calories'], Colors.black87, null),
              _buildMacroRow('Carbohydrates (g)', dailyMacros['carbohydrates'], Colors.black87, null),
              _buildMacroRow('Protein (g)', dailyMacros['protein'], Colors.black87, null),
              _buildMacroRow('Fat (g)', dailyMacros['fat'], Colors.black87, null),
              _buildMacroRow('Sodium (mg)', dailyMacros['sodium'],
                  dailyMacros['sodium'] != null && dailyMacros['sodium']! > 2300 ? Colors.redAccent : Colors.black87,
                  dailyMacros['sodium'] != null && dailyMacros['sodium']! > 2300 ? "Warning: Sodium intake exceeded 2300mg" : null),
              _buildMacroRow('Cholesterol (mg)', dailyMacros['cholesterol'],
                  dailyMacros['cholesterol'] != null && dailyMacros['cholesterol']! > 200 ? Colors.redAccent : Colors.black87,
                  dailyMacros['cholesterol'] != null && dailyMacros['cholesterol']! > 200 ? "Warning: Cholesterol intake exceeded 200mg" : null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroRow(String label, double? value, Color textColor, String? warningText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                value != null ? value.toStringAsFixed(1) : '0.0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          if (warningText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                warningText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

    Widget _buildLoggedExercises(List<LoggedExercise> loggedExercises, ExerciseProvider exerciseProvider) {
    if (loggedExercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No exercise logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: loggedExercises.map<Widget>((loggedExercise) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3, // Adds a slight shadow to each card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners for a clean look
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out content horizontally
                children: [
                  // Exercise name and details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                      children: [
                        // Exercise name
                        Text(
                          loggedExercise.exercise.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis, // Truncate long names
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8), // Add space between name and details

                        // Exercise details (Duration and Calories Burned)
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
                      ],
                    ),
                  ),

                  // Delete button at the right
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Delete the logged exercise
                        exerciseProvider.deleteLoggedExercise(loggedExercises.indexOf(loggedExercise));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoggedWaterIntakes(List<WaterIntake> loggedWaterIntakes, WaterProvider waterProvider) {
    if (loggedWaterIntakes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No Water intake logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: loggedWaterIntakes.map<Widget>((loggedWater) {
        // Format the date and time
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(loggedWater.date);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display water amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${loggedWater.amount.toStringAsFixed(1)} ml',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      // Display formatted date and time
                      Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      // Remove the water intake at the specified index
                      waterProvider.deleteWaterIntake(loggedWaterIntakes.indexOf(loggedWater));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}

// Custom Card Widget
class CustomCard extends StatelessWidget {
  final String title;
  final String status;
  final Color? color;

  const CustomCard({
    super.key,
    required this.title,
    required this.status,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color ?? Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Increased padding for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,  // Increased font size for the title
                fontWeight: FontWeight.bold,  // Make the title bold
                color: Colors.black,  // White color for good contrast
                letterSpacing: 1.2,  // Slightly increase the letter spacing for readability
              ),
            ),
            const SizedBox(height: 8),  // More space between title and status text
            Text(
              status,
              style: const TextStyle(
                fontSize: 16,  // Slightly smaller font size for status
                fontWeight: FontWeight.bold,  // Medium weight for status text
                color: Colors.black,  // Lighter shade of white for status
                letterSpacing: 1.0,  // Add some letter spacing for clarity
              ),
            ),
          ],
        ),
      ),
    );
  }
}