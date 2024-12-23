import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/performance_analyst/focus_pa_state.dart';
import '../../blocs/performance_analyst/focus_pa_event.dart';

class PomodoroStatsBloc extends Bloc<PomodoroStatsEvent, PomodoroStatsState> {
  final FirebaseFirestore firestore;
  final String userId;

  PomodoroStatsBloc({required this.firestore, required this.userId})
      : super(PomodoroStatsInitial()) {
    on<FetchPomodoroStatsEvent>(_onFetchPomodoroStats);
    on<FetchTodayPomodoroStatsEvent>(_onFetchTodayPomodoroStats);
  }

  Future<void> _onFetchPomodoroStats(
    FetchPomodoroStatsEvent event, Emitter<PomodoroStatsState> emit) async {
  try {
    emit(PomodoroStatsLoading());

    final querySnapshot = await firestore
        .collection('pomodoros')
        .where('userId', isEqualTo: userId)
        .get();

//
    List<Map<String, dynamic>> detailedStats = querySnapshot.docs.map((doc) {
      final completedAt = (doc['completedAt'] as Timestamp).toDate();
      final durationInSeconds = doc['duration'] as int;
      final startTime = completedAt.subtract(Duration(seconds: durationInSeconds));
      
      return {
        'date': "${startTime.year}-${startTime.month}-${startTime.day}",
        'startTime': "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}",
        'endTime': "${completedAt.hour}:${completedAt.minute.toString().padLeft(2, '0')}",
        'duration': durationInSeconds
      };
    }).toList();

    int totalDuration = querySnapshot.docs
        .map((doc) => doc['duration'] as int)
        .fold(0, (sum, duration) => sum + duration);

    final currentState = state;
    if (currentState is PomodoroStatsLoaded) {
      emit(PomodoroStatsLoaded(
        totalPomodoros: querySnapshot.docs.length,
        totalDuration: totalDuration,
        todayPomodoros: currentState.todayPomodoros,
        todayDuration: currentState.todayDuration,
        detailedStats: detailedStats
      ));
    } else {
      emit(PomodoroStatsLoaded(
        totalPomodoros: querySnapshot.docs.length,
        totalDuration: totalDuration,
        todayPomodoros: 0,
        todayDuration: 0,
        detailedStats: detailedStats
      ));
    }
  } catch (e) {
    print("Caught error in Bloc: $e");
    emit(PomodoroStatsError("Failed to fetch pomodoro stats: $e"));
  }
}

Future<void> _onFetchTodayPomodoroStats(
    FetchTodayPomodoroStatsEvent event, Emitter<PomodoroStatsState> emit) async {
  try {
    emit(PomodoroStatsLoading());

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final querySnapshot = await firestore
        .collection('pomodoros')
        .where('userId', isEqualTo: userId)
        .where('completedAt', isGreaterThanOrEqualTo: startOfDay)
        .where('completedAt', isLessThan: endOfDay)
        .get();

    int todayDuration = querySnapshot.docs
        .map((doc) => doc['duration'] as int)
        .fold(0, (sum, duration) => sum + duration);

    // Lấy state hiện tại
    final currentState = state;
    if (currentState is PomodoroStatsLoaded) {
      emit(PomodoroStatsLoaded(
        totalPomodoros: currentState.totalPomodoros,
        totalDuration: currentState.totalDuration,
        todayPomodoros: querySnapshot.docs.length,
        todayDuration: todayDuration,
        // detailedStats: currentState.detailedStats,
        detailedStats: [],
      ));
    } else {
      emit(PomodoroStatsLoaded(
        totalPomodoros: 0,
        totalDuration: 0,
        todayPomodoros: querySnapshot.docs.length,
        todayDuration: todayDuration,
        detailedStats: [],
      ));
    }
  } catch (e) {
    print("Caught error in Bloc: $e");
    emit(PomodoroStatsError("Failed to fetch today's pomodoro stats: $e"));
  }
}

}
