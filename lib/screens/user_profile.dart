import 'package:final_eatanong_flutter/providers/person_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:final_eatanong_flutter/models/person.dart';


class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the first person from the PersonProvider
    final personProvider = Provider.of<PersonProvider>(context);
    final person = personProvider.persons.isNotEmpty ? personProvider.persons.first : null;

    // If no person data, show an error message
    if (person == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Profile')),
        body: Center(child: Text('No profile data available')),
      );
    }

    // Define the form group with initial values from the person object
    final form = fb.group({
      'name': FormControl<String>(value: person.name, validators: [Validators.required]),
      'age': FormControl<int>(value: person.age, validators: [
        Validators.required,
        Validators.min(1), // Age must be at least 1
      ]),
      'gender': FormControl<String>(value: person.gender, validators: [Validators.required]),
      'height': FormControl<double>(value: person.height, validators: [
        Validators.required,
        Validators.min(1), // Height must be positive
      ]),
      'weight': FormControl<double>(value: person.weight, validators: [
        Validators.required,
        Validators.min(1), // Weight must be positive
      ]),
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 255, 198, 198),
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
                  decoration: InputDecoration(labelText: 'Name'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Please enter your name',
                  },
                ),
                SizedBox(height: 16.0),

                // Age Field
                ReactiveTextField<int>(
                  formControlName: 'age',
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Please enter your age',
                    ValidationMessage.min: (error) => 'Age must be a positive number',
                  },
                ),
                SizedBox(height: 16.0),

                // Gender Dropdown
                ReactiveDropdownField<String>(
                  formControlName: 'gender',
                  decoration: InputDecoration(labelText: 'Gender'),
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
                  decoration: InputDecoration(labelText: 'Height (cm)'),
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
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Please enter your weight',
                    ValidationMessage.min: (error) => 'Weight must be a positive number',
                  },
                ),
                SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      // Get form values
                      final String name = form.control('name').value!;
                      final int age = form.control('age').value!;
                      final String gender = form.control('gender').value!;
                      final double height = form.control('height').value!;
                      final double weight = form.control('weight').value!;

                      // Create a new updated Person object
                      final updatedPerson = Person(
                        name: name,
                        age: age,
                        gender: gender,
                        height: height,
                        weight: weight,
                      );

                      // Update the person in the PersonProvider
                      final personIndex = personProvider.persons.indexOf(person);
                      personProvider.updatePerson(personIndex, updatedPerson);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile updated successfully!'))
                      );
                    } else {
                      // Mark all fields as touched to show validation errors
                      form.markAllAsTouched();
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: NavBar(),
    );
  }
}
