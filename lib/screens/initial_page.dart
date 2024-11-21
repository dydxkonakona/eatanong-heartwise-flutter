import 'package:final_eatanong_flutter/models/person.dart';
import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart'; // Import this for DateFormat

class InitialPage extends StatelessWidget {
  // Define the form group
  final FormGroup form = fb.group({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'birthdate': FormControl<DateTime>(value: null, validators: [
      Validators.required, // Birthdate must be provided
    ]),
    'gender': FormControl<String>(value: 'Male', validators: [Validators.required]),
    'height': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(1), // Height must be positive
    ]),
    'weight': FormControl<double>(value: null, validators: [
      Validators.required,
      Validators.min(1), // Weight must be positive
    ]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initial Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                // Name Field
                ReactiveTextField<String>(
                  formControlName: 'name',
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                    ValidationMessage.required: (error) => 'Please enter your name',
                  },
                ),
                SizedBox(height: 16.0),

                // Birthdate Field
                ReactiveDatePicker(
                  formControlName: 'birthdate',
                  builder: (context, reactiveDatePickerDelegate, child) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
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
                      child: GestureDetector(
                        onTap: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            // Update form control with the selected date
                            reactiveDatePickerDelegate.control.value = selectedDate;
                          }
                        },
                        child: AbsorbPointer( // Prevent editing the text field
                          child: Text(
                            reactiveDatePickerDelegate.control.value != null
                                ? DateFormat('yyyy-MM-dd').format(
                                    (reactiveDatePickerDelegate.control.value as DateTime?)!)
                                : 'Select your birthdate',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    );
                  },
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ),
                SizedBox(height: 16.0),

                // Gender Dropdown
                ReactiveDropdownField<String>(
                  formControlName: 'gender',
                  decoration: InputDecoration(
                    labelText: 'Gender',
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
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),

                // Height Field
                ReactiveTextField<double>(
                  formControlName: 'height',
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
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
                    ValidationMessage.required: (error) => 'Please enter your height',
                    ValidationMessage.min: (error) => 'Height must be a positive number',
                  },
                ),
                SizedBox(height: 16.0),

                // Weight Field
                ReactiveTextField<double>(
                  formControlName: 'weight',
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
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
                    ValidationMessage.required: (error) => 'Please enter your weight',
                    ValidationMessage.min: (error) => 'Weight must be a positive number',
                  },
                ),
                SizedBox(height: 20.0),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      // Here you can perform form submission
                      final String name = form.control('name').value!;
                      final DateTime birthdate = form.control('birthdate').value!;
                      final String gender = form.control('gender').value!;
                      final double height = form.control('height').value!;
                      final double weight = form.control('weight').value!;

                      // Handle saving logic here...
                      final person = Person(
                        name: name,
                        birthdate: birthdate,
                        gender: gender,
                        height: height,
                        weight: weight,
                      );
                      // add the person to the provider
                      context.read<PersonProvider>().addPerson(person);

                      // Navigate to home page
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => HomePage()),
                        );

                      // You can reset the form after submission if necessary
                      form.reset();
                    } else {
                      form.markAllAsTouched(); // Mark all fields as touched to show validation errors
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    backgroundColor: Color(0xFFFF6363),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    side: const BorderSide(
                      color: Color(0xFFFF6363),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
