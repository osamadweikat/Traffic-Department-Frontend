import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_users_data.dart';

class AdminUsersManagementScreen extends StatefulWidget {
  const AdminUsersManagementScreen({super.key});

  @override
  State<AdminUsersManagementScreen> createState() =>
      _AdminUsersManagementScreenState();
}

class _AdminUsersManagementScreenState
    extends State<AdminUsersManagementScreen> {
  String selectedRoleFilter = 'الكل';
  String searchQuery = '';

  List<Map<String, String>> get filteredUsers {
    List<Map<String, String>> filtered = adminUsersData;

    if (selectedRoleFilter != 'الكل') {
      filtered =
          filtered.where((user) => user['role'] == selectedRoleFilter).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (user) =>
                    user['fullName']!.contains(searchQuery) ||
                    user['nationalId']!.contains(searchQuery) ||
                    user['email']!.contains(searchQuery),
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
            'إدارة المستخدمين',
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
                  hintText: 'ابحث عن مستخدم بالاسم أو رقم الهوية أو البريد',
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
                    _buildFilterButton('أدمن'),
                    _buildFilterButton('موظف'),
                    _buildFilterButton('مواطن'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('رقم المستخدم')),
                      DataColumn(label: Text('الاسم الكامل')),
                      DataColumn(label: Text('رقم الهوية')),
                      DataColumn(label: Text('البريد الإلكتروني')),
                      DataColumn(label: Text('الدور')),
                      DataColumn(label: Text('الحالة')),
                      DataColumn(label: Text('إجراءات')),
                    ],
                    rows:
                        filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user['id']!)),
                              DataCell(Text(user['fullName']!)),
                              DataCell(Text(user['nationalId']!)),
                              DataCell(Text(user['email']!)),
                              DataCell(Text(user['role']!)),
                              DataCell(
                                Text(
                                  user['status']!,
                                  style: TextStyle(
                                    color:
                                        user['status'] == 'مفعل'
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'تفاصيل المستخدم: ${user['fullName']}',
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'رقم الهوية: ${user['nationalId']}',
                                                  ),
                                                  Text(
                                                    'البريد الإلكتروني: ${user['email']}',
                                                  ),
                                                  Text(
                                                    'الدور: ${user['role']}',
                                                  ),
                                                  Text(
                                                    'الحالة: ${user['status']}',
                                                  ),
                                                  Text(
                                                    'رقم الهاتف: ${user['phone']}',
                                                  ),
                                                  Text(
                                                    'العنوان: ${user['address']}',
                                                  ),
                                                  Text(
                                                    'تاريخ إنشاء الحساب: ${user['createdAt']}',
                                                  ),
                                                  Text(
                                                    'آخر تسجيل دخول: ${user['lastLogin']}',
                                                  ),
                                                  Text(
                                                    'عدد المعاملات: ${user['transactionsCount']}',
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text('إغلاق'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('تأكيد الحذف'),
                                              content: Text(
                                                'هل أنت متأكد أنك تريد حذف المستخدم: ${user['fullName']} ؟',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ), 
                                                  child: const Text('إلغاء'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      adminUsersData
                                                          .removeWhere(
                                                            (u) =>
                                                                u['id'] ==
                                                                user['id'],
                                                          );
                                                    });
                                                    Navigator.pop(
                                                      context,
                                                    ); 
                                                  },
                                                  child: const Text(
                                                    'حذف',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String role) {
    final bool isSelected = selectedRoleFilter == role;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedRoleFilter = role;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(role),
      ),
    );
  }
}
