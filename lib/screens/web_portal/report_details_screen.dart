import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:share_plus/share_plus.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final List sections = report['sections'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        automaticallyImplyLeading: false,
        title: const Text('تقرير رسمي', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/traffic_logo.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report['author'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          _formatDate(report['date']),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'ملخص التقرير:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                report['summary'] ?? '',
                style: const TextStyle(fontSize: 14, height: 1.7),
              ),
              const SizedBox(height: 32),
              ...sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section['heading'],
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        section['content'],
                        style: const TextStyle(fontSize: 14, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (report['footer_note'] != null) ...[
                const Divider(height: 32, color: Colors.black26),
                Text(
                  report['footer_note'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _downloadPdfDirectly(report),
                    icon: const Icon(Icons.download),
                    label: const Text('تنزيل كـ PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Share.share(
                        '📄 ${report['title']}\n\n${report['summary']}',
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة التقرير'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _downloadPdfDirectly(Map<String, dynamic> report) async {
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final logoBytes = await rootBundle.load('assets/images/traffic_logo.png');
    final logoImage = logoBytes.buffer.asUint8List();
    final pdf = pw.Document();
    final sections = report['sections'] ?? [];

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: ttf),
        build:
            (context) => [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.ClipOval(
                    child: pw.Image(
                      pw.MemoryImage(logoImage),
                      width: 55,
                      height: 55,
                    ),
                  ),
                  pw.SizedBox(width: 12), 
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        report['title'],
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf,
                        ),
                      ),
                      pw.Text(
                        report['author'] ?? '',
                        style: pw.TextStyle(fontSize: 12, font: ttf),
                      ),
                      pw.Text(
                        _formatDate(report['date']),
                        style: pw.TextStyle(fontSize: 11, font: ttf),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 24),
              pw.Text(
                'ملخص التقرير:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                report['summary'] ?? '',
                style: pw.TextStyle(fontSize: 12, font: ttf),
              ),
              pw.SizedBox(height: 16),
              for (var section in sections) ...[
                pw.Text(
                  section['heading'],
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  section['content'],
                  style: pw.TextStyle(fontSize: 12, font: ttf),
                ),
                pw.SizedBox(height: 12),
              ],
              if (report['footer_note'] != null) ...[
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Text(
                  report['footer_note'],
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontStyle: pw.FontStyle.italic,
                    font: ttf,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ],
      ),
    );

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final _ =
        html.AnchorElement(href: url)
          ..setAttribute('download', '${report['title']}.pdf')
          ..click();
    html.Url.revokeObjectUrl(url);
  }
}
