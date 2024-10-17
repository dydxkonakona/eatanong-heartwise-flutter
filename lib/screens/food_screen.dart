import 'package:final_eatanong_flutter/models/food.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FoodScreen extends StatelessWidget {
  // Define the form group
  final FormGroup form = fb.group({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'calories': FormControl<int>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring calories is a non-negative number
    ]),
    'fat': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring fat is a non-negative number
    ]),
    'protein': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring protein is a non-negative number
    ]),
    'carbohydrates': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring carbohydrates is a non-negative number
    ]),
    'sodium': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring sodium is a non-negative number
    ]),
    'cholesterol': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0), // Ensuring cholesterol is a non-negative number
    ]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                // Food Name Field
                ReactiveTextField<String>(
                  formControlName: 'name',
                  decoration: InputDecoration(labelText: 'Food Name'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Food Name is required',
                  },
                ),
                SizedBox(height: 16.0),

                // Calories Field
                ReactiveTextField<int>(
                  formControlName: 'calories',
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Calories are required',
                    ValidationMessage.min: (error) => 'Calories must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Fat Field
                ReactiveTextField<double>(
                  formControlName: 'fat',
                  decoration: InputDecoration(labelText: 'Fat (g)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Fat is required',
                    ValidationMessage.min: (error) => 'Fat must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Protein Field
                ReactiveTextField<double>(
                  formControlName: 'protein',
                  decoration: InputDecoration(labelText: 'Protein (g)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Protein is required',
                    ValidationMessage.min: (error) => 'Protein must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Carbohydrates Field
                ReactiveTextField<double>(
                  formControlName: 'carbohydrates',
                  decoration: InputDecoration(labelText: 'Carbohydrates (g)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Carbohydrates are required',
                    ValidationMessage.min: (error) => 'Carbohydrates must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Sodium Field
                ReactiveTextField<double>(
                  formControlName: 'sodium',
                  decoration: InputDecoration(labelText: 'Sodium (mg)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Sodium is required',
                    ValidationMessage.min: (error) => 'Sodium must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Cholesterol Field
                ReactiveTextField<double>(
                  formControlName: 'cholesterol',
                  decoration: InputDecoration(labelText: 'Cholesterol (mg)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Cholesterol is required',
                    ValidationMessage.min: (error) => 'Cholesterol must be a non-negative number',
                  },
                ),
                SizedBox(height: 16.0),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      // Get form values
                      final String name = form.control('name').value!;
                      final int calories = form.control('calories').value!;
                      final double fat = form.control('fat').value!;
                      final double protein = form.control('protein').value!;
                      final double carbohydrates = form.control('carbohydrates').value!;
                      final double sodium = form.control('sodium').value!;
                      final double cholesterol = form.control('cholesterol').value!;

                      // Create a new Food object
                      final food = Food(
                        name: name,
                        calories: calories,
                        fat: fat,
                        protein: protein,
                        carbohydrates: carbohydrates,
                        sodium: sodium,
                        cholesterol: cholesterol,
                      );

                      // Add the food to the provider
                      context.read<FoodProvider>().addFood(food);

                      // Reset the form after submission
                      form.reset();
                    } else {
                      form.markAllAsTouched(); // Mark all fields as touched to show validation errors
                    }
                  },
                  child: Text('Add Food'),
                ),

                // Display the List of Foods
                SizedBox(height: 16.0), // Add space before the list
                Consumer<FoodProvider>(
                  builder: (context, foodProvider, child) {
                    return ListView.builder(
                      shrinkWrap: true, // Prevents overflow issues
                      physics: NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                      itemCount: foodProvider.foods.length,
                      itemBuilder: (context, index) {
                        final food = foodProvider.foods[index];
                        return ListTile(
                          title: Text(food.name),
                          subtitle: Text('Calories: ${food.calories} | Fat: ${food.fat}g | Protein: ${food.protein}g'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
