import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:traffic_department/data/admin_test_results_data.dart';

class AdminExamResultsScreen extends StatefulWidget {
  const AdminExamResultsScreen({super.key});

  @override
  State<AdminExamResultsScreen> createState() => _AdminExamResultsScreenState();
}

class _AdminExamResultsScreenState extends State<AdminExamResultsScreen> {
  String selectedFilter = 'نظري';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredResults =
        testResults.where((result) {
          final matchesFilter =
              result['type'] ==
              (selectedFilter == 'نظري' ? 'theoretical' : 'practical');

          final combinedFields =
              '${result['id']} ${result['name']} ${result['type']} ${result['schoolName'] ?? ''}';
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
            'نتائج الفحوصات',
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
                  hintText: 'ابحث باسم المواطن أو رقم الهوية أو المدرسة...',
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
                      ['نظري', 'عملي'].map((filter) {
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
                        child: DataTable(
                          columns: _buildTableColumns(),
                          rows:
                              filteredResults
                                  .map((result) => _buildDataRow(result))
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

                    const SizedBox(width: 24),

                    Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: Offset(0, -40), 
                        child: Container(
                          width: 800,
                          child: _buildPieChart(selectedFilter),
                        ),
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
    if (selectedFilter == 'نظري') {
      return [
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
            'تاريخ الفحص',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: Text('الدرجة', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const DataColumn(
          label: Text(
            'يحتاج فاحص؟',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: Text(
            'النتيجة النهائية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ];
    } else {
      return [
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
            'تاريخ الفحص',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: Text(
            'اسم المدرسة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: Text(
            'النتيجة النهائية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ];
    }
  }

  DataRow _buildDataRow(Map<String, dynamic> result) {
    if (selectedFilter == 'نظري') {
      String gradeStr = '${result['score']}/${result['maxScore']}';
      String needsExaminerStr = result['needsExaminer'] ? 'نعم' : 'لا';
      String finalResultStr =
          result['finalResult'] == 'passed' ? 'ناجح' : 'راسب';
      Color resultColor =
          result['finalResult'] == 'passed'
              ? Colors.green.shade700
              : Colors.red.shade700;

      return DataRow(
        cells: [
          DataCell(Text(result['id'].toString())),
          DataCell(Text(result['name'])),
          DataCell(Text(result['examDate'])),
          DataCell(Text(gradeStr)),
          DataCell(Text(needsExaminerStr)),
          DataCell(
            Text(
              finalResultStr,
              style: TextStyle(color: resultColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      String finalResultStr =
          result['scoreStatus'] == 'passed' ? 'ناجح' : 'راسب';
      Color resultColor =
          result['scoreStatus'] == 'passed'
              ? Colors.green.shade700
              : Colors.red.shade700;

      return DataRow(
        cells: [
          DataCell(Text(result['id'].toString())),
          DataCell(Text(result['name'])),
          DataCell(Text(result['examDate'])),
          DataCell(Text(result['schoolName'])),
          DataCell(
            Text(
              finalResultStr,
              style: TextStyle(color: resultColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPieChart(String type) {
    final results =
        testResults
            .where(
              (result) =>
                  result['type'] ==
                  (type == 'نظري' ? 'theoretical' : 'practical'),
            )
            .toList();

    int passedCount = 0;
    int failedCount = 0;

    for (var result in results) {
      bool isPassed = false;
      if (type == 'نظري') {
        isPassed = result['finalResult'] == 'passed';
      } else {
        isPassed = result['scoreStatus'] == 'passed';
      }

      if (isPassed) {
        passedCount++;
      } else {
        failedCount++;
      }
    }

    int total = results.length;
    double passedPercentage = total == 0 ? 0 : (passedCount / total) * 100;
    double failedPercentage = total == 0 ? 0 : (failedCount / total) * 100;

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
                    color: Colors.green,
                    value: passedCount.toDouble(),
                    title: '${passedPercentage.toStringAsFixed(1)}%',
                    radius: 150,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: failedCount.toDouble(),
                    title: '${failedPercentage.toStringAsFixed(1)}%',
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
            'عدد الفحوصات: $total',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'عدد الناجحين: $passedCount',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'عدد الراسبين: $failedCount',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
