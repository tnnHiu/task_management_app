import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String? userId;
  final String? id;
  final String title;
  final String location;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? smartReminder;
  final String? repeatOption;
  final DateTime? repeatEndDate;
  final String? repeatEndOption;
  final String status;

  // Khởi tạo sự kiện
  EventModel({
    required this.userId,
    this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.smartReminder,
    this.repeatOption,
    this.repeatEndDate,
    this.repeatEndOption,
    this.status = 'active',
  });

  // Chuyển model sang Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'location': location,
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'smartReminder': smartReminder,
      'repeatOption': repeatOption,
      'repeatEndDate':
          repeatEndDate != null ? Timestamp.fromDate(repeatEndDate!) : null,
      'repeatEndOption': repeatEndOption,
      'status': status,
    };
  }

  // Khởi tạo sự kiện từ map (Firebase)
  factory EventModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return EventModel(
      userId: map['userId'],
      id: id,
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      startTime: map['startTime'] != null
          ? (map['startTime'] as Timestamp).toDate()
          : DateTime.now(),
      endTime: map['endTime'] != null
          ? (map['endTime'] as Timestamp).toDate()
          : DateTime.now(),
      smartReminder: map['smartReminder'],
      repeatOption: map['repeatOption'],
      repeatEndDate: map['repeatEndDate'] != null
          ? (map['repeatEndDate'] as Timestamp).toDate()
          : null,
      repeatEndOption: map['repeatEndOption'],
      status: map['status'] ?? 'active',
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        location,
        description,
        startTime,
        endTime,
        smartReminder,
        repeatOption,
        repeatEndDate,
        repeatEndOption
      ];
}
