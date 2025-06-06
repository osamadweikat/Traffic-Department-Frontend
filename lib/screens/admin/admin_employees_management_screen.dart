import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_employees_data.dart';

class AdminEmployeesManagementScreen extends StatefulWidget {
  const AdminEmployeesManagementScreen({super.key});

  @override
  State<AdminEmployeesManagementScreen> createState() =>
      _AdminEmployeesManagementScreenState();
}

class _AdminEmployeesManagementScreenState
    extends State<AdminEmployeesManagementScreen> {
  String selectedStatusFilter = 'الكل';
  String searchQuery = '';

  List<Map<String, String>> get filteredEmployees {
    List<Map<String, String>> filtered = adminEmployeesData;

    if (selectedStatusFilter != 'الكل') {
      filtered =
          filtered
              .where((emp) => emp['status'] == selectedStatusFilter)
              .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (emp) =>
                    emp['fullName']!.contains(searchQuery) ||
                    emp['nationalId']!.contains(searchQuery) ||
                    emp['email']!.contains(searchQuery),
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
            'إدارة الموظفين',
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
              ElevatedButton.icon(
                onPressed: () {
                  _showAddEmployeeDialog();
                },
                icon: const Icon(Icons.person_add),
                label: const Text('إضافة موظف جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن موظف بالاسم أو رقم الهوية أو البريد',
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
                    _buildFilterButton('مفعل'),
                    _buildFilterButton('غير مفعل'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('رقم الموظف')),
                      DataColumn(label: Text('الاسم الكامل')),
                      DataColumn(label: Text('رقم الهوية')),
                      DataColumn(label: Text('البريد الإلكتروني')),
                      DataColumn(label: Text('رقم الهاتف')),
                      DataColumn(label: Text('القسم')),
                      DataColumn(label: Text('الحالة')),
                      DataColumn(label: Text('إجراءات')),
                    ],
                    rows:
                        filteredEmployees.map((emp) {
                          return DataRow(
                            cells: [
                              DataCell(Text(emp['id']!)),
                              DataCell(Text(emp['fullName']!)),
                              DataCell(Text(emp['nationalId']!)),
                              DataCell(Text(emp['email']!)),
                              DataCell(Text(emp['phone']!)),
                              DataCell(Text(emp['department']!)),
                              DataCell(
                                Text(
                                  emp['status']!,
                                  style: TextStyle(
                                    color:
                                        emp['status'] == 'مفعل'
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
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        _showEditEmployeeDialog(emp);
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteEmployee(emp);
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

  void _showEditEmployeeDialog(Map<String, String> emp) {
    final _emailController = TextEditingController(text: emp['email']);
    final _phoneController = TextEditingController(text: emp['phone']);
    final _departmentController = TextEditingController(
      text: emp['department'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('تعديل بيانات الموظف: ${emp['fullName']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_emailController, 'البريد الإلكتروني'),
                _buildTextField(_phoneController, 'رقم الهاتف'),
                _buildTextField(_departmentController, 'القسم'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  emp['email'] = _emailController.text;
                  emp['phone'] = _phoneController.text;
                  emp['department'] = _departmentController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
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

  void _showAddEmployeeDialog() {
    final _fullNameController = TextEditingController();
    final _nationalIdController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _departmentController = TextEditingController();
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('إضافة موظف جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_fullNameController, 'الاسم الكامل'),
                _buildTextField(_nationalIdController, 'رقم الهوية *'),
                _buildTextField(_emailController, 'البريد الإلكتروني'),
                _buildTextField(_phoneController, 'رقم الهاتف'),
                _buildTextField(_departmentController, 'القسم'),
                _buildTextField(
                  _passwordController,
                  'كلمة السر المؤقتة *',
                  isPassword: true,
                ),

                const SizedBox(height: 12),
                Container(alignment: Alignment.centerLeft),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (_nationalIdController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('رقم الهوية وكلمة السر مطلوبة!'),
                    ),
                  );
                  return;
                }

                setState(() {
                  adminEmployeesData.add({
                    'id': (adminEmployeesData.length + 1).toString(),
                    'fullName': _fullNameController.text,
                    'nationalId': _nationalIdController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'department': _departmentController.text,
                    'status': 'غير مفعل', 
                    'createdAt': DateTime.now().toString().substring(0, 10),
                    'lastLogin': '',
                    'transactionsCount': '0',
                    'password': _passwordController.text,
                    'firstLogin': 'true',
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteEmployee(Map<String, String> emp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text(
            'هل أنت متأكد أنك تريد حذف الموظف: ${emp['fullName']} ؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  adminEmployeesData.removeWhere((e) => e['id'] == emp['id']);
                });
                Navigator.pop(context);
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
