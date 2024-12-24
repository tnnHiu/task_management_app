import 'package:flutter/material.dart';
import '../../blocs/performance_analyst/focus_pa_bloc.dart';
import '../../blocs/performance_analyst/focus_pa_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/performance_analyst/focus_pa_event.dart';

class PomodoroStatsPage extends StatefulWidget {
  @override
  _PomodoroStatsPageState createState() => _PomodoroStatsPageState();
}

class _PomodoroStatsPageState extends State<PomodoroStatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PomodoroStatsBloc>().add(FetchPomodoroStatsEvent());
    context.read<PomodoroStatsBloc>().add(FetchTodayPomodoroStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF353535),
        foregroundColor: Colors.white,
        title: Text("Thống kê tập trung"),
        centerTitle: true,
      ),
      body: BlocBuilder<PomodoroStatsBloc, PomodoroStatsState>(
        builder: (context, state) {
          if (state is PomodoroStatsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PomodoroStatsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(
                    title: "Pomo hôm nay",
                    value: "${state.todayPomodoros}",
                    subtitle: "",
                    icon: Icons.timer,
                  ),
                  _buildStatCard(
                    title: "Tổng thời gian tập trung hôm nay",
                    value: "${(state.todayDuration / 60).floor()}h ${(state.todayDuration % 60)}m",
                    subtitle: "",
                    icon: Icons.access_time,
                  ),
                  _buildStatCard(
                    title: "Tổng pomo",
                    value: "${state.totalPomodoros}",
                    subtitle: "",
                    icon: Icons.timelapse,
                  ),
                  _buildStatCard(
                    title: "Tổng thời gian tập trung",
                    value: "${(state.totalDuration ~/ 3600).floor()}h ${((state.totalDuration % 3600) ~/ 60)}m",
                    subtitle: "",
                    icon: Icons.schedule,
                  ),
                ],
              ),
            );
          } else if (state is PomodoroStatsError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("No data available"));
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      color: Color(0xFF353535),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (subtitle.isNotEmpty)
              SizedBox(height: 8),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

