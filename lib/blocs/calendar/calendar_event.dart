part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class CalendarFormatEvent extends CalendarEvent {
  final CalendarFormat calendarState;

  CalendarFormatEvent({required this.calendarState});
}


