import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MonthListView extends StatefulWidget {
  @override
  final String selectedMonth;
  final Function(String) onMonthSelected;
  MonthListView({required this.onMonthSelected, required this.selectedMonth});
  _MonthListViewState createState() => _MonthListViewState();
}

class _MonthListViewState extends State<MonthListView> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String selectedMonth = DateFormat("MMMM").format(DateTime.now());
  late ScrollController _scrollController; // Default selected month

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  void _scrollToSelectedMonth() {
    int index = months.indexOf(widget.selectedMonth);
    double position =
        index * 80.0; // Assuming each month container has a width of 80
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: months.map((month) {
          bool isSelected = month == selectedMonth;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = month;
              });
              widget.onMonthSelected(month);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff4DA0FC) : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                month,
                style: GoogleFonts.montserrat(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
