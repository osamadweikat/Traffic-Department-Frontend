import 'package:flutter/material.dart';
import 'package:traffic_department/data/rejected_transactions_data.dart';

class RejectedTransactionsScreen extends StatelessWidget {
  const RejectedTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = [...rejectedTransactions];
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
            'المعاملات المرفوضة',
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
              children: sortedTransactions
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم المعاملة: ${tx['id']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tx['type'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text('المواطن: ${tx['citizenName']}')),
            ]),
            Row(children: [
              const Icon(Icons.badge_outlined, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text('رقم الهوية: ${tx['nationalId']}')),
            ]),
            Row(children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'وقت الرفض: ${tx['time']} $periodText',
                  style: TextStyle(color: periodColor),
                ),
              ),
            ]),
            Row(children: [
              const Icon(Icons.date_range, size: 18),
              const SizedBox(width: 6),
              Text(tx['date']),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.warning_amber_rounded,
                  size: 18, color: Colors.red.shade800),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'سبب الرفض: ${tx['reason']}',
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
