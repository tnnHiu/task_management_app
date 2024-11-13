part of 'task_bloc.dart';

abstract class TaskEvent {}

// class AddTaskEvent extends TaskEvent {
//   final TaskModel task;
//
//   AddTaskEvent({required this.task});
// }

class AddTaskEvent extends TaskEvent {
  final String name;
  final String description;
  final String priority;
  final String status;
  final String deadline;

  AddTaskEvent({
    required this.name,
    required this.description,
    required this.priority,
    required this.status,
    required this.deadline,
  });
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel updatedTask;

  UpdateTaskEvent({required this.updatedTask});
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  ToggleTaskCompletionEvent({
    required this.taskId,
    required this.isCompleted,
  });
}

class FetchTasksEvent extends TaskEvent {}
