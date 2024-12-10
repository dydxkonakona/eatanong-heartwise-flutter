import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/models/water_intake.dart';
import 'package:final_eatanong_flutter/providers/water_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class WaterLoggerScreen extends StatefulWidget {
  const WaterLoggerScreen({super.key});

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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 1, 196, 255), // Custom color for AppBar
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Column(
                  children: [
                    const Text(
                      'Select Water Intake (ml)',
                      style: TextStyle(fontSize: 18),
                    ),
                    Slider(
                      value: _selectedWaterAmount,
                      min: 0.0,
                      max: _maxWaterAmount,
                      divisions: 200,
                      label: '${_selectedWaterAmount.toStringAsFixed(1)} ml',
                      activeColor: const Color.fromARGB(255, 2, 64, 141),
                      inactiveColor: const Color(0xFFE1E1E1),
                      onChanged: (double value) {
                        setState(() {
                          _selectedWaterAmount = value;
                        });
                      },
                    ),
                    Text(
                      'Amount: ${_selectedWaterAmount.toStringAsFixed(1)} ml',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _logWaterIntake(waterProvider),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.05,
                        ),
                        backgroundColor: const Color.fromARGB(255, 2, 64, 141),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 3,
                        side: const BorderSide(
                          color: Color.fromARGB(255, 2, 64, 141),
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'Log Water Intake',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLoggedWaterIntakes(loggedWaterIntakes, waterProvider),
                _buildTotalWaterIntake(totalWaterIntake),
                const SizedBox(height: 16),
                // Water intake recommendations
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with Icon and Text
                          const Row(
                            children: [
                              Icon(
                                Icons.water_drop, // Water drop icon
                                color: Colors.blue, // Optional: change color of the icon
                                size: 20, // Size of the icon
                              ),
                              SizedBox(width: 8), // Spacing between icon and text
                              Text(
                                'Recommended Daily Water Intake',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Water intake recommendations
                          ...[
                            '1 - 18 years: 1000 ml + 50 ml per kg body weight',
                            '19 years and up: 2500 ml',
                            '65 years and up: 1500 ml',
                            'Pregnant women: 2800 ml',
                            'Lactating women: 3250 - 3500 ml',
                            'Drink more if in a hotter climate or physically active.',
                          ].map((text) => Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  text,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      drawer: const NavBar(),
    );
  }

  void Function() _logWaterIntake(WaterProvider waterProvider) {
    return () {
      if (_selectedWaterAmount > 0) {
        waterProvider.addWaterIntake(
          WaterIntake(amount: _selectedWaterAmount, date: DateTime.now()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Water logged: ${_selectedWaterAmount.toStringAsFixed(1)} ml'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedWaterAmount = 0.0;
        });
        Navigator.pop(context);
        Navigator.pushNamed(context, "/calendar");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a valid amount of water'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    };
  }

  Widget _buildTotalWaterIntake(double totalWaterIntake) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedWaterIntakes(List<WaterIntake> loggedWaterIntakes, WaterProvider waterProvider) {
    if (loggedWaterIntakes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No water intake logged for today.', style: TextStyle(fontSize: 16)),
      );
    }

    return SizedBox(
      height: loggedWaterIntakes.length > 3 ? 300.0 : 200.0,
      child: ListView.builder(
        itemCount: loggedWaterIntakes.length,
        itemBuilder: (context, index) {
          final loggedWater = loggedWaterIntakes[index];
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(loggedWater.date);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loggedWater.amount.toStringAsFixed(1)} ml',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
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
