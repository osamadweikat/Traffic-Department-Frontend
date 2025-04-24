import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/widgets/transaction_progress_indicator.dart';
import 'package:flutter/services.dart' as ui;
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
        "step_submitted".tr(),
        "step_processing".tr(),
        "step_reviewing".tr(),
        "step_completed".tr(),
      ];

  int getStepIndex(String status) {
    switch (status) {
      case "تم التقديم":
      case "Submitted":
        return 1;
      case "قيد المعالجة":
      case "Processing":
        return 2;
      case "قيد المراجعة":
      case "Reviewing":
        return 3;
      case "مكتملة":
      case "Completed":
        return 4;
      case "مرفوضة":
      case "Rejected":
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
        statuses.add("status_completed".tr());
      } else if (i == stepIndex) {
        if (status == "مرفوضة" || status == "Rejected") {
          statuses.add("status_rejected".tr());
        } else {
          statuses.add(status);
        }
      } else {
        statuses.add("status_pending".tr());
      }
    }
    return statuses;
  }

  Color getStatusColor() {
    switch (status) {
      case "مكتملة":
      case "Completed":
        return Colors.green;
      case "قيد المعالجة":
      case "قيد المراجعة":
      case "Processing":
      case "Reviewing":
        return Colors.orange;
      case "مرفوضة":
      case "Rejected":
        return Colors.red;
      case "تم التقديم":
      case "Submitted":
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case "مكتملة":
      case "Completed":
        return Icons.check_circle_outline;
      case "قيد المعالجة":
      case "قيد المراجعة":
      case "Processing":
      case "Reviewing":
      case "تم التقديم":
      case "Submitted":
        return Icons.pending_actions;
      case "مرفوضة":
      case "Rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedSteps = getStepIndex(status);
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text("transaction_details".tr()),
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
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment_outlined, color: AppTheme.navy),
                            const SizedBox(width: 8),
                            Text(
                              "transaction_info".tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildRow("transaction_type".tr(), type),
                        buildRow("transaction_id".tr(), id),
                        buildRow("transaction_date".tr(), date),
                        Row(
                          children: [
                            Text(
                              "transaction_status".tr(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
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
                        Text("notes".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          notes.isNotEmpty ? notes : "no_notes".tr(),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text("track_status".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
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
