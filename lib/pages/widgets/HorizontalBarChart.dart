part of 'app_widget.dart';

class HorizontalBarChart extends StatelessWidget {
  final double participationRate; 
  final double cancellationRate; 

  const HorizontalBarChart({
    Key? key,
    required this.participationRate,
    required this.cancellationRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tỷ lệ tham gia và hủy",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 400,
            child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: participationRate,
                          color: Colors.green,
                          width: 18,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: cancellationRate,
                          color: Colors.red,
                          width: 18,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60, // Tăng kích thước không gian bên trái (thử 60 hoặc lớn hơn nếu cần)
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%', // Hiển thị giá trị (thêm dấu % nếu cần)
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            );
                          },
                        ),
                      ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                          getTitlesWidget: (value, meta) {
                          if (value.toInt() == 0) {
                            return const Text("Tham gia", style: TextStyle(color: Colors.white));
                          } else if (value.toInt() == 1) {
                            return const Text("Hủy", style: TextStyle(color: Colors.white));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  maxY: 100, // Giả định tỷ lệ tối đa là 100%
                ),
            ),
          )
          
        ],
      ),
    );
  }
}
