import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:traffic_department/data/employee_monthly_report.dart';
import 'package:traffic_department/screens/staff/tasks/monthly_report/inline_badge_painter.dart';
import 'package:traffic_department/screens/staff/tasks/monthly_report/monthly_report_utils.dart';

class MonthlyReportContent extends StatelessWidget {
  const MonthlyReportContent({super.key});
  @override
  Widget build(BuildContext context) {
    final employee = employeeMonthlyReport['الموظف'];
    final details = employeeMonthlyReport['تفاصيل الإنجاز'];
    final transactionTypes = employeeMonthlyReport['توزيع المعاملات'] as Map<String, dynamic>;
    final evaluation = employeeMonthlyReport['التقييم'];
    final report = employeeMonthlyReport['التقرير'];
    final int current = 48;
    final int previous = 42;
    final int maxY = (current > previous ? current : previous) + 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF102840),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 34),
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/traffic_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'التقرير الشهري للأداء الوظيفي – دائرة السير',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 12),

          const SizedBox(height: 24),
          buildSectionTitle('معلومات الموظف'),
          buildInlineRow(Icons.person_outline, 'الاسم', employee['الاسم']),
          buildInlineRow(Icons.badge_outlined, 'رقم الموظف', employee['الرقم']),
          buildInlineRow(Icons.apartment_outlined, 'القسم', employee['القسم']),
          buildInlineRow(Icons.work_outline, 'الوظيفة', employee['الوظيفة']),
          buildInlineRow(
            Icons.calendar_month,
            'تاريخ التعيين',
            employee['تاريخ التعيين'],
          ),
          buildInlineRow(
            Icons.emoji_events,
            'ترتيب الموظف على مستوى القسم',
            '${employee['الترتيب']['على مستوى القسم']}',
          ),
          buildInlineRow(
            Icons.emoji_events_outlined,
            'ترتيب الموظف على مستوى الدائرة',
            '${employee['الترتيب']['على مستوى الدائرة']}',
          ),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('إحصائيات الأداء حسب حالة المعاملة'),
          PerformanceDoughnutChart(
            data: {'منجزة': 38, 'قيد الإنجاز': 5, 'مرفوضة': 3, 'متأخرة': 2},
          ),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('إحصائيات زمن إنجاز المعاملات'),

          DurationComparisonChart(
            maxDuration: details['أعلى زمن إنجاز'],
            minDuration: details['أقل زمن'],
            avgDuration: details['متوسط'],
          ),

          const SizedBox(height: 12),
          const Divider(),
          buildSectionTitle('آخر معاملة تم إنجازها'),
          buildInlineRow(
            Icons.confirmation_number,
            'رقم المعاملة',
            details['آخر معاملة']['رقم'],
          ),
          buildInlineRow(
            Icons.description,
            'نوع المعاملة',
            details['آخر معاملة']['نوع'],
          ),
          buildInlineRow(
            Icons.date_range,
            'تاريخ الإنجاز',
            details['آخر معاملة']['تاريخ'],
          ),
          buildInlineRow(
            Icons.schedule,
            'مدة الإنجاز',
            '${details['آخر معاملة']['المدة']} دقيقة',
          ),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('توزيع المعاملات حسب نوعها'),
          buildTransactionTable(transactionTypes),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('مقارنة عدد المعاملات مع الشهر السابق'),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: Stack(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY.toDouble(),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: previous.toDouble(),
                              width: 28,
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: current.toDouble(),
                              width: 28,
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('الشهر الماضي');
                                case 1:
                                  return const Text('هذا الشهر');
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true, horizontalInterval: 10),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(enabled: false),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: InlineBadgePainter(
                      current: current,
                      previous: previous,
                      maxY: maxY,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'نسبة التحسن: +${((current - previous) / previous * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('التقييم الإداري'),
          buildEvaluationTable(evaluation),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('ملاحظات'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              evaluation['الملاحظات'],
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          buildSectionTitle('توصيات التقرير'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              report['التوصيات'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1565C0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF1565C0),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'إعداد التقرير: م. أسامة دويكات – مدير دائرة السير',
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
