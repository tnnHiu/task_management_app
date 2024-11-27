import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class FetchEventStatistics extends EventEvent {
  final int month; 

  FetchEventStatistics({required this.month});

}