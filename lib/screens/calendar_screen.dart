import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/food_provider.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class DietLogScreen extends StatefulWidget {
  @override
  _DietLogScreenState createState() => _DietLogScreenState();
}

class _DietLogScreenState extends State<DietLogScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final dailyMacros = foodProvider.calculateDailyMacros(_selectedDay!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      drawer: NavBar(),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 16),
          _buildNutritionalSummary(dailyMacros),
          _buildMealLogSection(foodProvider),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: const Color.fromARGB(255, 255, 171, 165), shape: BoxShape.circle),
        cellMargin: EdgeInsets.all(6.0),
        defaultTextStyle: TextStyle(fontSize: 16),
        weekendTextStyle: TextStyle(fontSize: 16, color: Colors.redAccent),
      ),
      rowHeight: 45,
    );
  }

  Widget _buildNutritionalSummary(Map<String, double> dailyMacros) {
    const double calorieGoal = 2000;
    const double carbsGoal = 300;
    const double fatGoal = 70;
    const double proteinGoal = 50;
    const double sodiumGoal = 2300;
    const double cholesterolGoal = 300;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildHeaderRow(),
          _buildGoalRow(
            "Calories",
            "$calorieGoal Cal",
            "${dailyMacros['calories']?.toStringAsFixed(1) ?? 0} Cal",
            "${(calorieGoal - (dailyMacros['calories'] ?? 0)).toStringAsFixed(1)} Cal",
          ),
          _buildGoalRow(
            "Total Carbs",
            "$carbsGoal g",
            "${dailyMacros['carbohydrates']?.toStringAsFixed(1) ?? 0} g",
            "${(carbsGoal - (dailyMacros['carbohydrates'] ?? 0)).toStringAsFixed(1)} g",
          ),
          _buildGoalRow(
            "Fat",
            "$fatGoal g",
            "${dailyMacros['fat']?.toStringAsFixed(1) ?? 0} g",
            "${(fatGoal - (dailyMacros['fat'] ?? 0)).toStringAsFixed(1)} g",
          ),
          _buildGoalRow(
            "Protein",
            "$proteinGoal g",
            "${dailyMacros['protein']?.toStringAsFixed(1) ?? 0} g",
            "${(proteinGoal - (dailyMacros['protein'] ?? 0)).toStringAsFixed(1)} g",
          ),
          _buildGoalRow(
            "Sodium",
            "$sodiumGoal mg",
            "${dailyMacros['sodium']?.toStringAsFixed(1) ?? 0} mg",
            "${(sodiumGoal - (dailyMacros['sodium'] ?? 0)).toStringAsFixed(1)} mg",
          ),
          _buildGoalRow(
            "Cholesterol",
            "$cholesterolGoal mg",
            "${dailyMacros['cholesterol']?.toStringAsFixed(1) ?? 0} mg",
            "${(cholesterolGoal - (dailyMacros['cholesterol'] ?? 0)).toStringAsFixed(1)} mg",
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text("Nutrient", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text("Goals", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text("Eaten", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text("Remaining", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildGoalRow(String nutrient, String goal, String eaten, String remaining) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(nutrient)),
        Expanded(child: Text(goal)),
        Expanded(child: Text(eaten)),
        Expanded(child: Text(remaining)),
      ],
    );
  }

  Widget _buildMealLogSection(FoodProvider foodProvider) {
    final loggedFoods = foodProvider.getIntakesForDay(_selectedDay!);

    return Expanded(
      child: ListView.builder(
        itemCount: loggedFoods.length,
        itemBuilder: (context, index) {
          final loggedFood = loggedFoods[index];
          return ListTile(
            title: Text(loggedFood.foodItem.name),
            subtitle: Text("${loggedFood.quantity}g"),
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
  }
}
