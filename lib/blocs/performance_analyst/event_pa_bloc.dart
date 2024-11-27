import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../blocs/performance_analyst/event_pa_event.dart';
import '../../blocs/performance_analyst/event_pa_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EventBloc extends Bloc<EventEvent, EventState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EventBloc({required this.firestore}) : super(EventLoading()) {
    on<FetchEventStatistics>(_onFetchEventStatistics);
  }

  Future<void> _onFetchEventStatistics(
  FetchEventStatistics event, Emitter<EventState> emit) async {
  try {
    emit(EventLoading());
    final userId = _auth.currentUser?.uid;
    final currentDate = DateTime.now();

    // Lọc sự kiện theo tháng
    final querySnapshot = await firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .where('startTime', isGreaterThanOrEqualTo: DateTime(currentDate.year, event.month, 1)) 
        .where('startTime', isLessThan: DateTime(currentDate.year, event.month + 1, 1)) 
        .get();
    
    final events = querySnapshot.docs;

    // Tiến hành tính toán số liệu thống kê
    int totalEvents = events.length;
    int participatedEvents = 0;
    int canceledEvents = 0;
    Duration totalParticipationTime = Duration.zero;

    for (var doc in events) {
      final data = doc.data();
      final status = data['status'] as String? ?? '';
      final startTime = (data['startTime'] as Timestamp?)?.toDate();
      final endTime = (data['endTime'] as Timestamp?)?.toDate();

      if (status == 'active') {
        participatedEvents++;
        if (startTime != null && endTime != null) {
          totalParticipationTime += endTime.difference(startTime);
        }
      } else if (status == 'canceled') {
        canceledEvents++;
      }
    }

    double participationRate = totalEvents > 0
        ? (participatedEvents / totalEvents) * 100
        : 0;
    double cancellationRate = totalEvents > 0
        ? (canceledEvents / totalEvents) * 100
        : 0;
    Duration averageParticipationTime = participatedEvents > 0
        ? totalParticipationTime ~/ participatedEvents
        : Duration.zero;

    emit(EventLoaded(
      totalEvents: totalEvents,
      participatedEvents: participatedEvents,
      canceledEvents: canceledEvents,
      participationRate: participationRate,
      cancellationRate: cancellationRate,
      totalParticipationTime: totalParticipationTime,
      averageParticipationTime: averageParticipationTime,
    ));
  } catch (e) {
    emit(EventError(e.toString()));
  }
}

}
