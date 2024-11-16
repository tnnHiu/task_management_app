import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/focus_pages/focus_page.dart';

part 'focus_mode_event.dart';
part 'focus_mode_state.dart';

class FocusModeBloc extends Bloc<FocusModeEvent, FocusModeState> {
  Timer? _timer;

  // final int _pomodoroDuration;

  final int _pomodoroDuration;
  int _remainingSeconds;

  FocusModeBloc()
      : _pomodoroDuration = 25 * 60,
        //  Sửa thời gian ở đây
        _remainingSeconds = pomodoroDuration,
        super(FocusModeInitialState(_calculateTime(pomodoroDuration), 1)) {
    on<FocusModeStartEvent>(_onFocusModeStartEvent);
    on<FocusModePauseEvent>(_onFocusModePausedEvent);
    on<FocusModeResetEvent>(_onFocusModeResetEvent);
    on<FocusModeTickedEvent>(_onFocusModeTickedEvent);
    on<FocusModeStopEvent>(_onFocusModeStopEvent);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onFocusModeStartEvent(
      FocusModeStartEvent event, Emitter<FocusModeState> emit) {
    if (_remainingSeconds > 0) {
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            add(FocusModeTickedEvent(
              timeStr: _calculateTime(_remainingSeconds),
              percent: _remainingSeconds / _pomodoroDuration,
            ));
          } else {
            _timer?.cancel();
            add(FocusModeStopEvent());
          }
        },
      );
    }
  }

  void _onFocusModePausedEvent(
      FocusModePauseEvent event, Emitter<FocusModeState> emit) {
    if (state is FocusModeRunningState) {
      _timer?.cancel();
      emit(FocusModePausedState(
        _calculateTime(_remainingSeconds),
        _remainingSeconds / _pomodoroDuration,
      ));
    }
  }

  void _onFocusModeResetEvent(
      FocusModeResetEvent event, Emitter<FocusModeState> emit) {
    _timer?.cancel();
    _remainingSeconds = _pomodoroDuration;
    emit(FocusModeResetState(
      _calculateTime(_remainingSeconds),
      _remainingSeconds / _pomodoroDuration,
      state is FocusModeRunningState,
    ));
  }

  void _onFocusModeTickedEvent(
      FocusModeTickedEvent event, Emitter<FocusModeState> emit) {
    emit(FocusModeRunningState(
      event.timeStr,
      1 - event.percent,
    ));
  }

  void _onFocusModeStopEvent(
      FocusModeStopEvent event, Emitter<FocusModeState> emit) {
    emit(const FocusModeCompletedState());
  }

  static String _calculateTime(int remainingSeconds) {
    var minuteStr = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    var secondStr = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minuteStr:$secondStr";
  }
}
