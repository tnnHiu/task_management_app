import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(CalendarFormatState(
          currentCalendarFormat: CalendarFormat.month,
        )) {
    on<CalendarFormatEvent>((event, emit) {
      emit(CalendarFormatState(currentCalendarFormat: event.calendarState));
    });
  }
}




