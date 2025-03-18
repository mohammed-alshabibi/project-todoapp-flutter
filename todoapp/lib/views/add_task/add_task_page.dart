import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/services/firestore_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime? selectedDate;
  String _selectedPeriodAM = 'AM';
  String _selectedPeriodPM = 'PM';

  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveTaskToFirebase() async {
    print("Task Name: ${_taskController.text}");
    print("Selected Date: $selectedDate");
    print("From Time: ${_fromTimeController.text}");
    print("To Time: ${_toTimeController.text}");
    print("Period From: $_selectedPeriodAM");
    print("Period To: $_selectedPeriodPM");

    if (_taskController.text.isEmpty ||
        selectedDate == null ||
        _fromTimeController.text.isEmpty ||
        _toTimeController.text.isEmpty ||
        _selectedPeriodAM.isEmpty ||
        _selectedPeriodPM.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      await FirestoreService().addTask(
        taskName: _taskController.text,
        taskDate: selectedDate!,
        fromTime: _fromTimeController.text,
        toTime: _toTimeController.text,
        periodFrom: _selectedPeriodAM,
        periodTo: _selectedPeriodPM,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Task added successfully'),
            backgroundColor: Colors.green),
      );

      // Clear stored data
      setState(() {
        _taskController.clear();
        selectedDate = null;
        _fromTimeController.clear();
        _toTimeController.clear();
        _selectedPeriodAM = "AM";
        _selectedPeriodPM = "PM";
      });

      Navigator.pop(
          context, true); // Return true to indicate a new task was added
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Tasks',
          style: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Add Task Widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 86,
                    child: TextField(
                      controller: _taskController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Add Task Here',
                        hintStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                        filled: true,
                        fillColor: const Color(0xFFB5D5F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFFB5D5F8),
                      size: 35.0,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            // Display selected date
            if (selectedDate != null)
              Text(
                "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            // Time Picker
            Row(
              children: [
                Text(
                  "From",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 38,
                  width: 76,
                  child: TextField(
                    controller: _fromTimeController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '9:30',
                      hintStyle: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xFFB5D5F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: _selectedPeriodAM,
                  items: <String>['AM', 'PM'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeriodAM = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  "To",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 38,
                  width: 76,
                  child: TextField(
                    controller: _toTimeController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '12:30',
                      hintStyle: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xFFB5D5F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: _selectedPeriodPM,
                  items: <String>['AM', 'PM'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeriodPM = newValue!;
                    });
                  },
                ),
              ],
            ),

            const Spacer(),
            Container(
              height: 67,
              child: ElevatedButton(
                onPressed: () {
                  _saveTaskToFirebase();
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF4DA0FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
