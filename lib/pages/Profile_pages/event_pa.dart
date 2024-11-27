import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/performance_analyst/event_pa_bloc.dart';
import '../../blocs/performance_analyst/event_pa_event.dart';
import '../../blocs/performance_analyst/event_pa_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_widget.dart';

class EventStatisticsScreen extends StatefulWidget {
  @override
  _EventStatisticsScreenState createState() => _EventStatisticsScreenState();
}

class _EventStatisticsScreenState extends State<EventStatisticsScreen> {
  int selectedMonth = DateTime.now().month; 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(firestore: FirebaseFirestore.instance)
        ..add(FetchEventStatistics(month: selectedMonth)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thống kê sự kiện"),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF242424),
        ),
        body: Container(
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventLoaded) {
                return Container(
                  color: Color(0xFF353535),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Widget chọn tháng
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: DropdownButton<int>(
                            value: selectedMonth,
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white),
                            items: List.generate(12, (index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text("Tháng ${index + 1}", style: const TextStyle(color: Colors.white)),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value ?? DateTime.now().month;
                              });
                              // Dispatch sự kiện FetchEventStatistics với tháng đã chọn
                              BlocProvider.of<EventBloc>(context).add(FetchEventStatistics(month: selectedMonth));
                            },
                          ),
                        ),
                        // Các phần thống kê sự kiện khác...
                        _buildStatisticCard(
                          title: "Tổng số sự kiện",
                          value: state.totalEvents.toString(),
                        ),
                        _buildStatisticCard(
                          title: "Sự kiện tham gia",
                          value: state.participatedEvents.toString(),
                        ),
                        _buildStatisticCard(
                          title: "Sự kiện bị hủy",
                          value: state.canceledEvents.toString(),
                        ),
                        _buildStatisticCard(
                          title: "Tổng thời gian tham gia",
                          value: _formatDuration(state.totalParticipationTime),
                        ),
                        _buildStatisticCard(
                          title: "Thời gian tham gia trung bình",
                          value: _formatDuration(state.averageParticipationTime),
                        ),
                        SizedBox(
                          height: 500,
                          child: HorizontalBarChart(
                            participationRate: state.participationRate,
                            cancellationRate: state.cancellationRate
                          ),
                        ),
                        _buildStatisticCard(
                          title: "Tỷ lệ tham gia",
                          value: "${state.participationRate.toStringAsFixed(2)}%",
                        ),
                        _buildStatisticCard(
                          title: "Tỷ lệ hủy",
                          value: "${state.cancellationRate.toStringAsFixed(2)}%",
                        ),
                        
                      ],
                    ),
                  ),
                );
              } else if (state is EventError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text("Không có dữ liệu"));
              }
            },
          ),
        ),
      ),
    );
  }
}


  Widget _buildStatisticCard({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }


