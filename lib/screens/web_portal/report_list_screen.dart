import 'package:flutter/material.dart';
import 'package:traffic_department/data/report_data.dart';
import 'package:traffic_department/screens/web_portal/report_details_screen.dart'; 

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('التقارير الرسمية'),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: officialReports.length,
        itemBuilder: (context, index) {
          final report = officialReports[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportDetailsScreen(report: report),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getIconData(report['icon']), color: Colors.blueGrey, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            report['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report['summary'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5, height: 1.4, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(report['date']),
                          style: const TextStyle(fontSize: 12.5, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData(String? name) {
    switch (name) {
      case 'search':
        return Icons.search;
      case 'edit_note':
        return Icons.edit_note;
      case 'work':
        return Icons.work;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final date = DateTime.parse(raw);
      return '${date.year}-${_two(date.month)}-${_two(date.day)}';
    } catch (_) {
      return raw;
    }
  }

  String _two(int n) => n < 10 ? '0$n' : '$n';
}
