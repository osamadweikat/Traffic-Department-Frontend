import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/theme/app_theme.dart';
import 'package:flutter/services.dart' as ui;
import 'transaction_details_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String filter = 'all';

  final List<Map<String, dynamic>> transactions = [
    {"id": "#001", "type": "license_renewal".tr(), "date": "2025-03-30", "status": "completed"},
    {"id": "#002", "type": "ownership_transfer".tr(), "date": "2025-03-29", "status": "processing"},
    {"id": "#003", "type": "lost_plate".tr(), "date": "2025-03-28", "status": "rejected"},
    {"id": "#004", "type": "practical_test_result".tr(), "date": "2025-03-25", "status": "completed"},
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (filter == 'all') return transactions;
    return transactions.where((t) => t["status"] == filter).toList();
  }

  void showCustomMenu() async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      items: [
        _buildFilterItem('all'),
        _buildFilterItem('processing'),
        _buildFilterItem('completed'),
        _buildFilterItem('rejected'),
      ],
    );

    if (selected != null) {
      setState(() {
        filter = selected;
      });
    }
  }

  PopupMenuItem<String> _buildFilterItem(String value) {
    return PopupMenuItem(
      value: value,
      child: Text(
        'filter_$value'.tr(),
        style: TextStyle(
          color: filter == value ? Colors.blue : Colors.black,
          fontWeight: filter == value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "processing":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text("my_transactions".tr()),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: "filter_transactions".tr(),
              onPressed: showCustomMenu,
            ),
          ],
        ),
        backgroundColor: AppTheme.lightGrey,
        body: filteredTransactions.isEmpty
            ? Center(child: Text("no_transactions".tr()))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTransactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  final statusKey = 'status_${transaction["status"]}';

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(transaction["type"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${"transaction_id".tr()}: ${transaction["id"]}"),
                          Text("${"transaction_date".tr()}: ${transaction["date"]}"),
                          Text(
                            "${"transaction_status".tr()}: ${statusKey.tr()}",
                            style: TextStyle(color: getStatusColor(transaction["status"])),
                          ),
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
                                status: statusKey.tr(),
                                notes: "transaction_notes".tr(),
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
