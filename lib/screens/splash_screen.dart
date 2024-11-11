import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/screens/home_page.dart';
import 'package:final_eatanong_flutter/screens/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
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
      duration: Duration(seconds: 3), // Total animation duration
      vsync: this,
    );

    // Fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Fade-out animation
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.easeIn), // Start fading out after 1.5 seconds
    ));

    // Start the fade-in animation
    _controller.forward().then((_) async {
      // Use try-catch to handle any potential Hive initialization issues
      try {
        var personBox = await Hive.openBox<Person>('personBox');

        // Debugging: Print the number of entries in the personBox
        // print("Number of persons in the box: ${personBox.length}");

        // Navigate based on whether there is user data in the box
        if (personBox.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InitialPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        // Handle error (e.g., if the box can't be opened)
        print("Error opening personBox: $e");
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
      backgroundColor: Color.fromARGB(255, 255, 234, 234),
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
