import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Text("Person"),
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
          Text("Foods"),
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return ListView.builder(
                  itemCount: foodProvider.foods.length,
                  itemBuilder: (context, index) {
                    final food = foodProvider.foods[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text('Calories: ${food.calories} | Fat: ${food.fat}g | Protein: ${food.protein}g | Carbohydates: ${food.carbohydrates}g'),
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
      drawer: const NavBar(),
    );
  }
}