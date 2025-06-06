import 'package:flutter/material.dart';
import 'package:traffic_department/data/received_transactions.dart';

class ReceivedTransactionsScreen extends StatefulWidget {
  const ReceivedTransactionsScreen({super.key});

  @override
  State<ReceivedTransactionsScreen> createState() =>
      _ReceivedTransactionsScreenState();
}

class _ReceivedTransactionsScreenState
    extends State<ReceivedTransactionsScreen> {
  final Set<int> selectedRows = {};
  bool selectAll = false;

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedRows.clear();
      if (selectAll) {
        for (int i = 0; i < receivedTransactions.length; i++) {
          selectedRows.add(i);
        }
      }
    });
  }

  void _handleBatchAction(String action) {
    final selectedTransactions =
        selectedRows.map((i) => receivedTransactions[i]).toList();

    if (action == 'وضع قيد الإنجاز') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: Colors.orange.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timelapse, color: Colors.orange),
                  const SizedBox(width: 10),
                  Text(
                    'تم وضع المعاملة قيد الإنجاز',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        setState(() {
          receivedTransactions.removeWhere(
            (tx) => selectedTransactions.contains(tx),
          );
          selectedRows.clear();
          selectAll = false;
        });
      });
    } else if (action == 'رفض') {
      String reason = '';
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'سبب الرفض',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                onChanged: (value) => reason = value,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'يرجى إدخال سبب الرفض...',
                  hintStyle: const TextStyle(color: Colors.black45),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.only(bottom: 12),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),

                OutlinedButton(
                  onPressed: () {
                    if (reason.trim().isNotEmpty) {
                      Navigator.pop(context);
                      setState(() {
                        receivedTransactions.removeWhere(
                          (tx) => selectedTransactions.contains(tx),
                        );
                        selectedRows.clear();
                        selectAll = false;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'تأكيد الرفض',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      );
    }
  }

  IconData _getPaymentIcon(String method) {
    if (method.contains('فيزا')) return Icons.credit_card;
    if (method.contains('بال باي')) return Icons.account_balance_wallet;
    if (method.contains('جوال')) return Icons.phone_android;
    if (method.contains('الاستلام')) return Icons.money;
    return Icons.payment;
  }

  void _showAttachmentsOverlay(List attachments) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ملفات المعاملة',
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder:
          (_, __, ___) => Center(
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              child: SizedBox(
                width: 650,
                height: 480,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Column(
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.attachment,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ملفات المعاملة',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF102542),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 24,
                                alignment: WrapAlignment.center,
                                children: List.generate(attachments.length, (
                                  index,
                                ) {
                                  final att = attachments[index];
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/P${(index % 5) + 1}.png',
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        att,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.deepOrange,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 26,
                          color: Colors.black54,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102542),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'قائمة المعاملات المستلمة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 32),

          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFFE8ECF4),
                  ),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: selectAll,
                        onChanged: _toggleSelectAll,
                      ),
                    ),
                    const DataColumn(label: Text('الرقم')),
                    const DataColumn(label: Text('رقم المعاملة')),
                    const DataColumn(label: Text('الاسم الرباعي')),
                    const DataColumn(label: Text('نوع المعاملة')),
                    const DataColumn(label: Text('التاريخ والوقت')),
                    const DataColumn(label: Text('طريقة الدفع')),
                    const DataColumn(label: Text('المرفقات')),
                  ],
                  rows: List.generate(receivedTransactions.length, (index) {
                    final transaction = receivedTransactions[index];
                    return DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: selectedRows.contains(index),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedRows.add(index);
                                } else {
                                  selectedRows.remove(index);
                                }
                                selectAll =
                                    selectedRows.length ==
                                    receivedTransactions.length;
                              });
                            },
                          ),
                        ),
                        DataCell(Text('${index + 1}')),
                        DataCell(
                          Text(
                            transaction['id'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Text(
                            transaction['citizenName'],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        DataCell(Text(transaction['type'])),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                transaction['receivedDate'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                transaction['receivedTime'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                _getPaymentIcon(transaction['paymentMethod']),
                                size: 18,
                                color: Color(0xFF102542),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  transaction['paymentMethod'],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blueGrey,
                            ),
                            onPressed:
                                () => _showAttachmentsOverlay(
                                  transaction['attachments'],
                                ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),

          if (selectedRows.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _handleBatchAction('وضع قيد الإنجاز'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.timelapse),
                    label: const Text('وضع قيد الإنجاز'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _handleBatchAction('رفض'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.cancel),
                    label: const Text('رفض الاستلام'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
