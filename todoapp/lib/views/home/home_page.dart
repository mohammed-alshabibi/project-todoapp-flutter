import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/views/add_task/add_task_page.dart';
import 'package:todoapp/widgets/date_list_view.dart';
import 'package:todoapp/widgets/month_list_view.dart';
import 'package:todoapp/widgets/task_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasksFromFirebase();
  }

  Future<void> _fetchTasksFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tasks').get();
      setState(() {
        tasks = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Ensure taskId is assigned
          data['isCompleted'] =
              data['isCompleted'] ?? false; // Ensure isCompleted is not null
          return data;
        }).toList();
        filteredTasks =
            _filterTasksByDate(selectedDate); // Update filtered tasks
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  List<Map<String, dynamic>> _filterTasksByDate(DateTime date) {
    return tasks.where((task) {
      DateTime taskDate = DateTime.parse(task['taskDate']);
      return taskDate.year == date.year &&
          taskDate.month == date.month &&
          taskDate.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = _filterTasksByDate(selectedDate);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFFADBDD1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Color(0xFF95C8FF),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
              height: 310,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TO DO APP",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text("${DateTime.now().year}",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MonthListView(
                    selectedMonth: selectedMonth,
                    onMonthSelected: (month) {
                      setState(() {
                        selectedMonth = month;
                        selectedDate = DateTime(
                            DateTime.now().year,
                            DateFormat('MMMM').parse(month).month,
                            selectedDate.day);
                        filteredTasks = _filterTasksByDate(selectedDate);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DateListView(
                    selectedMonth: selectedMonth,
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                        filteredTasks = _filterTasksByDate(selectedDate);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text("Tasks List",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if (filteredTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No tasks for this date',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      for (var task in filteredTasks)
                        TaskTile(
                          taskId: task['id'] ?? '', // Ensure taskId is not null
                          taskName: task['taskName'],
                          fromTime: task['fromTime'],
                          toTime: task['toTime'],
                          periodAM: task['periodFrom'],
                          periodPM: task['periodTo'],
                          isCompleted: task['isCompleted'] ??
                              false, // Ensure isCompleted is not null
                        ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Align(
                  alignment: Alignment.center,
                  child: FloatingActionButton(
                    onPressed: () async {
                      // Navigate to AddTaskPage when button is pressed
                      bool? taskAdded = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddTaskPage()),
                      );
                      if (taskAdded == true) {
                        _fetchTasksFromFirebase(); // Refresh the task list
                      }
                    },
                    backgroundColor: Colors.blue, // Customize button color
                    child: const Icon(
                      Icons.add, // Add a "+" icon
                      color: Colors.white, // Icon color
                    ),
                    elevation: 3, // Add subtle elevation for the button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
