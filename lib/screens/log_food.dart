import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddLoggedFoodScreen extends StatelessWidget {
  // Define the form group for logging food
  final FormGroup form = fb.group({
    'food': FormControl<FoodItem>(validators: [Validators.required]),
    'quantity': FormControl<double>(
      value: 1.0,
      validators: [Validators.required, Validators.min(0.1)],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Food Intake')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Dropdown
              Consumer<FoodProvider>(
                builder: (context, foodProvider, child) {
                  return ReactiveDropdownField<FoodItem>(
                    formControlName: 'food',
                    decoration: InputDecoration(
                      labelText: 'Select Food',
                    ),
                    items: foodProvider.foods.map((food) {
                      return DropdownMenuItem<FoodItem>(
                        value: food,
                        child: Text(food.name),
                      );
                    }).toList(),
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          'Please select a food item',
                    },
                  );
                },
              ),
              SizedBox(height: 16.0),

              // Quantity Field
              ReactiveTextField<double>(
                formControlName: 'quantity',
                decoration: InputDecoration(labelText: 'Quantity (g)'),
                keyboardType: TextInputType.number,
                validationMessages: {
                  ValidationMessage.required: (error) =>
                      'Quantity is required',
                  ValidationMessage.min: (error) =>
                      'Quantity must be at least 0.1g',
                },
              ),
              SizedBox(height: 24.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    // Get form values
                    final FoodItem food = form.control('food').value!;
                    final double quantity = form.control('quantity').value!;

                    // Add logged food to provider
                    context.read<FoodProvider>().addLoggedFood(food, quantity);

                    // Reset form after submission
                    form.reset();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Food logged successfully')));
                  } else {
                    form.markAllAsTouched(); // Show validation errors
                  }
                },
                child: Text('Log Food'),
              ),

              // Display logged food for today
              SizedBox(height: 24.0),
              Text('Today\'s Intake:',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              Consumer<FoodProvider>(
                builder: (context, foodProvider, child) {
                  final today = DateTime.now();
                  final loggedFoods = foodProvider.getIntakesForDay(today);

                  if (loggedFoods.isEmpty) {
                    return Text('No food logged for today.');
                  }

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, // Prevent overflow
                      itemCount: loggedFoods.length,
                      itemBuilder: (context, index) {
                        final loggedFood = loggedFoods[index];
                        return ListTile(
                          title: Text('${loggedFood.foodItem.name}'),
                          subtitle: Text('Quantity: ${loggedFood.quantity}g'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              foodProvider.deleteLoggedFood(index);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: NavBar(),
    );
  }
}
