import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:traffic_department/data/traffic_violations_data.dart';

class AdminTrafficViolationsScreen extends StatefulWidget {
  const AdminTrafficViolationsScreen({super.key});

  @override
  State<AdminTrafficViolationsScreen> createState() =>
      _AdminTrafficViolationsScreenState();
}

class _AdminTrafficViolationsScreenState
    extends State<AdminTrafficViolationsScreen> {
  String selectedFilter = 'الكل';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredResults =
        trafficViolations.where((violation) {
          bool matchesFilter = true;
          if (selectedFilter == 'مدفوعة') {
            matchesFilter = violation['isPaid'] == true;
          } else if (selectedFilter == 'غير مدفوعة') {
            matchesFilter = violation['isPaid'] == false;
          }

          final combinedFields =
              '${violation['violationId']} ${violation['citizenId']} ${violation['citizenName']} ${violation['violationType']}';
          final matchesSearch = combinedFields.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );

          return matchesFilter && matchesSearch;
        }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          title: const Text(
            'سجل المخالفات المرورية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText:
                      'ابحث برقم المخالفة، رقم الهوية، اسم المواطن، نوع المخالفة...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['الكل', 'مدفوعة', 'غير مدفوعة'].map((filter) {
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            selectedColor: Colors.blue.shade100,
                            onSelected: (_) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.blue.shade900
                                      : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: _buildTableColumns(),
                            rows:
                                filteredResults
                                    .map(
                                      (violation) => _buildDataRow(violation),
                                    )
                                    .toList(),
                            dataRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white,
                            ),
                            headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.blue.shade50,
                            ),
                            columnSpacing: 24,
                            dividerThickness: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: const Offset(0, -40),
                        child: Container(width: 700, child: _buildPieChart()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      const DataColumn(
        label: Text(
          'رقم المخالفة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'رقم الهوية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'اسم المواطن',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'تاريخ المخالفة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'نوع المخالفة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('الحالة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];
  }

  DataRow _buildDataRow(Map<String, dynamic> violation) {
    String statusStr = violation['isPaid'] ? 'مدفوعة' : 'غير مدفوعة';
    Color statusColor =
        violation['isPaid'] ? const Color(0xFF4A148C) : const Color(0xFFE65100);

    return DataRow(
      cells: [
        DataCell(Text(violation['violationId'])),
        DataCell(Text(violation['citizenId'])),
        DataCell(Text(violation['citizenName'])),
        DataCell(Text(violation['violationDate'])),
        DataCell(Text(violation['violationType'])),
        DataCell(Text('${violation['amount']} ₪')),
        DataCell(
          Text(
            statusStr,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final total = trafficViolations.length;
    final paidCount =
        trafficViolations
            .where((violation) => violation['isPaid'] == true)
            .length;
    final unpaidCount =
        trafficViolations
            .where((violation) => violation['isPaid'] == false)
            .length;

    double paidPercentage = total == 0 ? 0 : (paidCount / total) * 100;
    double unpaidPercentage = total == 0 ? 0 : (unpaidCount / total) * 100;

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 360,
            width: 360,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF4A148C), 
                    value: paidCount.toDouble(),
                    title: '${paidPercentage.toStringAsFixed(1)}%',
                    radius: 150,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFE65100), 
                    value: unpaidCount.toDouble(),
                    title: '${unpaidPercentage.toStringAsFixed(1)}%',
                    radius: 150,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'عدد المخالفات: $total',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'عدد المدفوعة: $paidCount',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4A148C),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'عدد غير المدفوعة: $unpaidCount',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFE65100),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
