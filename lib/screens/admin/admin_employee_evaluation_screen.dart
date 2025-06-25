import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_employee_reports_data.dart';

class AdminEmployeeEvaluationScreen extends StatefulWidget {
  const AdminEmployeeEvaluationScreen({super.key});

  @override
  State<AdminEmployeeEvaluationScreen> createState() =>
      _AdminEmployeeEvaluationScreenState();
}

class _AdminEmployeeEvaluationScreenState
    extends State<AdminEmployeeEvaluationScreen> {
  final TextEditingController employeeNumberController =
      TextEditingController();
  Map<String, dynamic>? selectedEmployee;

  final TextEditingController disciplineController = TextEditingController();
  final TextEditingController commitmentController = TextEditingController();
  final TextEditingController behaviorController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();

  String selectedRecommendationType = '';
  double disciplineValue = 0;
  double commitmentValue = 0;
  double behaviorValue = 0;

  final List<String> recommendationTypes = [
    'إيجابية جدًا',
    'إيجابية',
    'حيادية',
    'سلبية',
  ];

  void _searchEmployee() {
    final query = employeeNumberController.text.trim();
    final result = employeeMonthlyReports.firstWhere(
      (employee) => employee['الموظف']['الرقم'] == query,
      orElse: () => {},
    );

    setState(() {
      selectedEmployee = result.isEmpty ? null : result;
    });
  }

  void _submitEvaluation() {
    showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      setState(() {
        employeeNumberController.clear();
        selectedEmployee = null;
        disciplineValue = 0;
        commitmentValue = 0;
        behaviorValue = 0;
        notesController.clear();
        recommendationsController.clear();
        selectedRecommendationType = '';
      });
    });

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'تم إرسال التقرير بنجاح',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'تم إرسال تقرير الأداء للموظف وسيتم إشعاره رسميًا لمراجعة التقرير خلال الساعات القادمة.\n\nيرجى متابعة حالة الإشعار في النظام.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: Colors.green),
            const SizedBox(height: 8),
            const Text('جاري المعالجة...', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  },
);

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'تقييم الأداء الشهري للموظف',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('رقم الموظف:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: employeeNumberController,
                        decoration: InputDecoration(
                          hintText: 'أدخل رقم الموظف...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _searchEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('بحث'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (selectedEmployee != null) ...[
                  _buildEmployeeInfoSection(),
                  const SizedBox(height: 16),
                  _buildEvaluationForm(),
                  const SizedBox(height: 16),
                  _buildReportForm(),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('إرسال التقرير'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoSection() {
    final emp = selectedEmployee!['الموظف'];
    final performance = selectedEmployee!['الأداء'];
    final lastMonth = selectedEmployee!['مقارنة الشهر الماضي'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الموظف:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('الاسم: ${emp['الاسم']}'),
          Text('الرقم: ${emp['الرقم']}'),
          Text('القسم: ${emp['القسم']}'),
          Text('الوظيفة: ${emp['الوظيفة']}'),
          Text('تاريخ التعيين: ${emp['تاريخ التعيين']}'),
          Text('الترتيب على مستوى القسم: ${emp['الترتيب']['على مستوى القسم']}'),
          Text(
            'الترتيب على مستوى الدائرة: ${emp['الترتيب']['على مستوى الدائرة']}',
          ),
          const SizedBox(height: 12),
          const Text(
            'الأداء:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('عدد المعاملات: ${performance['عدد المعاملات']}'),
          Text('منجزة: ${performance['منجزة']}'),
          Text('مرفوضة: ${performance['مرفوضة']}'),
          Text('قيد الإنجاز: ${performance['قيد الإنجاز']}'),
          Text('متأخرة: ${performance['متأخرة']}'),
          const SizedBox(height: 12),
          const Text(
            'مقارنة الشهر الماضي:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('عدد المعاملات: ${lastMonth['عدد المعاملات']}'),
          Text('فرق: ${lastMonth['فرق']}'),
          Text('نسبة التحسن: ${lastMonth['نسبة التحسن']}'),
        ],
      ),
    );
  }

  Widget _buildEvaluationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التقييم:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        const Text('الانضباط:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: disciplineValue,
          onChanged: (value) {
            setState(() {
              disciplineValue = value;
            });
          },
          min: 0,
          max: 100,
          divisions: 100,
          label: '${disciplineValue.round()}%',
        ),

        const SizedBox(height: 12),
        const Text('الالتزام:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: commitmentValue,
          onChanged: (value) {
            setState(() {
              commitmentValue = value;
            });
          },
          min: 0,
          max: 100,
          divisions: 100,
          label: '${commitmentValue.round()}%',
        ),

        const SizedBox(height: 12),
        const Text('التعامل:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: behaviorValue,
          onChanged: (value) {
            setState(() {
              behaviorValue = value;
            });
          },
          min: 0,
          max: 100,
          divisions: 100,
          label: '${behaviorValue.round()}%',
        ),

        const SizedBox(height: 12),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'الملاحظات'),
        ),
      ],
    );
  }

  Widget _buildReportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التقرير:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('اعداد التقرير: أسامة الخطيب'),
        const Text('الوظيفة: مدير دائرة السير'),
        const SizedBox(height: 8),
        TextField(
          controller: recommendationsController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'التوصيات'),
        ),
        const SizedBox(height: 12),
        const Text('نوع التوصية:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              recommendationTypes.map((type) {
                final isSelected = selectedRecommendationType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedRecommendationType = type;
                    });
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
