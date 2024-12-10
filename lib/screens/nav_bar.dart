import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  // Method to calculate BMI
  double calculateBMI(double weight, double height) {
    double heightInMeters = height / 100; // Convert height to meters
    return weight / (heightInMeters * heightInMeters);
  }

  // Method to classify BMI
  String classifyBMI(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Custom Header Container
          Consumer<PersonProvider>(
            builder: (context, personProvider, child) {
              if (personProvider.persons.isNotEmpty) {
                final person = personProvider.persons.first; // Get the first person

                // Calculate BMI
                double bmi = calculateBMI(person.weight, person.height);
                String bmiClassification = classifyBMI(bmi); // Get BMI classification

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  color: const Color.fromARGB(255, 255, 198, 198),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Text(
                          person.name[0], // Display the first letter of the user's name
                          style: const TextStyle(fontSize: 40, color: Colors.black),
                        ), // Set the radius for the avatar
                      ),
                      const SizedBox(height: 16), // Spacing
                      Text(
                        "Hello, ${person.name}!",
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 4), // Spacing
                      Text(
                        "Age: ${person.age}",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 4), // Spacing
                      Text(
                        "BMI: ${bmi.toStringAsFixed(2)} ($bmiClassification)",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Person Data",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "No Email Available",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushNamed(context, "/calendar");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search Food"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/search screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Exercise"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/exercise screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text("Water"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/water screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text("Blood Pressure"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/bp screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.medication),
            title: const Text("Medication"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/medication screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.food_bank_outlined),
            title: const Text("Heart Healthy Recipes"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/healthy recipes");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text("Progress Tracker"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/progress screen");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: const Text("User Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/user profile");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.restart_alt_outlined),
            title: const Text("Restart App"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/");
            },
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}