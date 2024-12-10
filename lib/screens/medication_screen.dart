import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_eatanong_flutter/providers/medication_provider.dart';
import 'package:final_eatanong_flutter/models/medication_reminder.dart';
import 'package:final_eatanong_flutter/screens/nav_bar.dart';

class MedicationLoggerScreen extends StatefulWidget {
  const MedicationLoggerScreen({super.key});

  @override
  _MedicationLoggerScreenState createState() => _MedicationLoggerScreenState();
}

class _MedicationLoggerScreenState extends State<MedicationLoggerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context);
    final allReminders = medicationProvider.getAllMedicationReminders();
    final incompleteReminders = allReminders.where((reminder) => !reminder.isTaken).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 198, 255, 220),
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
                  _buildLoggedMedications(incompleteReminders, medicationProvider),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const NavBar(),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height to 80% of the screen
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for the keyboard
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                              focusedBorder: const UnderlineInputBorder(
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
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Special Instructions input (optional)
                          TextField(
                            controller: _specialInstructionsController,
                            decoration: InputDecoration(
                              labelText: 'Special Instructions (optional)',
                              labelStyle: TextStyle(color: Colors.green.shade700),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Time selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Time: ${_selectedTime.format(context)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                child: const Text(
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
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.green.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _addMedicationReminder(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
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
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addMedicationReminder(BuildContext context) {
    // Check if any of the fields are empty
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid medication name and dosage.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
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
        specialInstructions: _specialInstructionsController.text.isNotEmpty
            ? _specialInstructionsController.text
            : null, 
      ),
    );

    // Clear the text fields
    _nameController.clear();
    _dosageController.clear();
    _specialInstructionsController.clear();
    Navigator.pop(context);
  }

  Widget _buildLoggedMedications(
    List<MedicationReminder> loggedMedications, 
    MedicationProvider medicationProvider) {
    if (loggedMedications.isEmpty) {
      return const Center(
        child: Text(
          'No logged medications for today.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    
    return ListView.builder(
      itemCount: loggedMedications.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        final reminder = loggedMedications[index];
        final isOverdue = DateTime.now().isAfter(reminder.time) && !reminder.isTaken;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              reminder.name,
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.black,
                decoration: reminder.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dosage: ${reminder.dosage}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.black,
                    decoration: reminder.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                if (reminder.specialInstructions != null && reminder.specialInstructions!.isNotEmpty)
                  Text(
                    'Special Instructions: ${reminder.specialInstructions}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: isOverdue ? Colors.red : Colors.black,
                      decoration: reminder.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                Text(
                  'Time: ${TimeOfDay.fromDateTime(reminder.time).format(ctx)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.black,
                    decoration: reminder.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(reminder.isTaken ? Icons.check_circle : Icons.check_circle_outline),
              onPressed: () {
                medicationProvider.toggleMedicationTakenStatus(index);
              },
            ),
          ),
        );
      },
    );
  }
}
