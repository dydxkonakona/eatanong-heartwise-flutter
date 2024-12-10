import 'package:final_eatanong_flutter/providers/food_ai.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  late ImageClassifier _imageClassifier;

  @override
  void initState() {
    super.initState();
    // Initialize the ImageClassifier with the current context
    _imageClassifier = ImageClassifier(context);
  }

  @override
  void dispose() {
    // Dispose of the ImageClassifier to release resources
    _imageClassifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsiveness
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Mode', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First Square Button (Camera Icon) - Enlarged with Text
              SizedBox(
                width: screenWidth * 0.7, // Button width is 70% of screen width
                height: screenHeight * 0.25, // Button height is 25% of screen height
                child: ElevatedButton(
                  onPressed: () {
                    // When "FOOD AI IMAGE" button is pressed, call classifyImageFromCamera
                    _imageClassifier.classifyImageFromCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 198, 198), // Button background color same as app bar
                    elevation: 5, // Button elevation
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50, // Larger Icon size
                        color: Colors.black, // Icon color set to black
                      ),
                      SizedBox(height: 10), // Space between icon and text
                      Text(
                        'FOOD AI IMAGE',
                        style: TextStyle(
                          fontSize: 16, // Text size
                          color: Colors.black, // Text color set to black
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30), // Space between the buttons

              // Second Square Button (Search Icon) - Enlarged with Text
              SizedBox(
                width: screenWidth * 0.7, // Button width is 70% of screen width
                height: screenHeight * 0.25, // Button height is 25% of screen height
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the search screen when pressed
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/search screen");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 198, 198), // Button background color same as app bar
                    elevation: 5, // Button elevation
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 50, // Larger Icon size
                        color: Colors.black, // Icon color set to black
                      ),
                      SizedBox(height: 10), // Space between icon and text
                      Text(
                        'SEARCH FOOD',
                        style: TextStyle(
                          fontSize: 16, // Text size
                          color: Colors.black, // Text color set to black
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
