import 'package:final_eatanong_flutter/models/food_item.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FoodScreen extends StatelessWidget {
  // Define the form group
  final FormGroup form = fb.group({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'calories': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
    'fat': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
    'protein': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
    'carbohydrates': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
    'sodium': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
    'cholesterol': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(0),
    ]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Food', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside of the form
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  // Food Name Field
                  ReactiveTextField<String>(
                    formControlName: 'name',
                    decoration: InputDecoration(
                      labelText: 'Food Name',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Food Name is required',
                    },
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'If you don\'t know the exact value, enter 0.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 8.0),
                  // Calories Field
                  ReactiveTextField<double>(
                    formControlName: 'calories',
                    decoration: InputDecoration(
                      labelText: 'Calories',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Fat (g)',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Protein (g)',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Carbohydrates (g)',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Sodium (mg)',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Cholesterol (mg)',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                      ),
                    ),
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
                        final double calories = form.control('calories').value!;
                        final double fat = form.control('fat').value!;
                        final double protein = form.control('protein').value!;
                        final double carbohydrates = form.control('carbohydrates').value!;
                        final double sodium = form.control('sodium').value!;
                        final double cholesterol = form.control('cholesterol').value!;

                        // Create a new Food object
                        final food = FoodItem(
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

                        // Show success SnackBar at the top
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Food "$name" added successfully!'),
                            behavior: SnackBarBehavior.floating, // Custom positioning
                            margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green, // Green color for success
                          ),
                        );

                        // Reset the form after submission
                        form.reset();
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/calendar");
                      } else {
                        form.markAllAsTouched(); // Mark all fields as touched to show validation errors
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // More spacious padding
                      backgroundColor: Color(0xFFFF6363), // A softer, pastel-like red for the background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Round corners for a modern look
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for elevation effect
                      elevation: 5, // Adding elevation for depth
                      side: const BorderSide(
                        color: Color(0xFFFF6363), // Border color matches the button color
                        width: 2, // Border width for a subtle outline
                      ),
                    ),
                    child: const Text(
                      'Add Food',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size for emphasis
                        fontWeight: FontWeight.w600, // Slightly lighter weight for better readability
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: NavBar(),
    );
  }
}
