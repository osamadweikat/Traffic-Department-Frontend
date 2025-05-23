import 'package:flutter/material.dart';
import 'package:traffic_department/screens/citizen/services/test_results/test_results_data.dart';
import 'package:traffic_department/screens/web_portal/test_result_not_found_dialog_web.dart';

class TestResultsScreenWeb extends StatefulWidget {
  const TestResultsScreenWeb({super.key});

  @override
  State<TestResultsScreenWeb> createState() => _TestResultsScreenWebState();
}

class _TestResultsScreenWebState extends State<TestResultsScreenWeb>
    with SingleTickerProviderStateMixin {
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
      showTestResultNotFoundDialogWeb(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          title: const Text(
            'نتائج الفحص',
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF002D5B), 
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.yellow,
            tabs: const [
              Tab(text: "الفحص النظري", icon: Icon(Icons.menu_book)),
              Tab(text: "الفحص العملي", icon: Icon(Icons.directions_car)),
            ],
          ),
        ),

        backgroundColor: const Color(0xFFF4F6FA),
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
                        hintText: 'أدخل رقم الهوية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => searchResults(_idController.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('بحث'),
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

    return Center(
      child: SizedBox(
        height: 460, 
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'نتيجة الامتحان',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                buildRow("الاسم", result!["name"]),
                buildRow("تاريخ الامتحان", result!["examDate"]),
                buildRow("درجة الرخصة", result!["licenseGrade"]),
                buildRow("النتيجة العظمى", result!["maxScore"].toString()),
                buildRow("نتيجة الامتحان", result!["score"].toString()),
                buildRow(
                  "بحاجة إلى فاحص؟",
                  result!["needsExaminer"] ? "نعم" : "لا",
                ),
                buildRow(
                  "النتيجة النهائية",
                  passed ? "ناجح" : "راسب",
                  valueColor: passed ? Colors.green : Colors.red,
                ),
                buildRow("عدد الأسئلة", result!["questionCount"].toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildRow(String label, String value, {Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4,
    ),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: valueColor ?? Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    ),
  );
}

class PracticalResultView extends StatelessWidget {
  final Map<String, dynamic>? result;
  const PracticalResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();

    final passed = result!["scoreStatus"] == "passed";

    return Center(
      child: SizedBox(
        height: 400, 
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'نتيجة الامتحان',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                buildRow("الاسم", result!["name"]),
                buildRow("تاريخ الامتحان", result!["examDate"]),
                buildRow("درجة الرخصة", result!["licenseGrade"]),
                buildRow(
                  "النتيجة النهائية",
                  passed ? "ناجح" : "راسب",
                  valueColor: passed ? Colors.green : Colors.red,
                ),
                buildRow("اسم المدرسة", result!["schoolName"]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
