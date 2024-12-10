import 'package:final_eatanong_flutter/models/blood_pressure.dart';
import 'package:final_eatanong_flutter/models/exercise.dart';
import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/models/logged_exercise.dart';
import 'package:final_eatanong_flutter/models/logged_food.dart';
import 'package:final_eatanong_flutter/models/medication_reminder.dart';
import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/bp_provider.dart';
import 'package:final_eatanong_flutter/providers/exercise_provider.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/providers/medication_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:final_eatanong_flutter/screens/add_food.dart';
import 'package:final_eatanong_flutter/screens/bp_screen.dart';
import 'package:final_eatanong_flutter/screens/calendar_screen.dart';
import 'package:final_eatanong_flutter/screens/exercise_screen.dart';
import 'package:final_eatanong_flutter/screens/healthy_recipes_screen.dart';
import 'package:final_eatanong_flutter/screens/medication_screen.dart';
import 'package:final_eatanong_flutter/screens/progress_tracker.dart';
import 'package:final_eatanong_flutter/screens/splash_screen.dart';
import 'package:final_eatanong_flutter/screens/user_profile.dart';
import 'package:final_eatanong_flutter/screens/water_logger_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
   // This line ensures that the Flutter framework is properly initialized before running the application.
  WidgetsFlutterBinding.ensureInitialized();
  // This line initializes Hive for use with Flutter.
  // The await keyword is used to wait for the initialization to complete before proceeding.
  await Hive.initFlutter();

  // Register the Person adapter
  // This line registers the PersonAdapter class as an adapter for the Person class
  // Adapters are used by Hive to serialize and deserialize objects of a specific type.
  Hive.registerAdapter(PersonAdapter()); //typeId: 0
  Hive.registerAdapter(FoodItemAdapter()); //typeId: 1
  Hive.registerAdapter(LoggedFoodAdapter()); //typeId: 2
  Hive.registerAdapter(ExerciseAdapter()); //typeId: 3
  Hive.registerAdapter(LoggedExerciseAdapter()); //typeId: 4
  Hive.registerAdapter(WaterIntakeAdapter()); //typeId: 5
  Hive.registerAdapter(MedicationReminderAdapter()); //typeId: 6
  Hive.registerAdapter(BloodPressureAdapter()); // typeId: 7

  // Open a Hive box for storing Persons
  // This line opens a Hive box named personBox that is specific to storing Person objects.
  // The await keyword is used to wait for the box to be opened before proceeding.
  await Hive.openBox<Person>('personBox');
  await Hive.openBox<FoodItem>('foodBox');
  await Hive.openBox<LoggedFood>('loggedFoodBox');
  await Hive.openBox<Exercise>('exerciseBox');
  await Hive.openBox<LoggedExercise>('loggedExerciseBox');
  await Hive.openBox<WaterIntake>('waterIntakeBox');
  await Hive.openBox<MedicationReminder>('medicationBox');
  await Hive.openBox<BloodPressure>('bloodPressureBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => BloodPressureProvider()) 
      ], 
      child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        "/user profile": (context) => const UserProfile(),
        "/search screen": (context) => AddFood(),
        "/calendar": (context) => const DietLogScreen(),
        "/exercise screen": (context) => const ExerciseScreen(),
        "/healthy recipes": (context) => HealthyRecipesScreen(),
        "/water screen": (context) => const WaterLoggerScreen(),
        "/medication screen": (context) => const MedicationLoggerScreen(),
        "/bp screen": (context) => const BloodPressureScreen(),
        "/progress screen": (context) => const ProgressTracker(),
      },
    );
  }
}