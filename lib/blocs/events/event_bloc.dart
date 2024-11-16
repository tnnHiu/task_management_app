import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        // Thêm userId vào đây
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
        emit(EventUpdatedSuccess());
      } else {
        emit(EventUpdatedFailure(
            'Sự kiện không tồn tại hoặc không thuộc về người dùng.'));
      }
    } catch (e) {
      emit(EventUpdatedFailure('Lỗi khi cập nhật sự kiện: $e'));
    }
  }
}
