import 'package:equatable/equatable.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final int totalEvents;
  final int participatedEvents;
  final int canceledEvents;
  final double participationRate;
  final double cancellationRate;
  final Duration totalParticipationTime;
  final Duration averageParticipationTime;
  final List<Map<String, dynamic>> participatedEventDetails;
  final List<Map<String, dynamic>> canceledEventDetails;

  const EventLoaded({
    required this.totalEvents,
    required this.participatedEvents,
    required this.canceledEvents,
    required this.participationRate,
    required this.cancellationRate,
    required this.totalParticipationTime,
    required this.averageParticipationTime,
    required this.participatedEventDetails,
    required this.canceledEventDetails,
  });

  @override
  List<Object> get props => [
        totalEvents,
        participatedEvents,
        canceledEvents,
        participationRate,
        cancellationRate,
        totalParticipationTime,
        averageParticipationTime,
      ];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object> get props => [message];
}