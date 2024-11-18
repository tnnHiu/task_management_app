import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';
import '../../models/event_model.dart';
import 'event_bloc_event.dart';
import 'event_bloc_state.dart';

class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventBloc() : super(EventInitial()) {
    on<AddEvent>(_onAddEvent);
    on<FetchEventsForDay>(_onFetchEventsForDay);
    on<DeleteEvent>(_onDeleteEvent);
    on<UpdateEvent>(_onUpdateEvent);
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventBlocState> emit) async {
    emit(EventAdding());

    try {
      final eventDetails = event.eventDetails;
      EventModel eventModel = EventModel(
        userId: eventDetails.userId,
        title: eventDetails.title,
        location: eventDetails.location,
        description: eventDetails.description,
        startTime: eventDetails.startTime,
        endTime: eventDetails.endTime,
        smartReminder: eventDetails.smartReminder ?? '',
        repeatOption: eventDetails.repeatOption ?? '',
        repeatEndDate: eventDetails.repeatEndDate,
        repeatEndOption: eventDetails.repeatEndOption,
      );

      await _firestore.collection('events').add(eventModel.toMap());

      // Nếu có tùy chọn nhắc nhở thì thêm thông báo nhắc nhở

      if (!kIsWeb &&
          (Platform.isAndroid || Platform.isIOS) &&
          flutterLocalNotificationsPlugin != null) {
        if (eventDetails.smartReminder != null &&
            eventDetails.smartReminder!.isNotEmpty) {
          debugPrint('Event start time: ${eventDetails.startTime}');
          DateTime reminderTime = _calculateReminderTime(
              eventDetails.startTime, eventDetails.smartReminder);
          await _scheduleNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000, //
            title: eventDetails.title,
            body:
                'Sự kiện: ${eventDetails.title} sẽ bắt đầu vào lúc ${eventDetails.startTime}',
            scheduledTime: reminderTime,
          );
        }
      }

      emit(EventAddedSuccess());
    } catch (e) {
      emit(EventAddedFailure('Lỗi khi thêm sự kiện: $e'));
    }
  }

  Future<void> _onFetchEventsForDay(
      FetchEventsForDay event, Emitter<EventBlocState> emit) async {
    emit(EventLoading());

    try {
      DateTime startOfDay = DateTime(event.selectedDay.year,
          event.selectedDay.month, event.selectedDay.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: event.userId)
          .where('startTime', isGreaterThanOrEqualTo: startOfDay)
          .where('startTime', isLessThan: endOfDay)
          .get();

      List<EventModel> events = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromMap(data, id: doc.id);
      }).toList();

      emit(EventLoaded(events: events));
    } catch (e) {
      emit(EventLoadFailure('Lỗi khi tải sự kiện: $e'));
      print('Error fetching events: $e');
    }
  }

  Future<void> _onDeleteEvent(
      DeleteEvent event, Emitter<EventBlocState> emit) async {
    emit(EventDeleting());
    try {
      await _firestore.collection('events').doc(event.eventId).delete();
      emit(EventDeletedSuccess());
    } catch (e) {
      emit(EventDeletedFailure('Lỗi khi xóa sự kiện: $e'));
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<EventBlocState> emit) async {
    emit(EventUpdating());
    try {
      final docSnapshot =
          await _firestore.collection('events').doc(event.eventId).get();
      if (docSnapshot.exists && docSnapshot['userId'] == event.userId) {
        final Map<String, dynamic> existingData = docSnapshot.data()!;
        final EventModel oldEvent =
            EventModel.fromMap(existingData, id: docSnapshot.id);

        final eventDetails = event.eventDetails;
        EventModel eventModel = EventModel(
          userId: eventDetails.userId,
          title: eventDetails.title,
          location: eventDetails.location,
          description: eventDetails.description,
          startTime: eventDetails.startTime,
          endTime: eventDetails.endTime,
          smartReminder: eventDetails.smartReminder ?? '',
          repeatOption: eventDetails.repeatOption ?? '',
          repeatEndDate: eventDetails.repeatEndDate,
          repeatEndOption: eventDetails.repeatEndOption,
        );

        await _firestore
            .collection('events')
            .doc(event.eventId)
            .update(eventModel.toMap());

        if (!kIsWeb &&
            (Platform.isAndroid || Platform.isIOS) &&
            flutterLocalNotificationsPlugin != null) {
          final int notificationId = event.eventId.hashCode;
          if (oldEvent.smartReminder != eventDetails.smartReminder ||
              oldEvent.startTime != eventDetails.startTime) {
            await flutterLocalNotificationsPlugin?.cancel(notificationId);

            if (eventDetails.smartReminder != null &&
                eventDetails.smartReminder!.isNotEmpty) {
              final DateTime newReminderTime = _calculateReminderTime(
                  eventDetails.startTime, eventDetails.smartReminder);

              await _scheduleNotification(
                id: notificationId,
                title: eventDetails.title,
                body:
                    'Sự kiện: ${eventDetails.title} sẽ bắt đầu vào lúc ${eventDetails.startTime}',
                scheduledTime: newReminderTime,
              );
            }
          }
        }

        emit(EventUpdatedSuccess());
      } else {
        emit(EventUpdatedFailure(
            'Sự kiện không tồn tại hoặc không thuộc về người dùng.'));
      }
    } catch (e) {
      emit(EventUpdatedFailure('Lỗi khi cập nhật sự kiện: $e'));
    }
  }

  // Thông báo nhắc nhở

  DateTime _calculateReminderTime(DateTime startTime, String? smartReminder) {
    DateTime reminderTime = startTime;
    if (smartReminder != null) {
      switch (smartReminder) {
        case 'Sớm 5p':
          reminderTime = startTime.subtract(Duration(minutes: 5));
          debugPrint(reminderTime.toString());
          break;
        case 'Sớm 30p':
          reminderTime = startTime.subtract(Duration(minutes: 30));
          break;
        case 'Sớm 1h':
          reminderTime = startTime.subtract(Duration(hours: 1));
          break;
        case 'Sớm 1 ngày':
          reminderTime = startTime.subtract(Duration(days: 1));
          break;
      }
    }
    return reminderTime;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledTime, tz.local);

    debugPrint(scheduledTime.toString());
    debugPrint(tz.local.toString());

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'event_reminder',
      'Nhắc nhở sự kiện',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound_notification'),
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin?.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
      debugPrint('Notification scheduled for: $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }
}
