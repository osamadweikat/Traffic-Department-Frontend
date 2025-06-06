import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:traffic_department/screens/admin/admin_drawer.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        body: Row(
          children: [
            const AdminDrawer(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'لوحة التحكم',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E), 
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              _buildStatCard('عدد المعاملات', '265', Icons.assignment, Colors.blue),
                              _buildStatCard('عدد الشكاوى', '14', Icons.report, Colors.red),
                              _buildStatCard('عدد المستخدمين', '1200', Icons.person, Colors.green),
                              _buildStatCard('تقييم البوابة', '4.6 ⭐', Icons.star, Colors.amber.shade700),
                            ],
                          ),

                          const SizedBox(height: 32),

                          const Text(
                            'إحصائية المعاملات آخر ٦ أشهر',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 300,
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'];
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(months[value.toInt()]),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(value.toInt().toString());
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: [
                                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 150, color: Colors.blue, width: 18)]),
                                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 180, color: Colors.blue, width: 18)]),
                                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 220, color: Colors.blue, width: 18)]),
                                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 170, color: Colors.blue, width: 18)]),
                                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 240, color: Colors.blue, width: 18)]),
                                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 200, color: Colors.blue, width: 18)]),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          const Text(
                            'آخر المعاملات',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildLastTransactionsTable(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFF1A237E), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'بوابة الأدمن - وزارة النقل والمواصلات',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastTransactionsTable() {
    final List<Map<String, String>> transactions = [
      {'id': 'TX-1001', 'type': 'تجديد رخصة القيادة', 'date': '2025-06-06'},
      {'id': 'TX-1002', 'type': 'نقل ملكية مركبة', 'date': '2025-06-06'},
      {'id': 'TX-1003', 'type': 'فحص نظري', 'date': '2025-06-05'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey.shade200),
        ),
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFE8EAF6)),
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('رقم المعاملة', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('نوع المعاملة', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ...transactions.map(
            (tx) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(tx['id']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(tx['type']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(tx['date']!),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
