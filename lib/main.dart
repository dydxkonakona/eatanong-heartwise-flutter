import 'package:final_eatanong_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => PersonProvider()),
        // ChangeNotifierProvider(create: (_) => FoodProvider()),
      ], 
      child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        "/home": (context) => const HomePage(),
        // "/person screen": (context) => PersonScreen(),
        // "/food screen": (context) => FoodScreen(),
      },
    );
  }
}