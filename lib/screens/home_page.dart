// home_page.dart

import 'package:final_eatanong_flutter/models/logged_exercise.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/bp_provider.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:final_eatanong_flutter/screens/bp_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:final_eatanong_flutter/providers/food_ai.dart'; // Import the classifier
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImageClassifier _imageClassifier;

  @override
  void initState() {
    super.initState();
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

    DateTime date = DateTime.now();
    DateTime dateOnly = DateTime(date.year, date.month, date.day);

    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final waterProvider = Provider.of<WaterProvider>(context);
    final bloodPressureProvider = Provider.of<BloodPressureProvider>(context);
    final bloodPressureClass = bloodPressureProvider.classifyLatestBloodPressure();

    final loggedExercises = exerciseProvider.getLoggedExercisesForDay(dateOnly);
    final loggedWaterIntakes = waterProvider.getWaterIntakesForDay(DateTime.now());

    

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents FAB from moving with the snackbar
      appBar: AppBar(
        title: const Text('Home Page', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Cards in a PageView
              Container(
                height: 200,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BloodPressureScreen()),
                        );
                      },
                      child: CustomCard(
                        title: 'Blood Pressure',
                        status: bloodPressureClass['message'], // Display message from classification
                        color: bloodPressureClass['color'], // Set color from classification
                      ),
                    ),
                    CustomCard(
                      title: 'Exercise',
                      status: 'High',
                      color: Color.fromARGB(255, 177, 60, 255),
                    ),
                    CustomCard(
                      title: 'Water Intake',
                      status: 'Finished',
                      color: Color.fromARGB(255, 37, 237, 255),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Smooth Page Indicator
              Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blueGrey,
                    dotWidth: 10,
                    dotHeight: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Logged Exercises for the Day', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              _buildLoggedExercises(loggedExercises, exerciseProvider),
              SizedBox(height: 20),
              const Center(
                child: Text(
                  'Logged Water Intake for the Day', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              _buildLoggedWaterIntakes(loggedWaterIntakes, waterProvider),
              SizedBox(height: 20),
            ],
          ),
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
      drawer: const NavBar(),
    );
  }
  Widget _buildLoggedExercises(List<LoggedExercise> loggedExercises, ExerciseProvider exerciseProvider) {
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis, // Truncate long names
                            maxLines: 2,
                          ),
                          SizedBox(height: 8), // Add space between name and details

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
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Delete the logged exercise
                          exerciseProvider.deleteLoggedExercise(index);
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


  Widget _buildLoggedWaterIntakes(List<WaterIntake> loggedWaterIntakes, WaterProvider waterProvider) {
    if (loggedWaterIntakes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No Water intake logged for this day.', style: TextStyle(fontSize: 16)),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        // Display formatted date and time
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Remove the water intake at the specified index
                        waterProvider.deleteWaterIntake(index);
                      },
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

}

// Custom Card Widget
class CustomCard extends StatelessWidget {
  final String title;
  final String status;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.title,
    required this.status,
    this.color,
  }) : super(key: key);

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
              style: TextStyle(
                fontSize: 20,  // Increased font size for the title
                fontWeight: FontWeight.bold,  // Make the title bold
                color: Colors.white,  // White color for good contrast
                letterSpacing: 1.2,  // Slightly increase the letter spacing for readability
              ),
            ),
            const SizedBox(height: 8),  // More space between title and status text
            Text(
              status,
              style: TextStyle(
                fontSize: 16,  // Slightly smaller font size for status
                fontWeight: FontWeight.w500,  // Medium weight for status text
                color: Colors.white70,  // Lighter shade of white for status
                letterSpacing: 1.0,  // Add some letter spacing for clarity
              ),
            ),
          ],
        ),
      ),
    );
  }
}