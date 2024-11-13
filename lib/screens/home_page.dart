// home_page.dart

import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents FAB from moving with the snackbar
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),
      ),
      body: Column(
        children: [
          const Text("Person Object Debugger"),
          Expanded(
            child: Consumer<PersonProvider>(
              builder: (context, personProvider, child) {
                return ListView.builder(
                  itemCount: personProvider.persons.length,
                  itemBuilder: (context, index) {
                    final person = personProvider.persons[index];
                    return ListTile(
                      title: Text(person.name),
                      subtitle: Text('Age: ${person.age}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          personProvider.deletePerson(index);
                          // Show snackbar after deletion
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${person.name} deleted')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Text("Logged Food Object Debugger"),
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return ListView.builder(
                  itemCount: foodProvider.loggedFoods.length,
                  itemBuilder: (context, index) {
                    final food = foodProvider.loggedFoods[index];
                    return ListTile(
                      title: Text(food.foodItem.name),
                      subtitle: Text(
                          'Grams: ${food.quantity} | Date: ${food.loggedTime} | Total Cals: ${food.totalCalories}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          foodProvider.deleteLoggedFood(index);
                          // Show snackbar after deletion
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${food.foodItem.name} deleted')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                  // Handle home button press
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
}
