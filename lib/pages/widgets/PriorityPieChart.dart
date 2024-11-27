part of 'app_widget.dart';


class PriorityPieChart extends StatelessWidget {
  final Map<String, int> priorityStats;

  const PriorityPieChart({Key? key, required this.priorityStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = priorityStats.entries.map((entry) {
      return PieChartSectionData(
        title: "${entry.value}",
        value: entry.value.toDouble(),
        color: _getPriorityColor(entry.key),
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thống kê theo mức độ ưu tiên",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "Cao":
        return Colors.redAccent;
      case "Trung bình":
        return Colors.yellowAccent;
      case "Thấp":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}

