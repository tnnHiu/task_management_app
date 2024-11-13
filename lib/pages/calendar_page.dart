import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management_app/blocs/calendar/calendar_bloc.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state is CalendarFormatState) {
                return TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2020, 10, 10),
                  lastDay: DateTime.utc(2030, 10, 10),
                  weekNumbersVisible: false,
                  headerVisible: false,
                  calendarFormat: state.currentCalendarFormat,
                  onFormatChanged: (format) {
                    context
                        .read<CalendarBloc>()
                        .add(CalendarFormatEvent(calendarState: format));
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
