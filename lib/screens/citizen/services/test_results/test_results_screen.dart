import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/services/test_results/test_result_not_found_dialog.dart';
import '../../../../theme/app_theme.dart';
import 'test_results_data.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({super.key});

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? theoreticalResult;
  Map<String, dynamic>? practicalResult;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _idController.clear();
          theoreticalResult = null;
          practicalResult = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void searchResults(String id) {
    final theoretical = testResults.firstWhere(
      (e) => e['id'] == id && e['type'] == 'theoretical',
      orElse: () => {},
    );
    final practical = testResults.firstWhere(
      (e) => e['id'] == id && e['type'] == 'practical',
      orElse: () => {},
    );

    final found = theoretical.isNotEmpty || practical.isNotEmpty;

    setState(() {
      theoreticalResult = theoretical.isNotEmpty ? theoretical : null;
      practicalResult = practical.isNotEmpty ? practical : null;
    });

    if (!found) {
      showTestResultNotFoundDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test_results").tr(),
        centerTitle: true,
        backgroundColor: AppTheme.navy,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.yellow,
          tabs: [
            Tab(text: "theoretical_exam".tr(), icon: const Icon(Icons.menu_book)),
            Tab(text: "practical_exam".tr(), icon: const Icon(Icons.directions_car)),
          ],
        ),
      ),
      backgroundColor: AppTheme.lightGrey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      hintText: 'enter_national_id'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchResults(_idController.text.trim()),
                  child: Text('search'.tr()),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TheoreticalResultView(result: theoreticalResult),
                PracticalResultView(result: practicalResult),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TheoreticalResultView extends StatelessWidget {
  final Map<String, dynamic>? result;
  const TheoreticalResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();

    final passed = result!["score"] >= result!["passMark"];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("exam_result".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 12),
              buildRow("name".tr(), result!["name"]),
              buildRow("exam_date".tr(), result!["examDate"]),
              buildRow("license_grade".tr(), result!["licenseGrade"]),
              buildRow("max_score".tr(), result!["maxScore"].toString()),
              buildRow("exam_score".tr(), result!["score"].toString()),
              buildRow("needs_examiner".tr(), result!["needsExaminer"] ? 'yes'.tr() : 'no'.tr()),
              buildRow("final_result".tr(), passed ? "passed".tr() : "failed".tr(), valueColor: passed ? Colors.green : Colors.red),
              buildRow("question_count".tr(), result!["questionCount"].toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticalResultView extends StatelessWidget {
  final Map<String, dynamic>? result;
  const PracticalResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();

    final passed = result!["scoreStatus"] == "passed";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("exam_result".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 12),
              buildRow("name".tr(), result!["name"]),
              buildRow("exam_date".tr(), result!["examDate"]),
              buildRow("license_grade".tr(), result!["licenseGrade"]),
              buildRow("final_result".tr(), passed ? "passed".tr() : "failed".tr(), valueColor: passed ? Colors.green : Colors.red),
              buildRow("school_name".tr(), result!["schoolName"]),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRow(String label, String value, {Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(value, style: TextStyle(color: valueColor ?? Colors.black87)),
        ),
      ],
    ),
  );
}
