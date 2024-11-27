import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/performance_analyst/task_pa_bloc.dart'; 
import '../../blocs/performance_analyst/task_pa_event.dart';
import '../../blocs/performance_analyst/task_pa_state.dart';

import '../widgets/app_widget.dart';

class StatisticsPage extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const StatisticsPage({Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc()
        ..add(FetchStatisticsEvent(startDate: startDate, endDate: endDate)), 
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tổng quan"),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF242424),
        ),
        body: Container(
          color: const Color(0xFF353535),
          child: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatisticsLoaded) {
              return Container(
                color: Color(0xFF353535),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticCard(
                        title: "Tổng số công việc",
                        value: state.totalTasksCount.toString(),
                      ),
                      _buildStatisticCard(
                        title: "Công việc hoàn thành",
                        value: state.completedTasksCount.toString(),
                      ),
                      _buildStatisticCard(
                        title: "Tỷ lệ hoàn thành",
                        value: "${state.completionRate.toStringAsFixed(2)}%",
                      ),
                      PriorityBarChart(
                        priorityRates: state.completionRatesByPriority, // Dữ liệu mới từ state
                      ),
                      PriorityPieChart(priorityStats: state.priorityStats),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Công việc quá hạn:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      _buildStatisticCard(
                        title: "Tỷ lệ trễ hạn",
                        value: "${state.overdueRate.toStringAsFixed(2)}%",
                      ),
                      ...state.overdueTasks.map(
                        (task) => _buildOverdueTaskCard(task.name, task.deadline.toDate()),
                      ),
                      
                    ],
                  ),
                ),
              );
            } else if (state is StatisticsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Không có dữ liệu"));
          },
        ),
        ),
        
      ),
    );
  }

  // Widget hiển thị thông tin thống kê
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

  // Widget hiển thị công việc quá hạn
  Widget _buildOverdueTaskCard(String taskName, DateTime deadline) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "Hạn chót: ${deadline.toString()}",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
