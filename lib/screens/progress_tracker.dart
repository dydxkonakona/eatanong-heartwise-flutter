import 'package:final_eatanong_flutter/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:provider/provider.dart';

class ProgressTracker extends StatefulWidget {
  @override
  _ProgressTrackerState createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final now = DateTime.now();

    Map<String, double> macros = {};
    double sodium = 0;
    double cholesterol = 0;
    bool hasData = false;

    if (selectedDateRange != null) {
      macros = foodProvider.calculateDailyMacrosInRange(selectedDateRange!);
      sodium = macros['sodium'] ?? 0;
      cholesterol = macros['cholesterol'] ?? 0;

      if (sodium > 0 || cholesterol > 0) hasData = true;

      sodium = sodium.isNaN ? 0 : sodium;
      cholesterol = cholesterol.isNaN ? 0 : cholesterol;
    }

    double maxValue = [sodium, cholesterol].reduce((a, b) => a > b ? a : b);
    double maxY = (maxValue / 10).ceil() * 10 + 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6363),
                            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: now,
                              initialDateRange: selectedDateRange,
                            );

                            if (picked != null && picked != selectedDateRange) {
                              setState(() {
                                selectedDateRange = picked;
                              });
                            }
                          },
                          child: Text(
                            selectedDateRange == null
                                ? "Select Date Range"
                                : "Selected Range: ${DateFormat.yMMMd().format(selectedDateRange!.start)} - ${DateFormat.yMMMd().format(selectedDateRange!.end)}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      if (selectedDateRange == null)
                        Center(child: Text("Please select a date range to see the chart.")),
                      if (selectedDateRange != null && !hasData)
                        Center(
                          child: Text(
                            "No data available for the selected range.",
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      if (selectedDateRange != null && hasData)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Macronutrient Distribution",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.7,
                                child: PieChart(
                                  PieChartData(
                                    sections: showingSections(macros),
                                    borderData: FlBorderData(show: false),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 30),
                      if (selectedDateRange != null && hasData)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sodium and Cholesterol Intake",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 250,
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.3),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Padding(
                                        padding: const EdgeInsets.only(bottom: 0.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          if (value == 0) {
                                            return Text(
                                              'Sodium',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                  fontSize: 14),
                                            );
                                          } else if (value == 1) {
                                            return Text(
                                              'Cholesterol',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.pink,
                                                  fontSize: 14),
                                            );
                                          }
                                          return Container();
                                        },
                                        reservedSize: 40,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameWidget: Text('Total amount consumed (mg)'),
                                      sideTitles: SideTitles(
                                        reservedSize: 40,
                                        showTitles: false,
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: [
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(toY: sodium, color: Colors.teal, width: 25),
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(toY: cholesterol, color: Colors.pink, width: 25),
                                    ]),
                                  ],
                                  minY: 0,
                                  maxY: maxY,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: NavBar(),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> macros) {
    double totalMacros = (macros['protein'] ?? 0) +
        (macros['carbohydrates'] ?? 0) +
        (macros['fat'] ?? 0);
    if (totalMacros == 0) {
      return [];
    }

    double proteinPercentage =
        ((macros['protein'] ?? 0) / totalMacros) * 100;
    double carbsPercentage =
        ((macros['carbohydrates'] ?? 0) / totalMacros) * 100;
    double fatPercentage = ((macros['fat'] ?? 0) / totalMacros) * 100;

    return [
      PieChartSectionData(
        value: proteinPercentage,
        title: '${proteinPercentage.toStringAsFixed(1)}%\nProtein',
        radius: 50,
        color: Colors.blue,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
      ),
      PieChartSectionData(
        value: carbsPercentage,
        title: '${carbsPercentage.toStringAsFixed(1)}%\nCarbs',
        radius: 50,
        color: Colors.orange,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
      ),
      PieChartSectionData(
        value: fatPercentage,
        title: '${fatPercentage.toStringAsFixed(1)}%\nFat',
        radius: 50,
        color: Colors.green,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ];
  }
}
