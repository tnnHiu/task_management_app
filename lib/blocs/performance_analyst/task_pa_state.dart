import '../../models/task_model.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final int totalTasksCount;
  final int completedTasksCount;
  final double completionRate;
  final double overdueRate;
  final Map<String, int> priorityStats;
  final List<TaskModel> overdueTasks;
  final Map<String, int> completionRatesByPriority;

  StatisticsLoaded({
    required this.totalTasksCount,
    required this.completedTasksCount,
    required this.completionRate,
    required this.overdueRate,
    required this.priorityStats,
    required this.overdueTasks,
    required this.completionRatesByPriority,
  });
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}

