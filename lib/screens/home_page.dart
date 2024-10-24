import 'package:flutter/material.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:provider/provider.dart';
import 'results_page.dart'; // Import the ResultsPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Text("Person Object Debugger"),
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
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Text("Logged Food Object Debugger"),
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return ListView.builder(
                  itemCount: foodProvider.loggedFoods.length,
                  itemBuilder: (context, index) {
                    final food = foodProvider.loggedFoods[index];
                    return ListTile(
                      title: Text(food.foodItem.name),
                      subtitle: Text('Grams: ${food.quantity} | Date: ${food.loggedTime} | Total Cals: ${food.totalCalories}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          foodProvider.deleteLoggedFood(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Text("Food Object Debugger"),
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return ListView.builder(
                  itemCount: foodProvider.foods.length,
                  itemBuilder: (context, index) {
                    final food = foodProvider.foods[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text('Calories: ${food.calories} | Fat: ${food.fat}g | Protein: ${food.protein}g | Carbohydrates: ${food.carbohydrates}g'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          foodProvider.deleteFood(index);
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
          pickImage(context); // Pass context to pickImage function
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

  // Function to pick an image and classify
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      classifyImage(context, image.path);
    }
  }

  // Function to load the TFLite model
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  // Function to classify the picked image and navigate to the results page
  Future<void> classifyImage(BuildContext context, String imagePath) async {
    await loadModel();
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 5,
      threshold: 0.5,
    );

    if (recognitions != null) {
      // Navigate to ResultsPage and pass the recognitions
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(recognitions: recognitions),
        ),
      );
    }
  }
}
