import 'package:flutter/material.dart';

class AttachmentAnalysisResultScreen extends StatelessWidget {
  final String attachmentName;
  final Map<String, String> extractedData;

  const AttachmentAnalysisResultScreen({
    super.key,
    required this.attachmentName,
    required this.extractedData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102542),
        title: Text('نتائج التحليل - $attachmentName', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'البيانات المستخرجة:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: extractedData.entries.map((entry) {
                return TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey.shade200,
                      child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(entry.value),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
