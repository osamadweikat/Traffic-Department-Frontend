import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import 'transaction_details_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String filter = 'الكل';

  final List<Map<String, dynamic>> transactions = [
    {"id": "#001", "type": "تجديد رخصة قيادة", "date": "2025-03-30", "status": "مكتملة"},
    {"id": "#002", "type": "نقل ملكية مركبة", "date": "2025-03-29", "status": "قيد المعالجة"},
    {"id": "#003", "type": "بدل فاقد رقم مركبة", "date": "2025-03-28", "status": "مرفوضة"},
    {"id": "#004", "type": "نتيجة فحص عملي", "date": "2025-03-25", "status": "مكتملة"},
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (filter == 'الكل') return transactions;
    return transactions.where((t) => t["status"] == filter).toList();
  }

  void showCustomMenu() async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 16, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        PopupMenuItem(
          value: 'الكل',
          child: Text(
            'عرض الكل',
            style: TextStyle(
              color: filter == 'الكل' ? Colors.blue : Colors.black,
              fontWeight: filter == 'الكل' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'قيد المعالجة',
          child: Text(
            'قيد المعالجة',
            style: TextStyle(
              color: filter == 'قيد المعالجة' ? Colors.blue : Colors.black,
              fontWeight: filter == 'قيد المعالجة' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'مكتملة',
          child: Text(
            'المكتملة',
            style: TextStyle(
              color: filter == 'مكتملة' ? Colors.blue : Colors.black,
              fontWeight: filter == 'مكتملة' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'مرفوضة',
          child: Text(
            'المرفوضة',
            style: TextStyle(
              color: filter == 'مرفوضة' ? Colors.blue : Colors.black,
              fontWeight: filter == 'مرفوضة' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      setState(() {
        filter = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("معاملاتي"),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: "فلترة المعاملات",
              onPressed: showCustomMenu,
            ),
          ],
        ),
        backgroundColor: AppTheme.lightGrey,
        body: filteredTransactions.isEmpty
            ? const Center(child: Text("لا توجد معاملات"))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTransactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  Color statusColor;
                  switch (transaction["status"]) {
                    case "مكتملة":
                      statusColor = Colors.green;
                      break;
                    case "قيد المعالجة":
                      statusColor = Colors.orange;
                      break;
                    case "مرفوضة":
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(transaction["type"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("رقم المعاملة: ${transaction["id"]}"),
                          Text("تاريخ الطلب: ${transaction["date"]}"),
                          Text("الحالة: ${transaction["status"]}", style: TextStyle(color: statusColor)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline, color: AppTheme.navy),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionDetailsScreen(
                                id: transaction["id"],
                                type: transaction["type"],
                                date: transaction["date"],
                                status: transaction["status"],
                                notes: "تفاصيل المعاملة ستُعرض هنا...",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
