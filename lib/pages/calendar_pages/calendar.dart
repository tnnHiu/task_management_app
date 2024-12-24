import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '/blocs/events/event_bloc.dart';
import '/blocs/events/event_bloc_event.dart';
import '/blocs/events/event_bloc_state.dart';
import '../../../pages/event_pages/edit_event_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424),
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF353535),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // final formattedSelectedDay = DateFormat('yyyy-MM-dd').format(selectedDay);
                // _logDateToFirebase(formattedSelectedDay);
                final userId = FirebaseAuth.instance.currentUser?.uid;

                if (userId != null) {
                  context.read<EventBloc>().add(FetchEventsForDay(
                      selectedDay: selectedDay, userId: userId));
                } else {
                  print("User is not logged in.");
                }
              },
              calendarStyle: CalendarStyle(
                todayDecoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.red),
                outsideTextStyle: TextStyle(color: Colors.grey),
                selectedTextStyle: TextStyle(color: Colors.white),
                // todayTextStyle: TextStyle(color: Colors.blue),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false, // Ẩn nút "2 weeks"
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<EventBloc, EventBlocState>(
                builder: (context, state) {
              if (state is EventLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is EventLoaded) {
                final eventsForDay = state.events.where((event) {
                  final selectedDateOnly = DateTime(
                      _selectedDay.year, _selectedDay.month, _selectedDay.day);
                  final eventDateOnly = DateTime(event.startTime.year,
                      event.startTime.month, event.startTime.day);
                  return selectedDateOnly == eventDateOnly;
                }).toList();

                return ListView.builder(
                  itemCount: eventsForDay.length,
                  itemBuilder: (context, index) {
                    final event = eventsForDay[index];
                    return EventTile(event: event);
                  },
                );
              } else if (state is EventLoadFailure) {
                return Center(
                    child: Text('Lỗi khi tải sự kiện: ${state.errorMessage}',
                        style: TextStyle(color: Colors.white)));
              } else {
                return Center(
                    child: Text('Chọn một ngày để xem sự kiện',
                        style: TextStyle(color: Colors.white)));
              }
            }),
          ),
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final event;

  EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Color(0xFF353535),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(event.title, style: TextStyle(color: Colors.white)),
          Text(DateFormat('HH:mm').format(event.startTime),
              style: TextStyle(color: Colors.orange)),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return EventDetailDialog(event: event);
          },
        );
      },
    );
  }
}

class EventDetailDialog extends StatelessWidget {
  final event;

  const EventDetailDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.title,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEventPage(
                              event: event,
                            )),
                  );
                  print("ID sự kiện: ${event.id}");
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
              '${DateFormat('dd/MM/yyyy').format(event.startTime)} - ${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 20),
          OptionRow(
              label: 'Lời nhắc', value: event.smartReminder ?? 'Không có'),
          OptionRow(label: 'Lặp lại', value: event.repeatOption ?? 'Không có'),
        ],
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  final String label;
  final String value;

  OptionRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
