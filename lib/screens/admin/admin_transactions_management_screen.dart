import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_transactions_data.dart';

class AdminTransactionsManagementScreen extends StatefulWidget {
  const AdminTransactionsManagementScreen({super.key});

  @override
  State<AdminTransactionsManagementScreen> createState() =>
      _AdminTransactionsManagementScreenState();
}

class _AdminTransactionsManagementScreenState
    extends State<AdminTransactionsManagementScreen> {
  String selectedStatusFilter = 'الكل';
  String searchQuery = '';
  List<String> selectedTransactionIds = [];

  List<Map<String, String>> get filteredTransactions {
    List<Map<String, String>> filtered = adminTransactionsData;

    if (selectedStatusFilter != 'الكل') {
      filtered =
          filtered.where((tx) => tx['status'] == selectedStatusFilter).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (tx) =>
                    tx['id']!.contains(searchQuery) ||
                    tx['citizenName']!.contains(searchQuery) ||
                    tx['nationalId']!.contains(searchQuery),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'إدارة المعاملات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText:
                      'ابحث عن معاملة (رقم المعاملة / اسم المواطن / رقم الهوية)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('الكل'),
                    _buildFilterButton('جديدة'),
                    _buildFilterButton('قيد الإنجاز'),
                    _buildFilterButton('منجزة'),
                    _buildFilterButton('مرفوضة'),
                    _buildFilterButton('متأخرة'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (selectedTransactionIds.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    _showAssignEmployeeDialog();
                  },
                  icon: const Icon(Icons.send),
                  label: Text(
                    'إرسال ${selectedTransactionIds.length} معاملة إلى موظف',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Row(
                            children: [
                              Checkbox(
                                value: _areAllSelected(),
                                onChanged: (value) {
                                  _toggleSelectAll(value ?? false);
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text('رقم المعاملة'),
                            ],
                          ),
                        ),
                        DataColumn(label: Text('اسم المواطن')),
                        DataColumn(label: Text('رقم الهوية')),
                        DataColumn(label: Text('نوع المعاملة')),
                        DataColumn(label: Text('الحالة')),
                        DataColumn(label: Text('تاريخ الإنشاء')),
                        DataColumn(label: Text('آخر تحديث')),
                        DataColumn(label: Text('المبلغ')),
                        DataColumn(label: Text('طريقة الدفع')),
                        DataColumn(label: Text('موظف معين')),
                      ],
                      rows:
                          filteredTransactions.map((tx) {
                            final isSelected = selectedTransactionIds.contains(
                              tx['id'],
                            );
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (states) =>
                                    isSelected
                                        ? Colors.lightBlue.shade100
                                        : null,
                              ),
                              cells: [
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['id']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['citizenName']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['nationalId']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['type']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(
                                      tx['status']!,
                                      style: TextStyle(
                                        color: _getStatusColor(tx['status']!),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['createdAt']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['lastUpdated']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text('${tx['amount']} ₪'),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(tx['paymentMethod']!),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _toggleTransactionSelection(tx['id']!);
                                    },
                                    child: Text(
                                      tx['assignedEmployeeId']!.isEmpty
                                          ? '-'
                                          : tx['assignedEmployeeId']!,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _areAllSelected() {
    final newTransactions =
        filteredTransactions.where((tx) => tx['status'] == 'جديدة').toList();
    return newTransactions.isNotEmpty &&
        newTransactions.every(
          (tx) => selectedTransactionIds.contains(tx['id']),
        );
  }

  void _toggleSelectAll(bool selectAll) {
    setState(() {
      final newTransactions =
          filteredTransactions.where((tx) => tx['status'] == 'جديدة').toList();
      if (selectAll) {
        selectedTransactionIds =
            newTransactions.map((tx) => tx['id']!).toList();
      } else {
        selectedTransactionIds.clear();
      }
    });
  }

  Widget _buildFilterButton(String status) {
    final bool isSelected = selectedStatusFilter == status;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedStatusFilter = status;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(status),
      ),
    );
  }

  void _toggleTransactionSelection(String transactionId) {
    setState(() {
      if (selectedTransactionIds.contains(transactionId)) {
        selectedTransactionIds.remove(transactionId);
      } else {
        selectedTransactionIds.add(transactionId);
      }
    });
  }

  void _showAssignEmployeeDialog() {
    final _employeeIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('إرسال المعاملات إلى موظف'),
          content: TextField(
            controller: _employeeIdController,
            decoration: const InputDecoration(labelText: 'رقم الموظف'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final employeeId = _employeeIdController.text.trim();
                if (employeeId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال رقم الموظف!')),
                  );
                  return;
                }

                setState(() {
                  for (var tx in adminTransactionsData) {
                    if (selectedTransactionIds.contains(tx['id'])) {
                      tx['status'] = 'قيد الإنجاز';
                      tx['assignedEmployeeId'] = employeeId;
                      tx['lastUpdated'] = DateTime.now().toString().substring(
                        0,
                        10,
                      );
                    }
                  }
                  selectedTransactionIds.clear();
                });

                Navigator.pop(context);
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'جديدة':
        return Colors.blue;
      case 'قيد الإنجاز':
        return Colors.orange;
      case 'منجزة':
        return Colors.green;
      case 'مرفوضة':
        return Colors.red;
      case 'متأخرة':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}
