import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class WaterLoggerScreen extends StatefulWidget {
  @override
  _WaterLoggerScreenState createState() => _WaterLoggerScreenState();
}

class _WaterLoggerScreenState extends State<WaterLoggerScreen> {
  double _selectedWaterAmount = 0.0; // Initial selected water amount
  final double _maxWaterAmount = 2000.0; // Max value for the water intake slider

  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);

    final DateTime normalizedSelectedDay = DateTime.now(); // Current date
    final loggedWaterIntakes = waterProvider.getWaterIntakesForDay(normalizedSelectedDay);
    final totalWaterIntake = waterProvider.calculateTotalWaterIntake(normalizedSelectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Logger', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 173, 255, 254), // Custom color for AppBar
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Select water intake (ml)',
                    style: TextStyle(fontSize: 18),
                  ),
                  Slider(
                    value: _selectedWaterAmount,
                    min: 0.0,
                    max: _maxWaterAmount,
                    divisions: 200, 
                    label: '${_selectedWaterAmount.toStringAsFixed(1)} ml',
                    activeColor: Color.fromARGB(255, 37, 237, 255), 
                    inactiveColor: Color(0xFFE1E1E1), 
                    onChanged: (double value) {
                      setState(() {
                        _selectedWaterAmount = value;
                      });
                    },
                  ),
                  Text(
                    'Amount: ${_selectedWaterAmount.toStringAsFixed(1)} ml',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: _logWaterIntake(waterProvider),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      backgroundColor: const Color.fromARGB(255, 37, 237, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 3,
                      side: BorderSide(
                        color: const Color.fromARGB(255, 37, 237, 255),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Log Water',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildLoggedWaterIntakes(loggedWaterIntakes, waterProvider),
            _buildTotalWaterIntake(totalWaterIntake),
          ],
        ),
      ),
      drawer: NavBar(),
    );
  }

  void Function() _logWaterIntake(WaterProvider waterProvider) {
    return () {
      if (_selectedWaterAmount > 0) {
        // Log the water intake
        waterProvider.addWaterIntake(
          WaterIntake(amount: _selectedWaterAmount, date: DateTime.now())
        );

        // Show a custom success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Water logged: ${_selectedWaterAmount.toStringAsFixed(1)} ml'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 50, left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green, // Success color
          ),
        );

        // Reset the slider value
        setState(() {
          _selectedWaterAmount = 0.0;
        });

        // Navigate back or to calendar
        Navigator.pop(context);
        Navigator.pushNamed(context, "/calendar");
      } else {
        // If invalid input, show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a valid amount of water'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 50, left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.redAccent, // Error color
          ),
        );
      }
    };
  }

  Widget _buildTotalWaterIntake(double totalWaterIntake) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Water Intake: ${totalWaterIntake.toStringAsFixed(1)} ml',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedWaterIntakes(List<WaterIntake> loggedWaterIntakes, WaterProvider waterProvider) {
    if (loggedWaterIntakes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No water intake logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return SizedBox(
      height: loggedWaterIntakes.length > 3 ? 300.0 : 200.0,
      child: ListView.builder(
        itemCount: loggedWaterIntakes.length,
        itemBuilder: (context, index) {
          final loggedWater = loggedWaterIntakes[index];

          // Format the date and time
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(loggedWater.date);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display water amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loggedWater.amount.toStringAsFixed(1)} ml',
                          style: TextStyle(fontSize: 16),
                        ),
                        // Display formatted date and time
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Remove the water intake at the specified index
                        waterProvider.deleteWaterIntake(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
