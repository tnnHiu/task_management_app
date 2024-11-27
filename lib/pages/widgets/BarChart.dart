part of 'app_widget.dart';


class PriorityBarChart extends StatelessWidget {
  final Map<String, int> priorityRates; // Tỷ lệ hoàn thành công việc theo mức độ ưu tiên

  const PriorityBarChart({Key? key, required this.priorityRates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tỷ lệ hoàn thành theo mức độ ưu tiên",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width < 400 ? 1.2 : 1.5,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _buildBarGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(''), // Cái này nếu bạn muốn hiển thị tên trục Y
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 20 == 0) {
                            return Text(
                              '${value.toInt()}%', 
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text(''), // Tên trục X (nếu muốn)
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Cao', style: TextStyle(color: Colors.white, fontSize: 14));
                            case 1:
                              return const Text('Vừa', style: TextStyle(color: Colors.white, fontSize: 14));
                            case 2:
                              return const Text('Thấp', style: TextStyle(color: Colors.white, fontSize: 14));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

 List<BarChartGroupData> _buildBarGroups() {
  final priorities = ['Cao', 'Vừa', 'Thấp'];
  return List.generate(priorities.length, (index) {
    final priority = priorities[index];
    final rate = priorityRates[priority]?.toDouble() ?? 0.0; // Nếu không có dữ liệu, mặc định là 0

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          fromY: 0,  // Điểm bắt đầu của thanh cột (từ 0)
          toY: rate, // Giá trị y cho thanh cột (tỷ lệ hoàn thành)
          width: 16,
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  });
}


}

