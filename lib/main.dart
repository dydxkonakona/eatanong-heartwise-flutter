import 'package:final_eatanong_flutter/models/food.dart';
import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/screens/food_screen.dart';
import 'package:final_eatanong_flutter/screens/home_page.dart';
import 'package:final_eatanong_flutter/screens/splash_screen.dart';
import 'package:final_eatanong_flutter/screens/user_profile.dart';
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
  Hive.registerAdapter(PersonAdapter()); //typeId: 1
  Hive.registerAdapter(FoodAdapter()); //typeId: 2

  // Open a Hive box for storing Persons
  // This line opens a Hive box named personBox that is specific to storing Person objects.
  // The await keyword is used to wait for the box to be opened before proceeding.
  await Hive.openBox<Person>('personBox');
  await Hive.openBox<Food>('foodBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
      ], 
      child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        "/home": (context) => const HomePage(),
        // "/person screen": (context) => PersonScreen(),
        "/food screen": (context) => FoodScreen(),
        "/user profile": (context) => UserProfile(),
      },
    );
  }
}