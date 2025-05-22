import 'package:flutter/material.dart';
import 'package:traffic_department/data/transferred_transactions_data.dart';

class TransferredTransactionsScreen extends StatefulWidget {
  const TransferredTransactionsScreen({super.key});

  @override
  State<TransferredTransactionsScreen> createState() =>
      _TransferredTransactionsScreenState();
}

class _TransferredTransactionsScreenState
    extends State<TransferredTransactionsScreen> {
  final Set<String> selectedIds = {};
  List<Map<String, dynamic>> remainingTransactions = [
    ...transferredTransactions,
  ];

  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void _showSuccessDialog(String message, VoidCallback onComplete) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      onComplete();
    });
  }

  void convertSingleToInProgress(String id) {
    final tx = remainingTransactions.firstWhere((e) => e['id'] == id);
    _showSuccessDialog('تم تحويل المعاملة ${tx['id']} بنجاح', () {
      setState(() {
        remainingTransactions.removeWhere((tx) => tx['id'] == id);
        selectedIds.remove(id);
      });
    });
  }

  void convertAllToInProgress() {
    if (remainingTransactions.isEmpty) return;
    _showSuccessDialog('تم تحويل جميع المعاملات بنجاح', () {
      setState(() {
        remainingTransactions.clear();
        selectedIds.clear();
      });
    });
  }

  String formatPeriod(String time) {
    final hour = int.parse(time.split(":")[0]);
    return hour < 12 ? 'صباحاً' : 'مساءً';
  }

  Color periodColor(String time) {
    final hour = int.parse(time.split(":")[0]);
    return hour < 12 ? Colors.lightBlue : Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF102542),
          title: const Text(
            'المعاملات المحوّلة',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              onPressed: convertAllToInProgress,
              icon: const Icon(Icons.sync, color: Colors.white),
              label: const Text(
                'تحويل الكل إلى قيد الإنجاز',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body:
            remainingTransactions.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inbox, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد معاملات محوّلة حالياً',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children:
                          remainingTransactions.map((tx) {
                            final isSelected = selectedIds.contains(tx['id']);

                            return GestureDetector(
                              onTap: () => toggleSelection(tx['id']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 300,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.grey.shade300
                                          : Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          isSelected
                                              ? Colors.grey.shade400
                                              : Colors.deepPurple.withOpacity(
                                                0.12,
                                              ),
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
                                        color: Color(0xFF4527A0),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tx['type'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepPurple.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'المواطن: ${tx['citizenName']}',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.badge_outlined,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'رقم الهوية: ${tx['nationalId']}',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 18,
                                          color: periodColor(tx['time']),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'الوقت: ${tx['time']} ${formatPeriod(tx['time'])}',
                                          style: TextStyle(
                                            color: periodColor(tx['time']),
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
                                    const Divider(height: 16),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.swap_horiz_rounded,
                                          size: 18,
                                          color: Colors.deepPurple,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'تم تحويلها من: ${tx['transferredTo']}',
                                          style: const TextStyle(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF102542,
                                            ),
                                          ),
                                          onPressed:
                                              () => convertSingleToInProgress(
                                                tx['id'],
                                              ),
                                          icon: const Icon(Icons.sync),
                                          label: const Text(
                                            'تحويل إلى قيد الإنجاز',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
      ),
    );
  }
}
