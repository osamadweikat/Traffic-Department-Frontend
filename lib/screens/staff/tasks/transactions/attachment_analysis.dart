import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';
import 'package:traffic_department/data/attachment_data.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/attachment_analysis_result_screen.dart';

Future<void> analyzeAttachment(BuildContext context, String attachmentName) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (_) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset('assets/animations/ai_analysis.json'), 
          ),
          const SizedBox(height: 16),
          const Text(
            'جاري التحليل...',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  await Future.delayed(const Duration(seconds: 5));

  Navigator.pop(context);

  final attachment = attachmentData.firstWhereOrNull((att) => att['name'] == attachmentName);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AttachmentAnalysisResultScreen(
        attachmentName: attachmentName,
        extractedData: Map<String, String>.from(attachment?['extractedData']),
      ),
    ),
  );
}
