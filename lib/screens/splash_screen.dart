import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/screens/calendar_screen.dart';
import 'package:final_eatanong_flutter/screens/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animations
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Total animation duration
      vsync: this,
    );

    // Fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Fade-out animation
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn), // Start fading out after 1.5 seconds
    ));

    // Start the fade-in animation
    _controller.forward().then((_) async {
      try {
        var personBox = await Hive.openBox<Person>('personBox');

        // If there is a person record, check and update the age
        if (personBox.isNotEmpty) {
          final person = personBox.getAt(0); // Assuming only one person record

          if (person != null) {
            // Get the current age from the birthdate and check if it has changed
            final currentAge = person.age;
            final storedAge = person.age;

            // Only update if the age is outdated (i.e., one year has passed)
            if (currentAge != storedAge) {
              // Create a new Person object with updated age
              final updatedPerson = Person(
                name: person.name,
                birthdate: person.birthdate,  // Keep the birthdate the same
                gender: person.gender,
                weight: person.weight,
                height: person.height,
              );

              // Update the person's data in the box
              await personBox.putAt(0, updatedPerson);
            }
          }
        }

        // Navigate based on whether there is user data in the box
        if (personBox.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InitialPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DietLogScreen()),
          );
        }
      } catch (e) {
        // Default navigation in case of error
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InitialPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 234),
      body: FadeTransition(
        opacity: _fadeInAnimation, // Apply fade-in effect
        child: Center(
          child: FadeTransition(
            opacity: _fadeOutAnimation, // Apply fade-out effect
            child: Image.asset('assets/logo.png'), // Add your app logo here
          ),
        ),
      ),
    );
  }
}
