import 'package:final_eatanong_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 0;
  String _gender = 'Male'; // Default value
  double _height = 0.0;
  double _weight = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Initial Setup')),
      body: SingleChildScrollView(  // Wrap the content in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Please enter your age' : null,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _height = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'Please enter your height' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'Please enter your weight' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Store user data in Hive
                    var box = Hive.box('userBox');
                    box.put('userName', _name);
                    box.put('userAge', _age);
                    box.put('userGender', _gender);
                    box.put('userHeight', _height);
                    box.put('userWeight', _weight);

                    // Navigate to the home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}