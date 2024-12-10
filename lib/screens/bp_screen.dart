import 'package:final_eatanong_flutter/providers/bp_provider.dart';
import 'package:final_eatanong_flutter/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/models/blood_pressure.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  // Controllers for systolic and diastolic values
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bloodPressureProvider = Provider.of<BloodPressureProvider>(context);
    final loggedBloodPressures = bloodPressureProvider.getBloodPressuresForDay(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198), // Custom color for AppBar
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                // Systolic Field with Hint Text
                TextField(
                  controller: _systolicController,
                  decoration: InputDecoration(
                    hintText: 'Enter systolic pressure (e.g., 120)',
                    labelText: 'Systolic (mmHg)',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8.0),
                // Diastolic Field with Hint Text
                TextField(
                  controller: _diastolicController,
                  decoration: InputDecoration(
                    hintText: 'Enter diastolic pressure (e.g., 80)',
                    labelText: 'Diastolic (mmHg)',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 198, 198)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Input your blood pressure reading in mmHg.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16.0),

                // Center the Log Blood Pressure Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Convert text input to double
                      double systolic = double.tryParse(_systolicController.text) ?? 0;
                      double diastolic = double.tryParse(_diastolicController.text) ?? 0;

                      if (systolic > 0 && diastolic > 0) {
                        // Log the blood pressure reading
                        bloodPressureProvider.addBloodPressure(
                          BloodPressure(
                            date: DateTime.now(),
                            systolic: systolic,
                            diastolic: diastolic,
                          ),
                        );

                        // Clear the input fields
                        _systolicController.clear();
                        _diastolicController.clear();

                        // Dismiss the keyboard
                        FocusScope.of(context).unfocus();

                        // Show a success SnackBar with custom style
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Blood pressure logged'),
                            behavior: SnackBarBehavior.floating, // Custom positioning
                            margin: const EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green, // Green color for success
                          ),
                        );

                        // Navigate to the Blood Pressure Log page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DietLogScreen()),
                        );

                      } else {
                        // Show an error SnackBar with custom style
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please enter valid values'),
                            behavior: SnackBarBehavior.floating, // Custom positioning
                            margin: const EdgeInsets.only(top: 50, left: 16, right: 16), // Position at the top
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.redAccent, // Red color for error
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      backgroundColor: const Color(0xFFFF6363), // Softer red color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 5,
                      side: const BorderSide(
                        color: Color(0xFFFF6363),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Log Blood Pressure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Display the chart for the blood pressure readings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: loggedBloodPressures.isEmpty
                      ? const Center(child: Text('No data available'))
                      : SizedBox(
                          height: 250.0,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 250,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: loggedBloodPressures
                                      .map((e) => FlSpot(
                                            e.date.hour.toDouble(),
                                            e.systolic,
                                          ))
                                      .toList(),
                                  isCurved: false,
                                  barWidth: 2.5,
                                  color: Colors.red,
                                  belowBarData: BarAreaData(show: false),
                                ),
                                LineChartBarData(
                                  spots: loggedBloodPressures
                                      .map((e) => FlSpot(
                                            e.date.hour.toDouble(),
                                            e.diastolic,
                                          ))
                                      .toList(),
                                  isCurved: false,
                                  barWidth: 2.5,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      int hour = value.toInt();
                                      // Format the hour to display AM/PM
                                      String amPm = hour < 12 ? "AM" : "PM";
                                      int displayHour = hour % 12;  // Convert to 12-hour format
                                      if (displayHour == 0) {
                                        displayHour = 12;  // Handle 12 AM and 12 PM
                                      }

                                      return Text(
                                        '$displayHour $amPm',  // Display time in format "12 AM" or "3 PM"
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                    interval: 1, // Display hourly on x-axis
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false, reservedSize: 40),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                // Display logged blood pressure readings for the day
                loggedBloodPressures.isEmpty
                    ? const Center(child: Text('No readings for today'))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: loggedBloodPressures.length,
                          itemBuilder: (context, index) {
                            final reading = loggedBloodPressures[index];
                            String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(reading.date);

                            return ListTile(
                              title: Text(
                                  'Systolic: ${reading.systolic} | Diastolic: ${reading.diastolic}'),
                              subtitle: Text('Date: $formattedDate'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await bloodPressureProvider.deleteBloodPressure(index);
                                },
                              ),
                            );
                          },
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
}
