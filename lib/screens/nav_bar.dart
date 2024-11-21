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
                  padding: EdgeInsets.all(16.0),
                  color: Color.fromARGB(255, 255, 198, 198),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          person.name[0], // Display the first letter of the user's name
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                        radius: 30, // Set the radius for the avatar
                      ),
                      SizedBox(height: 16), // Spacing
                      Text(
                        "Hello, ${person.name}!",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 4), // Spacing
                      Text(
                        "Age: ${person.age}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 4), // Spacing
                      Text(
                        "BMI: ${bmi.toStringAsFixed(2)} ($bmiClassification)",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Column(
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
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Search Food"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/search screen");
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text("Calendar Screen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/calendar");
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text("Exercise"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/exercise screen");
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.food_bank_outlined),
            title: Text("Heart Healthy Recipes"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/healthy recipes");
            },
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.account_box_outlined),
            title: Text("User Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/user profile");
            },
          ),Divider(color: Colors.grey),
        ],
      ),
    );
  }
}