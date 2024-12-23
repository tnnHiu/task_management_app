import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'focus_mode_event.dart';
part 'focus_mode_state.dart';

class FocusModeBloc extends Bloc<FocusModeEvent, FocusModeState> {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _pomodoroDuration = 0;

  FocusModeBloc() : super(FocusModeInitialState('00:00', 0)) {
    on<FocusModeStartEvent>(_onFocusModeStartEvent);
    on<FocusModePauseEvent>(_onFocusModePausedEvent);
    on<FocusModeResetEvent>(_onFocusModeResetEvent);
    on<FocusModeTickedEvent>(_onFocusModeTickedEvent);
    on<FocusModeStopEvent>(_onFocusModeStopEvent);
    on<FocusModeSetTimeEvent>(_onFocusModeSetTimeEvent);
    on<FocusModeCompletedEvent>(_onFocusModeCompletedEvent);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onFocusModeStartEvent(FocusModeStartEvent event, Emitter<FocusModeState> emit) {
    if (_remainingSeconds > 0) {
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            add(FocusModeTickedEvent(timeStr: _calculateTime(_remainingSeconds), percent: _remainingSeconds / _pomodoroDuration));
          } else {
            _timer?.cancel();
            add(FocusModeStopEvent());
          }
        },
      );
    }
  }

  void _onFocusModePausedEvent(FocusModePauseEvent event, Emitter<FocusModeState> emit) {
    if (state is FocusModeRunningState) {
      _timer?.cancel();
      emit(FocusModePausedState(_calculateTime(_remainingSeconds), _remainingSeconds / _pomodoroDuration));
    }
  }

  void _onFocusModeResetEvent(FocusModeResetEvent event, Emitter<FocusModeState> emit) {
    _timer?.cancel();
    _remainingSeconds = _pomodoroDuration;
    emit(FocusModeResetState(_calculateTime(_remainingSeconds), _remainingSeconds / _pomodoroDuration, false));
  }

  void _onFocusModeTickedEvent(FocusModeTickedEvent event, Emitter<FocusModeState> emit) {
    emit(FocusModeRunningState(event.timeStr, 1 - event.percent));
  }

  void _onFocusModeStopEvent(FocusModeStopEvent event, Emitter<FocusModeState> emit) {
    add(FocusModeCompletedEvent(
      pomodoroDuration: _pomodoroDuration,
      userId: FirebaseAuth.instance.currentUser!.uid,
    ));
    emit(const FocusModeCompletedState());
  }

  void _onFocusModeSetTimeEvent(FocusModeSetTimeEvent event, Emitter<FocusModeState> emit) {
    _remainingSeconds = event.minutes * 60 + event.seconds;
    _pomodoroDuration = _remainingSeconds;
    emit(FocusModeInitialState(_calculateTime(_remainingSeconds), 0));
  }

  void _onFocusModeCompletedEvent(FocusModeCompletedEvent event, Emitter<FocusModeState> emit) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final duration = event.pomodoroDuration;

      // Lưu dữ liệu Pomodoro vào Firestore
      await firestore.collection('pomodoros').add({
        'userId': userId,
        'duration': duration,
        'completedAt': Timestamp.now(),
      });

      // Hiển thị thông báo thành công (hoặc không cần nếu không cần)
      print('Pomodoro completed and saved to Firestore');
    } catch (e) {
      print('Error saving Pomodoro to Firestore: $e');
    }
  }


  static String _calculateTime(int remainingSeconds) {
    var minuteStr = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    var secondStr = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minuteStr:$secondStr";
  }
}
