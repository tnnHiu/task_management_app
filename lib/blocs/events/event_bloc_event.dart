import 'package:equatable/equatable.dart';

abstract class EventBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventDetails {
  final String userId;
  final String title;
  final String location;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? smartReminder;
  final String? repeatOption;
  final DateTime? repeatEndDate;
  final String? repeatEndOption;

  EventDetails({
    required this.userId, 
    required this.title,
    required this.location,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.smartReminder,
    this.repeatOption,
    this.repeatEndDate,
    this.repeatEndOption,
  });
}

class AddEvent extends EventBlocEvent {
  final String userId; 
  final EventDetails eventDetails;

  AddEvent({ required this.userId, required this.eventDetails});

  @override
  List<Object?> get props => [userId, eventDetails];
}

class UpdateEvent extends EventBlocEvent {
  final String userId;
  final String eventId;
  final EventDetails eventDetails;

  UpdateEvent({required this.userId, required this.eventId, required this.eventDetails});

  @override
  List<Object?> get props => [userId, eventId, eventDetails];
}

class FetchEventsForDay extends EventBlocEvent {
  final String userId;
  final DateTime selectedDay;

  // FetchEventsForDay(this.selectedDay);
  FetchEventsForDay({required this.userId, required this.selectedDay});

  @override
  List<Object?> get props => [userId, selectedDay];
}

class DeleteEvent extends EventBlocEvent {
  final String userId;
  final String eventId;

  // DeleteEvent({required this.eventId});
  DeleteEvent({required this.userId, required this.eventId});

  @override
  List<Object?> get props => [userId, eventId];
}

class LoadEvent extends EventBlocEvent {
  final String userId;
  final String eventId;

  // LoadEvent({required this.eventId});
  LoadEvent({required this.userId, required this.eventId});

  @override
  List<Object?> get props => [userId, eventId];
}
