import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TaskBloc() : super(TaskInitial()) {
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FetchTasksEvent>(_onFetchTasks);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
  }

  // Fetch tasks
  Future<List<TaskModel>> _fetchTasks() async {
    final snapshot = await _firestore
        .collection("tasks")
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> _onFetchTasks(
      FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _fetchTasks();
      if (tasks.isNotEmpty) {
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskEmpty());
      }
    } catch (e) {
      emit(TaskError("Failed to fetch tasks: $e"));
    }
  }

  // Add task
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await _firestore.collection('tasks').add({
        'name': event.name,
        'description': event.description,
        'priority': event.priority,
        'status': event.status,
        'deadline': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.parse(event.deadline).millisecondsSinceEpoch),
        "userId": _auth.currentUser!.uid,
      });
      emit(TaskAdded());
      emit(TaskLoaded(await _fetchTasks()));
    } catch (e) {
      emit(TaskError("Failed to add task: $e"));
    }
  }

// Update task
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await _firestore
          .collection("tasks")
          .doc(event.updatedTask.id)
          .update(event.updatedTask.toMap());
      emit(TaskLoaded(await _fetchTasks()));
    } catch (e) {
      emit(TaskError("Failed to update task: $e"));
    }
  }

// Delete task
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await _firestore.collection("tasks").doc(event.taskId).delete();
      emit(TaskLoaded(await _fetchTasks()));
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }

// Toggle task completion
  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    try {
      await _firestore.collection('tasks').doc(event.taskId).update({
        'status': event.isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành',
      });
      add(FetchTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to toggle task completion: $e'));
    }
  }
}
