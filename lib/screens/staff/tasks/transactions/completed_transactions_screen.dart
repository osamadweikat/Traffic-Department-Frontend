import 'package:flutter/material.dart';
import 'package:traffic_department/data/completed_transactions_data.dart';

class CompletedTransactionsScreen extends StatelessWidget {
  const CompletedTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = [...completedTransactions];
    sortedTransactions.sort((a, b) {
      final aDateTime = DateTime.parse('${a['date']} ${a['time']}');
      final bDateTime = DateTime.parse('${b['date']} ${b['time']}');
      return bDateTime.compareTo(aDateTime);
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF102542),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'المعاملات المنجزة',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children:
                  sortedTransactions
                      .map((tx) => _buildTransactionCard(tx))
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final isMorning = int.parse(tx['time'].split(":")[0]) < 12;
    final periodText = isMorning ? 'صباحاً' : 'مساءً';
    final periodColor = isMorning ? Colors.lightBlue : Colors.indigo;
    final duration = tx['duration'] as int;

    Color durationColor;
    if (duration < 10) {
      durationColor = Colors.green;
    } else if (duration <= 20) {
      durationColor = Colors.orange.shade800;
    } else {
      durationColor = Colors.red;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              hoverColor: Colors.transparent,
              onHover: (hovering) {
                setState(() {});
              },
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رقم المعاملة: ${tx['id']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx['type'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 6),
                      Expanded(child: Text('المواطن: ${tx['citizenName']}')),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 18),
                      const SizedBox(width: 6),
                      Expanded(child: Text('رقم الهوية: ${tx['nationalId']}')),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'وقت الإنجاز: ${tx['time']} $periodText',
                          style: TextStyle(color: periodColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 18),
                      const SizedBox(width: 6),
                      Text(tx['date']),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: durationColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'المدة: $duration دقيقة',
                        style: TextStyle(color: durationColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
