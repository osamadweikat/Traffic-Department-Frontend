import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:traffic_department/data/user_full_data.dart';
import 'package:traffic_department/data/vehicle_data.dart';
import 'package:traffic_department/data/transaction_data.dart';

class SmartSearchScreen extends StatefulWidget {
  const SmartSearchScreen({super.key});

  @override
  State<SmartSearchScreen> createState() => _SmartSearchScreenState();
}

class _SmartSearchScreenState extends State<SmartSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool searchExecuted = false;
  String searchQuery = '';

  List<Map<String, dynamic>> userResults = [];
  List<Map<String, dynamic>> vehicleResults = [];
  List<Map<String, dynamic>> transactionResults = [];
  List<Map<String, dynamic>> violationResults = [];

  bool isUserSearch = false;
  bool isVehicleSearch = false;
  bool isTransactionSearch = false;
  bool showVehicleOwnerInsteadOfColor = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      searchExecuted = true;
      searchQuery = query;

      userResults.clear();
      vehicleResults.clear();
      transactionResults.clear();
      violationResults.clear();
      isUserSearch = isVehicleSearch = isTransactionSearch = false;
      showVehicleOwnerInsteadOfColor = false;

      if (sampleUser['nationalId'] == query ||
          sampleUser['fullName'] == query) {
        userResults = [sampleUser];
        vehicleResults = List<Map<String, dynamic>>.from(
          sampleUser['vehicles'],
        );
        transactionResults = List<Map<String, dynamic>>.from(
          sampleUser['transactions'],
        );
        violationResults = List<Map<String, dynamic>>.from(
          sampleUser['violations'],
        );
        isUserSearch = true;
        _tabController.animateTo(0);
        return;
      }

      final matchedVehicle = vehicleData.firstWhere(
        (v) => v['plateNumber'] == query,
        orElse: () => {},
      );
      if (matchedVehicle.isNotEmpty) {
        vehicleResults = [matchedVehicle];
        if (matchedVehicle['transactions'] != null) {
          transactionResults = List<Map<String, dynamic>>.from(
            matchedVehicle['transactions'],
          );
        }
        if (matchedVehicle['violations'] != null) {
          violationResults = List<Map<String, dynamic>>.from(
            matchedVehicle['violations'],
          );
        }
        isVehicleSearch = true;
        showVehicleOwnerInsteadOfColor = true;
        _tabController.animateTo(2);
        return;
      }

      final matchedTransaction = transactionData.firstWhere(
        (t) => t['transactionId'] == query,
        orElse: () => {},
      );
      if (matchedTransaction.isNotEmpty) {
        transactionResults = [matchedTransaction];
        isTransactionSearch = true;
        if (matchedTransaction['vehicleInfo'] != null) {
          final vehicle = Map<String, dynamic>.from(
            matchedTransaction['vehicleInfo'],
          );
          vehicle['ownerName'] = matchedTransaction['ownerName'];
          vehicle['ownerId'] = matchedTransaction['ownerId'];
          vehicle['licenseExpiryDate'] = vehicle['licenseExpiryDate'] ?? '—';
          vehicleResults = [vehicle];
          showVehicleOwnerInsteadOfColor = true;
        } else {
          vehicleResults = [];
        }
        _tabController.animateTo(1);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade600,
          centerTitle: true,
          title: const Text(
            'البحث في النظام',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'أدخل رقم الهوية أو المعاملة أو المركبة أو الاسم الرباعي',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                    ),
                    child: const Text('بحث'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (!searchExecuted)
                const SizedBox()
              else if (userResults.isEmpty &&
                  vehicleResults.isEmpty &&
                  transactionResults.isEmpty)
                Column(
                  children: const [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'لا توجد نتائج مطابقة لمدخلات البحث',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.blue.shade700,
                        tabs: const [
                          Tab(text: 'المستخدمون'),
                          Tab(text: 'المعاملات'),
                          Tab(text: 'المركبات'),
                          Tab(text: 'المخالفات'),
                        ],
                        onTap: (index) {
                          if (isTransactionSearch &&
                              index == 2 &&
                              vehicleResults.isEmpty) {
                            _tabController.animateTo(1);
                            return;
                          }
                          if ((isVehicleSearch || isTransactionSearch) &&
                              index == 0) {
                            _tabController.animateTo(isVehicleSearch ? 2 : 1);
                            return;
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            isUserSearch
                                ? _buildUserTable()
                                : const Center(child: Text('غير متاح')),
                            transactionResults.isNotEmpty
                                ? _buildTransactionTable()
                                : const Center(child: Text('لا توجد معاملات')),
                            vehicleResults.isNotEmpty
                                ? _buildVehicleTable()
                                : const Center(child: Text('لا توجد مركبات')),
                            violationResults.isNotEmpty
                                ? _buildViolationsTable()
                                : const Center(child: Text('لا توجد مخالفات')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTable() {
    final user = userResults.first;
    return DataTable2(
      columnSpacing: 20,
      columns: const [
        DataColumn(label: Text('الاسم')),
        DataColumn(label: Text('الهوية')),
        DataColumn(label: Text('تاريخ الميلاد')),
        DataColumn(label: Text('الهاتف')),
        DataColumn(label: Text('البريد الإلكتروني')),
        DataColumn(label: Text('العنوان')),
        DataColumn(label: Text('لديه حساب')),
        DataColumn(label: Text('حالة الحساب')),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(user['fullName'])),
            DataCell(Text(user['nationalId'])),
            DataCell(Text(user['birthDate'])),
            DataCell(Text(user['phone'])),
            DataCell(Text(user['email'])),
            DataCell(Text(user['address'])),
            DataCell(Text(user['hasAccount'] ? 'نعم' : 'لا')),
            DataCell(Text(user['accountStatus'])),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionTable() {
    return DataTable2(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text('رقم المعاملة')),
        DataColumn(label: Text('نوع المعاملة')),
        DataColumn(label: Text('آخر موظف راجعها')),
        DataColumn(label: Text('التاريخ')),
        DataColumn(label: Text('الحالة')),
        DataColumn(label: Text('الرسوم')),
        DataColumn(label: Text('طريقة التقديم')),
      ],
      rows:
          transactionResults.map((txn) {
            return DataRow(
              cells: [
                DataCell(Text(txn['transactionId'])),
                DataCell(Text(txn['type'])),
                DataCell(Text(txn['lastReviewedBy'] ?? '—')),
                DataCell(Text(txn['date'])),
                DataCell(Text(txn['status'])),
                DataCell(Text('${txn['fee']} ₪')),
                DataCell(Text(txn['submittedVia'])),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildVehicleTable() {
    return DataTable2(
      columnSpacing: 12,
      columns:
          showVehicleOwnerInsteadOfColor
              ? const [
                DataColumn(label: Text('رقم اللوحة')),
                DataColumn(label: Text('النوع')),
                DataColumn(label: Text('الطراز')),
                DataColumn(label: Text('اسم المالك')),
                DataColumn(label: Text('رقم الهوية')),
                DataColumn(label: Text('الحالة')),
                DataColumn(label: Text('انتهاء الترخيص')),
              ]
              : const [
                DataColumn(label: Text('رقم اللوحة')),
                DataColumn(label: Text('النوع')),
                DataColumn(label: Text('الطراز')),
                DataColumn(label: Text('اللون')),
                DataColumn(label: Text('الوقود')),
                DataColumn(label: Text('الحالة')),
                DataColumn(label: Text('انتهاء الترخيص')),
              ],
      rows:
          vehicleResults.map((v) {
            return DataRow(
              cells: [
                DataCell(Text(v['plateNumber'] ?? '—')),
                DataCell(Text(v['type'] ?? '—')),
                DataCell(Text(v['model'] ?? '—')),
                DataCell(
                  Text(
                    showVehicleOwnerInsteadOfColor
                        ? (v['ownerName'] ?? '—')
                        : (v['color'] ?? '—'),
                  ),
                ),
                DataCell(
                  Text(
                    showVehicleOwnerInsteadOfColor
                        ? (v['ownerId'] ?? '—')
                        : (v['fuelType'] ?? '—'),
                  ),
                ),
                DataCell(Text(v['status'] ?? '—')),
                DataCell(Text(v['licenseExpiryDate'] ?? '—')),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildViolationsTable() {
    return DataTable2(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text('رقم المخالفة')),
        DataColumn(label: Text('التاريخ')),
        DataColumn(label: Text('النوع')),
        DataColumn(label: Text('الموقع')),
        DataColumn(label: Text('الغرامة')),
        DataColumn(label: Text('الحالة')),
        DataColumn(label: Text('المصدر')),
      ],
      rows:
          violationResults.map((v) {
            return DataRow(
              cells: [
                DataCell(Text(v['violationId'] ?? '—')),
                DataCell(Text(v['date'] ?? '—')),
                DataCell(Text(v['type'] ?? '—')),
                DataCell(Text(v['location'] ?? '—')),
                DataCell(Text('${v['fineAmount'] ?? 0} ₪')),
                DataCell(Text(v['status'] ?? '—')),
                DataCell(Text(v['recordedBy'] ?? '—')),
              ],
            );
          }).toList(),
    );
  }
}
