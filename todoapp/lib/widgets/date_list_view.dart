import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateListView extends StatefulWidget {
  final String selectedMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  DateListView({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateListView> createState() => _DateListViewState();
}

class _DateListViewState extends State<DateListView> {
  late DateTime selectedDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    int index = selectedDate.day - 1;
    double position = index *
        69.0; // Assuming each date container has a width of 61 + 8 (padding)
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> _generateDatesForMonth(String month) {
    int year = DateTime.now().year;
    int monthIndex = DateFormat('MMMM').parse(month).month;
    int daysInMonth = DateTime(year, monthIndex + 1, 0).day;

    return List<DateTime>.generate(
        daysInMonth, (i) => DateTime(year, monthIndex, i + 1));
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget build(BuildContext context) {
    List<DateTime> dates = _generateDatesForMonth(widget.selectedMonth);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: dates.map((date) {
          String day = DateFormat('d').format(date); // Day (e.g., "1")
          String weekday = DateFormat('E').format(date);
          bool isSelected =
              _isSameDate(selectedDate, date); // Weekday (e.g., "Mon")

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              widget.onDateSelected(date);
            },
            child: Row(
              children: [
                Container(
                  height: 92,
                  width: 61,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF4DA0FC) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.montserrat(
                          color: isSelected ? Colors.white : Color(0xFF4DA0FC),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weekday,
                        style: GoogleFonts.montserrat(
                          color: isSelected ? Colors.white : Color(0xFF4DA0FC),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
