import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/services/firestore_service.dart';

class TaskTile extends StatefulWidget {
  final String taskId; // Add taskId parameter
  final String taskName;
  final String fromTime;
  final String toTime;
  final String periodAM;
  final String periodPM;
  final bool isCompleted;
  DateTime? selectedDate;

  TaskTile({
    Key? key,
    required this.taskId, // Add taskId parameter
    required this.taskName,
    required this.fromTime,
    required this.toTime,
    required this.periodAM,
    required this.periodPM,
    required this.isCompleted,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late bool isCompleted;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference taskId =
      FirebaseFirestore.instance.collection('tasks');

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.taskId),
      direction: DismissDirection.endToStart, // Allow only right to left swipe
      onDismissed: (direction) async {
        await _firestoreService.deleteTask(widget.taskId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.taskName} Task Deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          height: 99,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  widget.taskName,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4DA0FC),
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: isCompleted ? Color(0xFF4DA0FC) : null,
                  ),
                ),
                subtitle: Text(
                    widget.fromTime +
                        ' ' +
                        widget.periodAM +
                        ' - ' +
                        widget.toTime +
                        ' ' +
                        widget.periodPM,
                    style: GoogleFonts.montserrat(
                        color: Color(0xFFB9B9B9),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                trailing: Transform.scale(
                  scale: 2.2,
                  child: Checkbox(
                    side: BorderSide.none,
                    shape: const CircleBorder(side: BorderSide()),
                    value: isCompleted,
                    onChanged: (value) async {
                      setState(() {
                        isCompleted = value!;
                      });
                      await _firestoreService.updateTaskCompletion(
                          widget.taskId, isCompleted);
                    },
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Color(0xff18C360); // Color when selected
                      }
                      return const Color(0xFFB5D5F8); // Default color
                    }),
                    activeColor: const Color(0xFF007AFF),
                    checkColor: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
