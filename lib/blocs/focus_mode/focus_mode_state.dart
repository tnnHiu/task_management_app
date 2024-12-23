part of 'focus_mode_bloc.dart';

abstract class FocusModeState extends Equatable {
  final double percent;
  final String timeStr;
  final bool isRunning;

  const FocusModeState(this.percent, this.timeStr, this.isRunning);

  @override
  List<Object> get props => [timeStr, percent];
}

class FocusModeInitialState extends FocusModeState {
  const FocusModeInitialState(String timeStr, double percent) : super(percent, timeStr, false);
}

class FocusModeRunningState extends FocusModeState {
  const FocusModeRunningState(String timeStr, double percent) : super(percent, timeStr, true);
}

class FocusModePausedState extends FocusModeState {
  const FocusModePausedState(String timeStr, double percent) : super(percent, timeStr, false);
}

class FocusModeResetState extends FocusModeState {
  const FocusModeResetState(String timeStr, double percent, bool isRunning) : super(percent, timeStr, false);
}

class FocusModeCompletedState extends FocusModeState {
  const FocusModeCompletedState() : super(0, '00:00', false);
}
