import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D47A1),
      ),
    ),
  );
}

Widget buildInlineRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey.shade700),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

List<Widget> buildPerformanceIndicatorsOrdered(
  Map<String, dynamic> data,
  int total,
) {
  final List<List<dynamic>> items = [
    ['منجزة', Colors.green, Icons.check_circle],
    ['قيد الإنجاز', Colors.orange, Icons.autorenew],
    ['مرفوضة', Colors.red, Icons.cancel],
    ['متأخرة', Color(0xFFFBC02D), Icons.warning],
  ];

  return items.map((item) {
    final String label = item[0] as String;
    final Color color = item[1] as Color;
    final IconData icon = item[2] as IconData;
    final int count = data[label] ?? 0;
    final double percent = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 24,
              percent: percent.clamp(0.0, 1.0),
              barRadius: const Radius.circular(8),
              progressColor: color,
              backgroundColor: Colors.grey.shade300,
              center: Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Icon(icon, color: color),
            ),
          ),
        ],
      ),
    );
  }).toList();
}

Widget buildTransactionTable(Map<String, dynamic> data) {
  final rows = <TableRow>[
    TableRow(
      decoration: const BoxDecoration(color: Color(0xFF1A237E)),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Text(
            'نوع المعاملة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Text(
            'العدد',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ];

  int index = 0;
  for (var entry in data.entries) {
    final isEven = index % 2 == 0;
    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: isEven ? Colors.grey[100] : Colors.white,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(entry.key),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text('${entry.value}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    index++;
  }

  return Table(
    border: TableBorder.all(color: Colors.grey.shade300),
    columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
    children: rows,
  );
}

Widget buildEvaluationTable(Map<String, dynamic> eval) {
  final fields = ['الانضباط', 'الالتزام', 'التعامل'];

  final rows = <TableRow>[
    TableRow(
      decoration: const BoxDecoration(color: Color(0xFF1A237E)),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Text(
            'المعيار',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Text(
            'التقييم',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ];

  for (int i = 0; i < fields.length; i++) {
    final field = fields[i];
    final isEven = i % 2 == 0;
    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: isEven ? Colors.grey[100] : Colors.white,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(field),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text('${eval[field]}%', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  return Table(
    border: TableBorder.all(color: Colors.grey.shade300),
    columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
    children: rows,
  );
}

class DurationComparisonChart extends StatelessWidget {
  final int maxDuration;
  final int minDuration;
  final int avgDuration;

  const DurationComparisonChart({
    super.key,
    required this.maxDuration,
    required this.minDuration,
    required this.avgDuration,
  });

  double _calculatePercent(int value, int max) {
    if (max == 0) return 0;
    return value / max;
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    required int max,
  }) {
    final percent = _calculatePercent(value, max);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label: $value دقيقة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = [
      maxDuration,
      minDuration,
      avgDuration,
    ].reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItem(
          icon: Icons.timer,
          label: 'أطول مدة لإنجاز معاملة',
          value: maxDuration,
          color: Colors.red.shade700,
          max: maxValue,
        ),
        _buildItem(
          icon: Icons.flash_on,
          label: 'أقصر مدة لإنجاز معاملة',
          value: minDuration,
          color: Colors.green,
          max: maxValue,
        ),
        _buildItem(
          icon: Icons.timelapse,
          label: 'متوسط زمن الإنجاز',
          value: avgDuration,
          color: Colors.orange,
          max: maxValue,
        ),
      ],
    );
  }
}

class PerformanceDoughnutChart extends StatelessWidget {
  final Map<String, int> data;

  const PerformanceDoughnutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0, (sum, val) => sum + val);
    final percentage = total == 0 ? 0 : ((data['منجزة'] ?? 0) / total * 100);

    final chartSections = <PieChartSectionData>[];

    final colorMap = {
      'منجزة': Colors.blue.shade800,
      'قيد الإنجاز': Colors.amber.shade700,
      'مرفوضة': Colors.brown.shade600,
      'متأخرة': Colors.purple.shade700,
    };

    data.forEach((label, value) {
      final double percent = total == 0 ? 0 : value / total * 100;
      chartSections.add(
        PieChartSectionData(
          color: colorMap[label],
          value: percent,
          radius: 40,
          title: '',
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: chartSections,
                  centerSpaceRadius: 45,
                  startDegreeOffset: 270,
                  sectionsSpace: 2,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900, 
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نسبة الإنجاز',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade900, 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children:
              data.keys.map((label) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colorMap[label],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('$label: ${data[label]}'),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
