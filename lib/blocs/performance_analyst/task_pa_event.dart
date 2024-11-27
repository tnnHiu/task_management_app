abstract class StatisticsEvent {}

class FetchStatisticsEvent extends StatisticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  FetchStatisticsEvent({required this.startDate, required this.endDate});
}

