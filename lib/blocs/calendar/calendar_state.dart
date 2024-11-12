part of 'calendar_bloc.dart';

abstract class CalendarState {}

class CalendarFormatState extends CalendarState {
  final CalendarFormat currentCalendarFormat;

  CalendarFormatState({required this.currentCalendarFormat});
}
