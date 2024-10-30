import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2020, 10, 10),
            lastDay: DateTime.utc(2030, 10, 10),
            weekNumbersVisible: false,
            headerVisible: false,
          ),
        ],
      ),
    );
  }
}
