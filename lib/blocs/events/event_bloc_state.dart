import 'package:equatable/equatable.dart';
import '../../models/event_model.dart';

abstract class EventBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventBlocState {}

class EventAdding extends EventBlocState {}

class EventAddedSuccess extends EventBlocState {}

class EventAddedFailure extends EventBlocState {
  final String errorMessage;

  EventAddedFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class EventLoading extends EventBlocState {}

class EventLoaded extends EventBlocState {
  final List<EventModel> events;

  EventLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventLoadFailure extends EventBlocState {
  final String errorMessage;

  EventLoadFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class EventDeleting extends EventBlocState {}

class EventDeletedSuccess extends EventBlocState {}

class EventDeletedFailure extends EventBlocState {
  final String message;
  EventDeletedFailure(this.message);
}

class EventUpdatedSuccess extends EventBlocState {}
class EventUpdatedFailure extends EventBlocState {
  final String errorMessage;
  EventUpdatedFailure(this.errorMessage);
}
class EventUpdating extends EventBlocState {}




