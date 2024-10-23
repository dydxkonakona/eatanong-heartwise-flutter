  import 'package:flutter/material.dart';
  import 'package:table_calendar/table_calendar.dart';
  import 'package:hive/hive.dart';
  import 'package:final_eatanong_flutter/models/daily_totals.dart';
  import 'package:final_eatanong_flutter/models/logged_food.dart';
  import 'package:final_eatanong_flutter/screens/nav_bar.dart';

  class DietLogScreen extends StatefulWidget {
    @override
    _DietLogScreenState createState() => _DietLogScreenState();
  }

  class _DietLogScreenState extends State<DietLogScreen> {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    DailyTotals? _dailyTotals;
    List<LoggedFood> _loggedFoods = [];

    @override
    void initState() {
      super.initState();
      _loadDailyTotals();
      _loadLoggedFoods();
    }

    void _loadDailyTotals() {
      final dailyTotalsBox = Hive.box<DailyTotals>('dailyTotalsBox');
      setState(() {
        _dailyTotals = dailyTotalsBox.get(_selectedDay ?? _focusedDay) ?? DailyTotals(date: _focusedDay);
      });
    }

    void _loadLoggedFoods() {
      final loggedFoodsBox = Hive.box<LoggedFood>('loggedFoodsBox');
      setState(() {
        _loggedFoods = loggedFoodsBox.values
            .where((food) => isSameDay(food.date, _selectedDay ?? _focusedDay))
            .toList();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Log'),
          actions: [
            // IconButton(icon: Icon(Icons.lock), onPressed: () {}),
            // IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
          ],
        ),
        drawer: NavBar(),
        body: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 16),
            _buildNutritionalSummary(),
            _buildMealLogSection(),
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
            _loadDailyTotals();
            _loadLoggedFoods();
          });
        },
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          formatButtonShowsNext: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          // Customize the style for the days of the week labels
          weekdayStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold), // You can adjust font size
          weekendStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 171, 165),
            shape: BoxShape.circle,
          ),
          // Add more padding to the cells to prevent overlapping
          cellMargin: EdgeInsets.all(6.0), // Increase the padding around each day
          defaultTextStyle: TextStyle(fontSize: 16), // Adjust font size of the date numbers
          weekendTextStyle: TextStyle(fontSize: 16, color: Colors.redAccent), // Adjust for weekends
        ),
        rowHeight: 45,
      );
    }

    Widget _buildNutritionalSummary() {
      const double calorieGoal = 0;
      const double carbsGoal = 0;
      const double fatGoal = 0;
      const double proteinGoal = 0;
      const double sodiumGoal = 0;
      const double cholesterolGoal = 0;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildHeaderRow(),
            _buildGoalRow("Calories", "$calorieGoal Cal", "${_dailyTotals?.totalCalories ?? 0} Cal", "${calorieGoal - (_dailyTotals?.totalCalories ?? 0)} Cal"),
            _buildGoalRow("Total Carbs", "$carbsGoal g", "${_dailyTotals?.totalCarbohydrates ?? 0} g", "${carbsGoal - (_dailyTotals?.totalCarbohydrates ?? 0)} g"),
            _buildGoalRow("Fat", "$fatGoal g", "${_dailyTotals?.totalFat ?? 0} g", "${fatGoal - (_dailyTotals?.totalFat ?? 0)} g"),
            _buildGoalRow("Protein", "$proteinGoal g", "${_dailyTotals?.totalProtein ?? 0} g", "${proteinGoal - (_dailyTotals?.totalProtein ?? 0)} g"),
            _buildGoalRow("Sodium", "$sodiumGoal mg", "${_dailyTotals?.totalSodium ?? 0} mg", "${sodiumGoal - (_dailyTotals?.totalSodium ?? 0)} mg"),
            _buildGoalRow("Cholesterol", "$cholesterolGoal mg", "${_dailyTotals?.totalCholesterol ?? 0} mg", "${cholesterolGoal - (_dailyTotals?.totalCholesterol ?? 0)} mg"),
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

    Widget _buildMealLogSection() {
      return Expanded(
        child: ListView.builder(
          itemCount: _loggedFoods.length,
          itemBuilder: (context, index) {
            final food = _loggedFoods[index];
            return ListTile(
              title: Text(food.foodName),
              subtitle: Text("${food.quantity}g"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    Hive.box<LoggedFood>('loggedFoodsBox').deleteAt(index);
                    _loadLoggedFoods(); // Reload after deletion
                  });
                },
              ),
            );
          },
        ),
      );
    }
  }
