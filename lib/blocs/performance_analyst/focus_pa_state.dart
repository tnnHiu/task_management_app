abstract class PomodoroStatsState {}

class PomodoroStatsInitial extends PomodoroStatsState {}

class PomodoroStatsLoading extends PomodoroStatsState {}

class PomodoroStatsLoaded extends PomodoroStatsState {
  final int totalPomodoros;
  final int totalDuration;
  final int todayPomodoros;
  final int todayDuration;
  final List<Map<String, dynamic>> detailedStats;

  PomodoroStatsLoaded({
    required this.totalPomodoros,
    required this.totalDuration,
    required this.todayPomodoros,
    required this.todayDuration,
    required this.detailedStats,
  });
}

class PomodoroStatsError extends PomodoroStatsState {
  final String message;
  
  PomodoroStatsError(this.message);
  
}
