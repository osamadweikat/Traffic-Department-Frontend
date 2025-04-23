import 'package:flutter/material.dart';
import 'package:traffic_department/widgets/transaction_progress_indicator.dart';
import '/theme/app_theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String id;
  final String type;
  final String date;
  final String status;
  final String notes;

  const TransactionDetailsScreen({
    super.key,
    required this.id,
    required this.type,
    required this.date,
    required this.status,
    required this.notes,
  });
  
  List<String> get stepLabels => [
        "تم التقديم",
        "قيد المعالجة",
        "قيد المراجعة",
        "مكتملة",
      ];

  int getStepIndex(String status) {
    switch (status) {
      case "تم التقديم":
        return 1;
      case "قيد المعالجة":
        return 2;
      case "قيد المراجعة":
        return 3;
      case "مكتملة":
        return 4;
      case "مرفوضة":
        return 3; 
      default:
        return 1;
    }
  }

  List<String> getStepStatus(String status) {
    int stepIndex = getStepIndex(status);
    List<String> statuses = [];
    for (int i = 1; i <= 4; i++) {
      if (i < stepIndex) {
        statuses.add("مكتملة");
      } else if (i == stepIndex) {
        if (status == "مرفوضة") {
          statuses.add("مرفوضة");
        } else {
          statuses.add(status);
        }
      } else {
        statuses.add("قيد الانتظار");
      }
    }
    return statuses;
  }

  Color getStatusColor() {
    switch (status) {
      case "مكتملة":
        return Colors.green;
      case "قيد المراجعة":
        return Colors.orange;
      case "قيد المعالجة":
        return Colors.orange;
      case "مرفوضة":
        return Colors.red;
      case "تم التقديم":
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case "مكتملة":
        return Icons.check_circle_outline;
      case "قيد المراجعة":
      case "قيد المعالجة":
      case "تم التقديم":
        return Icons.pending_actions;
      case "مرفوضة":
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedSteps = getStepIndex(status);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل المعاملة"),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.assignment_outlined,
                              color: AppTheme.navy,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "معلومات المعاملة",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        buildRow("نوع المعاملة:", type),
                        buildRow("رقم المعاملة:", id),
                        buildRow("تاريخ الطلب:", date),

                        Row(
                          children: [
                            const Text(
                              "حالة المعاملة:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Icon(getStatusIcon(), color: getStatusColor(), size: 20),
                            const SizedBox(width: 5),
                            Text(
                              status,
                              style: TextStyle(
                                color: getStatusColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "ملاحظات:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notes.isNotEmpty ? notes : "لا توجد ملاحظات.",
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "تتبع حالة المعاملة",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TransactionProgressIndicator(
                steps: stepLabels.length,
                completedSteps: completedSteps,
                stepLabels: stepLabels,
                stepStatus: getStepStatus(status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
