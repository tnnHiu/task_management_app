import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String name;
  final String description;
  final String priority;
  final String status;
  final Timestamp deadline;
  final String userId;

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.status,
    required this.deadline,
    required this.userId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> taskData, String documentId) {
    return TaskModel(
      id: documentId,
      name: taskData['name'] as String,
      description: taskData['description'] as String,
      priority: taskData['priority'] as String,
      status: taskData['status'] as String,
      deadline: taskData['deadline'] as Timestamp,
      userId: taskData['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'status': status,
      'deadline': deadline,
      'userId': userId,
    };
  }

  bool get isCompleted => status == 'Đã hoàn thành';
}
