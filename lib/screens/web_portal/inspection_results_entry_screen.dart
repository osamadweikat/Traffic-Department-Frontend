import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traffic_department/data/admin_test_results_data.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class InspectionResultsEntryScreen extends StatefulWidget {
  const InspectionResultsEntryScreen({super.key});

  @override
  State<InspectionResultsEntryScreen> createState() =>
      _InspectionResultsEntryScreenState();
}

class _InspectionResultsEntryScreenState
    extends State<InspectionResultsEntryScreen> {
  String currentPage =
      'entry_practical'; 

  final theoreticalNameController = TextEditingController();
  final theoreticalIdController = TextEditingController();
  final theoreticalLicenseController = TextEditingController();
  double theoreticalScore = 0;
  final practicalNameController = TextEditingController();
  final practicalIdController = TextEditingController();
  final practicalLicenseController = TextEditingController();
  DateTime? practicalExamDate;
  final practicalSchoolController = TextEditingController();
  String practicalResult = 'passed';
  String searchQuery = '';
  String filterStatus = 'all';

  List<Map<String, dynamic>> getFilteredResults() {
    return testResults.where((result) {
      if (currentPage == 'view_theoretical' && result['type'] != 'theoretical')
        return false;
      if (currentPage == 'view_practical' && result['type'] != 'practical')
        return false;

      if (filterStatus == 'passed') {
        return (result['type'] == 'theoretical'
                ? result['finalResult'] == 'passed'
                : result['scoreStatus'] == 'passed') &&
            _matchesSearch(result);
      } else if (filterStatus == 'failed') {
        return (result['type'] == 'theoretical'
                ? result['finalResult'] == 'failed'
                : result['scoreStatus'] == 'failed') &&
            _matchesSearch(result);
      } else {
        return _matchesSearch(result);
      }
    }).toList();
  }

  bool _matchesSearch(Map<String, dynamic> result) {
    return result['name'].toString().contains(searchQuery) ||
        result['id'].toString().contains(searchQuery);
  }

  void addTheoreticalResult() {
    setState(() {
      testResults.add({
        'id': theoreticalIdController.text,
        'type': 'theoretical',
        'name': theoreticalNameController.text,
        'examDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'licenseGrade': theoreticalLicenseController.text,
        'maxScore': 30,
        'score': theoreticalScore.toInt(),
        'passMark': 25,
        'finalResult': theoreticalScore >= 25 ? 'passed' : 'failed',
      });

      theoreticalNameController.clear();
      theoreticalIdController.clear();
      theoreticalLicenseController.clear();
      theoreticalScore = 0;
    });
  }

  void addPracticalResult() {
    if (practicalExamDate == null) return;
    setState(() {
      testResults.add({
        'id': practicalIdController.text,
        'type': 'practical',
        'name': practicalNameController.text,
        'examDate': DateFormat('yyyy-MM-dd').format(practicalExamDate!),
        'licenseGrade': practicalLicenseController.text,
        'scoreStatus': practicalResult,
        'schoolName': practicalSchoolController.text,
      });

      practicalNameController.clear();
      practicalIdController.clear();
      practicalLicenseController.clear();
      practicalExamDate = null;
      practicalSchoolController.clear();
      practicalResult = 'passed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: const Color(0xFF1E3A5F),
          centerTitle: true,
          title: const Text(
            'إدارة نتائج الفحص',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.yellow,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    currentPage = 'entry_practical';
                    break;
                  case 1:
                    currentPage = 'entry_theoretical';
                    break;
                  case 2:
                    currentPage = 'view_practical';
                    break;
                  case 3:
                    currentPage = 'view_theoretical';
                    break;
                }
                searchQuery = '';
                filterStatus = 'all';
              });
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.directions_car), 
                text: 'إدخال نتيجة فحص عملي',
              ),
              Tab(
                icon: Icon(Icons.menu_book), 
                text: 'إدخال نتيجة فحص نظري',
              ),
              Tab(
                icon: Icon(Icons.visibility), 
                text: 'عرض نتائج الفحص العملي',
              ),
              Tab(
                icon: Icon(Icons.visibility), 
                text: 'عرض نتائج الفحص النظري',
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              currentPage.startsWith('entry')
                  ? (currentPage == 'entry_practical'
                      ? _buildPracticalForm()
                      : _buildTheoreticalForm())
                  : _buildResultsView(),
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'بحث بالاسم أو رقم الهوية',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => filterStatus = 'all'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    filterStatus == 'all' ? Colors.blue : Colors.grey[300],
                foregroundColor: Colors.white,
              ),
              child: const Text('الكل'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => setState(() => filterStatus = 'passed'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    filterStatus == 'passed' ? Colors.green : Colors.grey[300],
                foregroundColor: Colors.white,
              ),
              child: const Text('ناجحين'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => setState(() => filterStatus = 'failed'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    filterStatus == 'failed' ? Colors.red : Colors.grey[300],
                foregroundColor: Colors.white,
              ),
              child: const Text('راسبين'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children:
                getFilteredResults().map((result) {
                  bool isPassed =
                      result['type'] == 'theoretical'
                          ? result['finalResult'] == 'passed'
                          : result['scoreStatus'] == 'passed';

                  return Card(
                    color:
                        isPassed
                            ? Colors.green.shade50
                            : Colors.red.shade50, 
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(
                        Icons.person_outline,
                        size: 36,
                        color: Colors.grey,
                      ),
                      title: Text(
                        result['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('تاريخ الفحص: ${result['examDate']}'),
                          Text('درجة الرخصة: ${result['licenseGrade']}'),
                          Text('رقم الهوية: ${result['id']}'),
                          if (result['type'] == 'practical')
                            Text('مدرسة: ${result['schoolName']}'),
                        ],
                      ),
                      trailing: Icon(
                        isPassed ? Icons.check_circle : Icons.cancel,
                        color: isPassed ? Colors.green : Colors.red,
                        size: 32,
                      ),
                      onTap: () {
                        _showEditDialog(result);
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTheoreticalForm() {
    Color resultColor = theoreticalScore >= 25 ? Colors.green : Colors.red;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 إدخال نتيجة فحص نظري',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 20),

          _buildFancyTextField(theoreticalNameController, 'الاسم الرباعي'),
          const SizedBox(height: 16),
          _buildFancyTextField(theoreticalIdController, 'رقم الهوية'),
          const SizedBox(height: 16),
          _buildFancyTextField(theoreticalLicenseController, 'نوع الرخصة'),
          const SizedBox(height: 24),

          Center(
            child: Column(
              children: [
                Card(
                  color: resultColor, 
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          theoreticalScore >= 25
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          theoreticalScore >= 25 ? 'ناجح' : 'راسب',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SleekCircularSlider(
                  min: 0,
                  max: 30,
                  initialValue: theoreticalScore,
                  onChange: (double value) {
                    setState(() {
                      theoreticalScore = value;
                    });
                  },
                  appearance: CircularSliderAppearance(
                    size: 180,
                    customColors: CustomSliderColors(
                      trackColor: Colors.grey.shade300,
                      progressBarColor: resultColor,
                      dotColor: resultColor,
                    ),
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 12,
                      trackWidth: 12,
                      handlerSize: 8,
                    ),
                    infoProperties: InfoProperties(
                      mainLabelStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                      modifier: (double value) {
                        return '${value.toInt()}/30';
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),
          Center(
            child: ElevatedButton.icon(
              onPressed: addTheoreticalResult,
              icon: const Icon(Icons.save),
              label: const Text('حفظ النتيجة', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFancyTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPracticalForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 إدخال نتيجة فحص عملي',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 20),

          _buildFancyTextField(practicalNameController, 'الاسم الرباعي'),
          const SizedBox(height: 16),
          _buildFancyTextField(practicalIdController, 'رقم الهوية'),
          const SizedBox(height: 16),
          _buildFancyTextField(practicalLicenseController, 'درجة الرخصة'),
          const SizedBox(height: 16),

          const Text(
            'تاريخ الفحص:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    practicalExamDate == null
                        ? 'لم يتم التحديد'
                        : DateFormat('yyyy-MM-dd').format(practicalExamDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      practicalExamDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.date_range),
                label: const Text('اختيار التاريخ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildFancyTextField(practicalSchoolController, 'اسم المدرسة'),
          const SizedBox(height: 24),

          const Text(
            'النتيجة:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      practicalResult = 'passed';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        practicalResult == 'passed'
                            ? Colors.green
                            : Colors.grey[300],
                    foregroundColor:
                        practicalResult == 'passed'
                            ? Colors.white
                            : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: practicalResult == 'passed' ? 8 : 0,
                    shadowColor:
                        practicalResult == 'passed'
                            ? Colors.greenAccent
                            : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ناجح', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      practicalResult = 'failed';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        practicalResult == 'failed'
                            ? Colors.red
                            : Colors.grey[300],
                    foregroundColor:
                        practicalResult == 'failed'
                            ? Colors.white
                            : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: practicalResult == 'failed' ? 8 : 0,
                    shadowColor:
                        practicalResult == 'failed'
                            ? Colors.redAccent
                            : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.cancel),
                  label: const Text('راسب', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: addPracticalResult,
              icon: const Icon(Icons.save),
              label: const Text('حفظ النتيجة', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController licenseController = TextEditingController(
          text: result['licenseGrade'],
        );
        TextEditingController schoolController = TextEditingController(
          text: result['type'] == 'practical' ? result['schoolName'] : '',
        );
        TextEditingController scoreController = TextEditingController(
          text:
              result['type'] == 'theoretical' ? result['score'].toString() : '',
        );

        String examDate = result['examDate'];
        String resultStatus =
            result['type'] == 'theoretical'
                ? result['finalResult']
                : result['scoreStatus'];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('تعديل البيانات'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاسم: ${result['name']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('رقم الهوية: ${result['id']}'),
                    const SizedBox(height: 12),

                    const Text(
                      'تاريخ الفحص:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              examDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(examDate) ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() {
                                examDate = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(picked);
                              });
                            }
                          },
                          icon: const Icon(Icons.date_range),
                          label: const Text('تغيير التاريخ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: licenseController,
                      decoration: const InputDecoration(
                        labelText: 'درجة الرخصة',
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (result['type'] == 'practical') ...[
                      TextField(
                        controller: schoolController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المدرسة',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (result['type'] == 'theoretical') ...[
                      const Text(
                        'العلامة:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: scoreController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'العلامة (من 30)',
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            int score = int.tryParse(value) ?? 0;
                            resultStatus = score >= 25 ? 'passed' : 'failed';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    const Text(
                      'النتيجة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setModalState(() {
                                resultStatus = 'passed';
                                if (result['type'] == 'theoretical') {
                                  scoreController.text =
                                      '25'; 
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  resultStatus == 'passed'
                                      ? Colors.green
                                      : Colors.grey[300],
                              foregroundColor:
                                  resultStatus == 'passed'
                                      ? Colors.white
                                      : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle),
                            label: const Text('ناجح'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setModalState(() {
                                resultStatus = 'failed';
                                if (result['type'] == 'theoretical') {
                                  scoreController.text =
                                      '0'; 
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  resultStatus == 'failed'
                                      ? Colors.red
                                      : Colors.grey[300],
                              foregroundColor:
                                  resultStatus == 'failed'
                                      ? Colors.white
                                      : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.cancel),
                            label: const Text('راسب'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  result['licenseGrade'] = licenseController.text;
                  result['examDate'] = examDate;

                  if (result['type'] == 'practical') {
                    result['schoolName'] = schoolController.text;
                    result['scoreStatus'] = resultStatus;
                  } else {
                    int score = int.tryParse(scoreController.text) ?? 0;
                    result['score'] = score;
                    result['finalResult'] = score >= 25 ? 'passed' : 'failed';
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}
