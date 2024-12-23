part of 'focus_mode_bloc.dart';

abstract class FocusModeEvent extends Equatable {
  const FocusModeEvent();

  @override
  List<Object> get props => [];
}

class FocusModeStartEvent extends FocusModeEvent {}

class FocusModePauseEvent extends FocusModeEvent {}

class FocusModeResetEvent extends FocusModeEvent {}

class FocusModeStopEvent extends FocusModeEvent {}

class FocusModeTickedEvent extends FocusModeEvent {
  final String timeStr;
  final double percent;

  const FocusModeTickedEvent({
    required this.timeStr,
    required this.percent,
  });

  @override
  List<Object> get props => [timeStr];
}


class FocusModeSetTimeEvent extends FocusModeEvent {
  final int minutes;
  final int seconds;

  const FocusModeSetTimeEvent({required this.minutes, required this.seconds});

  @override
  List<Object> get props => [minutes, seconds];
}

class FocusModeCompletedEvent extends FocusModeEvent {
  final int pomodoroDuration;
  final String userId;

  const FocusModeCompletedEvent({
    required this.pomodoroDuration,
    required this.userId,
  });

  @override
  List<Object> get props => [pomodoroDuration, userId];
}
