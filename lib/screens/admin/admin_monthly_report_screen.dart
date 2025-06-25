import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:traffic_department/data/admin_monthly_reports_data.dart';

class AdminMonthlyReportScreen extends StatefulWidget {
  const AdminMonthlyReportScreen({super.key});

  @override
  State<AdminMonthlyReportScreen> createState() =>
      _AdminMonthlyReportScreenState();
}

class _AdminMonthlyReportScreenState extends State<AdminMonthlyReportScreen> {
  late Map<String, dynamic> selectedReport;
  late Map<String, dynamic>? previousReport;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    selectedReport = adminMonthlyReportsData[0];
    previousReport =
        adminMonthlyReportsData.length > 1 ? adminMonthlyReportsData[1] : null;

    _notesController = TextEditingController(text: selectedReport['notes']);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'التقرير الشهري',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('اختر الشهر:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    DropdownButton<Map<String, dynamic>>(
                      value: selectedReport,
                      items:
                          adminMonthlyReportsData.map((report) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: report,
                              child: Text(report['month']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReport = value!;
                          int currentIndex = adminMonthlyReportsData.indexOf(
                            selectedReport,
                          );
                          previousReport =
                              currentIndex + 1 < adminMonthlyReportsData.length
                                  ? adminMonthlyReportsData[currentIndex + 1]
                                  : null;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard('المعاملات', selectedReport['transactions']),
                    _buildStatCard('الشكاوي', selectedReport['complaints']),
                    _buildStatCard('الاقتراحات', selectedReport['suggestions']),
                    _buildSingleStatCard(
                      'تقييم البوابة',
                      '${selectedReport['portalRating']} ⭐',
                    ),
                    _buildSingleStatCard(
                      'المستخدمون الجدد',
                      '${selectedReport['newUsers']}',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'عدد المعاملات المنجزة خلال الأشهر:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(height: 200, child: _buildBarChart()),

                const SizedBox(height: 24),

                const Text(
                  'أفضل الموظفين:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTopEmployeesTable(),

                const SizedBox(height: 24),

                const Text(
                  'أكثر الخدمات استخدامًا:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTopServicesList(),

                const SizedBox(height: 24),

                const Text(
                  'ملاحظات إدارية:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'أدخل الملاحظات الإدارية...',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedReport['notes'] = _notesController.text;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('حفظ الملاحظات'),
                ),

                const SizedBox(height: 24),

                if (previousReport != null) ...[
                  const Text(
                    'مقارنة مع الشهر السابق:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildComparisonWithPreviousMonth(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, Map<String, dynamic> data) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...data.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
        ],
      ),
    );
  }

  Widget _buildSingleStatCard(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxTransactionsCount().toDouble() + 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final month = adminMonthlyReportsData[value.toInt()]['month'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(month, style: const TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            adminMonthlyReportsData.asMap().entries.map((entry) {
              final index = entry.key;
              final report = entry.value;
              final completedTransactions = report['transactions']['منجزة'];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: completedTransactions.toDouble(),
                    color: Colors.blue,
                    width: 24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  int _getMaxTransactionsCount() {
    return adminMonthlyReportsData
        .map((report) => report['transactions']['منجزة'] as int)
        .reduce((a, b) => a > b ? a : b);
  }

  // ✅ جدول Top الموظفين
  Widget _buildTopEmployeesTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('الرقم')),
        DataColumn(label: Text('اسم الموظف')),
        DataColumn(label: Text('عدد المعاملات المنجزة')),
      ],
      rows:
          selectedReport['topEmployees'].map<DataRow>((employee) {
            return DataRow(
              cells: [
                DataCell(Text(employee['id'])),
                DataCell(Text(employee['name'])),
                DataCell(Text(employee['transactionsCompleted'].toString())),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildTopServicesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          selectedReport['topServices'].map<Widget>((service) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    service['service'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 12), 
                  Text(
                    '${service['count']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildComparisonWithPreviousMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComparisonRow(
          'المعاملات المنجزة',
          selectedReport['transactions']['منجزة'],
          previousReport!['transactions']['منجزة'],
        ),
        _buildComparisonRow(
          'عدد الشكاوي',
          selectedReport['complaints'].values
              .map((e) => int.parse(e.toString()))
              .reduce((a, b) => a + b),
          previousReport!['complaints'].values
              .map((e) => int.parse(e.toString()))
              .reduce((a, b) => a + b),
        ),

        _buildComparisonRow(
          'عدد الاقتراحات',
          selectedReport['suggestions'].values
              .map((e) => int.parse(e.toString()))
              .reduce((a, b) => a + b),
          previousReport!['suggestions'].values
              .map((e) => int.parse(e.toString()))
              .reduce((a, b) => a + b),
        ),

        _buildComparisonRow(
          'تقييم البوابة',
          selectedReport['portalRating'],
          previousReport!['portalRating'],
          isRating: true,
        ),
      ],
    );
  }

  Widget _buildComparisonRow(
    String title,
    dynamic current,
    dynamic previous, {
    bool isRating = false,
  }) {
    double improvement =
        (current - previous) / (previous == 0 ? 1 : previous) * 100;
    String improvementText =
        improvement >= 0
            ? '+${improvement.toStringAsFixed(1)}%'
            : '${improvement.toStringAsFixed(1)}%';
    Color improvementColor = improvement >= 0 ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(title)),
          Expanded(flex: 2, child: Text('$current ${isRating ? '⭐' : ''}')),
          Expanded(flex: 2, child: Text('$previous ${isRating ? '⭐' : ''}')),
          Expanded(
            flex: 2,
            child: Text(
              improvementText,
              style: TextStyle(
                color: improvementColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
