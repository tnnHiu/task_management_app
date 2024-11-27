import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/task_model.dart';
import 'task_pa_event.dart';
import 'task_pa_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StatisticsBloc() : super(StatisticsInitial()) {
    on<FetchStatisticsEvent>(_onFetchStatistics);
  }

  Future<void> _onFetchStatistics(
      FetchStatisticsEvent event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(StatisticsError("User not logged in"));
        return;
      }

      final tasksQuery = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      final tasks = tasksQuery.docs.map((doc) => TaskModel.fromMap(doc.data(), doc.id)).toList();

      // Filter tasks by date range
      final filteredTasks = tasks.where((task) {
        final deadline = task.deadline.toDate();
        return deadline.isAfter(event.startDate) && deadline.isBefore(event.endDate);
      }).toList();

      // Count completed tasks
      final completedTasks = tasks.where((task) => task.isCompleted).toList();
      final completedTasksCount = completedTasks.length;

      // Calculate completion rate
      final completionRate = tasks.isEmpty
          ? 0
          : completedTasksCount / tasks.length.toDouble() * 100;

      // Calculate overdue rate
      final overdueTasksCount = tasks.where((task) {
        final now = DateTime.now();
        return task.deadline.toDate().isBefore(now) && !task.isCompleted;
      }).length;
      final overdueRate = tasks.isEmpty
          ? 0
          : overdueTasksCount / tasks.length.toDouble() * 100;

      // Priority statistics
      final priorityStats = {
        "Cao": tasks.where((task) => task.priority == "Cao").length,
        "Vừa": tasks.where((task) => task.priority == "Vừa").length,
        "Thấp": tasks.where((task) => task.priority == "Thấp").length,
        "Không ưu tiên": tasks.where((task) => task.priority == "Không ưu tiên").length,
      };

      final priorityCompletedRates = {
        "Cao": completedTasks.where((task) => task.priority == "Cao" && task.status == "Đã hoàn thành").length,
        "Vừa": completedTasks.where((task) => task.priority == "Vừa" && task.status == "Đã hoàn thành").length,
        "Thấp": completedTasks.where((task) => task.priority == "Thấp" && task.status == "Đã hoàn thành").length,
        "Không ưu tiên": completedTasks.where((task) => task.priority == "Không ưu tiên" && task.status == "Đã hoàn thành").length,
      };

      int getCompletedCountByPriority(List tasks, List completedTasks, String priority) {
        final completedCount = completedTasks.where((task) => task.priority == priority && task.status == "Đã hoàn thành").length;
        final totalCount = tasks.where((task) => task.priority == priority).length;
        return totalCount == 0 ? 0 : completedCount * 100 ~/ totalCount; // Tính tỷ lệ phần trăm hoàn thành
      }

      final completionRatesByPriority = {
        "Cao": getCompletedCountByPriority(tasks, completedTasks, "Cao"),
        "Vừa": getCompletedCountByPriority(tasks, completedTasks, "Vừa"),
        "Thấp": getCompletedCountByPriority(tasks, completedTasks, "Thấp"),
      };



      // Overdue tasks
      final overdueTasks = tasks.where((task) {
        final now = DateTime.now();
        return task.deadline.toDate().isBefore(now) && !task.isCompleted;
      }).toList();

      emit(StatisticsLoaded(
        totalTasksCount: tasks.length,
        completedTasksCount: completedTasksCount,
        completionRate: completionRate.toDouble(),
        overdueRate: overdueRate.toDouble(),
        priorityStats: priorityStats,
        overdueTasks: overdueTasks,
        completionRatesByPriority: completionRatesByPriority,
      ));
    } catch (e) {
      emit(StatisticsError("Failed to fetch statistics: $e"));
    }
  }

  
}
