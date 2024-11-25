import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/medication_provider.dart';
import 'package:final_eatanong_flutter/models/medication_reminder.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class MedicationLoggerScreen extends StatefulWidget {
  @override
  _MedicationLoggerScreenState createState() => _MedicationLoggerScreenState();
}

class _MedicationLoggerScreenState extends State<MedicationLoggerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context);

    final DateTime normalizedSelectedDay = DateTime.now(); // Current date
    final loggedMedications = medicationProvider.getMedicationRemindersForDay(normalizedSelectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Logger', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 198, 255, 220), // Custom color for AppBar
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddMedicationDialog(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      backgroundColor: const Color(0xFF63FFA3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Add Medication Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLoggedMedications(loggedMedications, medicationProvider),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: NavBar(),
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dialog title
                    Text(
                      'Add Medication',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Medication Name input
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Medication Name',
                        labelStyle: TextStyle(color: Colors.green.shade700),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dosage input
                    TextField(
                      controller: _dosageController,
                      decoration: InputDecoration(
                        labelText: 'Dosage',
                        labelStyle: TextStyle(color: Colors.green.shade700),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time: ${_selectedTime.format(context)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade800,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setDialogState(() {
                                _selectedTime = picked;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text(
                            'Choose Time',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.green.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        // Add Button
                        ElevatedButton(
                          onPressed: () => _addMedicationReminder(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addMedicationReminder(BuildContext context) {
    // Check if any of the fields are empty
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) {
      // Show a warning Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid medication name and dosage.'),
          backgroundColor: Colors.redAccent, // Warning color
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // If inputs are valid, add the medication reminder
    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final DateTime now = DateTime.now();

    provider.addMedicationReminder(
      MedicationReminder(
        name: _nameController.text,
        dosage: _dosageController.text,
        time: DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute),
      ),
    );

    // Show success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medication reminder added: ${_nameController.text}'),
        backgroundColor: Colors.green, // Success color
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Close the dialog and clear inputs
    Navigator.pop(context);
    _nameController.clear();
    _dosageController.clear();
  }


  Widget _buildLoggedMedications(List<MedicationReminder> loggedMedications, MedicationProvider medicationProvider) {
    if (loggedMedications.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No medications logged for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: loggedMedications.length,
      itemBuilder: (context, index) {
        final medication = loggedMedications[index];
        final timeString = TimeOfDay.fromDateTime(medication.time).format(context);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Dosage: ${medication.dosage}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Time: $timeString',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      medicationProvider.deleteMedicationReminder(index);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
