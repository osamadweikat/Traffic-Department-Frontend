import 'package:flutter/material.dart';
import 'package:traffic_department/data/activity_log_data.dart';

class AdminActivityLogScreen extends StatefulWidget {
  const AdminActivityLogScreen({super.key});

  @override
  State<AdminActivityLogScreen> createState() => _AdminActivityLogScreenState();
}

class _AdminActivityLogScreenState extends State<AdminActivityLogScreen> {
  String selectedFilter = 'الكل';
  String searchQuery = '';

  final List<String> filters = [
    'الكل',
    'تسجيل دخول',
    'تسجيل خروج',
    'تعديل معاملة',
    'إضافة معاملة',
    'حذف معاملة',
    'رفض معاملة',
    'تحويل معاملة',
    'تغيير كلمة مرور',
    'تحديث بيانات مستخدم',
  ];

  final Map<String, Color> colorMap = {
    'تسجيل دخول': Colors.green.shade100,
    'تسجيل خروج': Colors.green.shade50,
    'تعديل معاملة': Colors.blue.shade100,
    'إضافة معاملة': Colors.purple.shade100,
    'حذف معاملة': Colors.red.shade100,
    'رفض معاملة': Colors.orange.shade100,
    'تحويل معاملة': Colors.lightBlue.shade100,
    'تغيير كلمة مرور': Colors.deepPurple.shade100,
    'تحديث بيانات مستخدم': Colors.blueGrey.shade100,
  };

  final Map<String, IconData> iconMap = {
    'تسجيل دخول': Icons.login,
    'تسجيل خروج': Icons.logout,
    'تعديل معاملة': Icons.edit,
    'إضافة معاملة': Icons.add_circle_outline,
    'حذف معاملة': Icons.delete_outline,
    'رفض معاملة': Icons.cancel_outlined,
    'تحويل معاملة': Icons.swap_horiz,
    'تغيير كلمة مرور': Icons.lock_reset,
    'تحديث بيانات مستخدم': Icons.person_outline,
  };

  @override
  Widget build(BuildContext context) {
    final filteredLogs = activityLog.where((log) {
      final matchesFilter = selectedFilter == 'الكل' || log['actionType'] == selectedFilter;

      final combinedFields = '${log['datetime']} ${log['userName']} ${log['employeeId']} ${log['actionType']} ${log['details']} ${log['reference']}';
      final matchesSearch = combinedFields.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          title: const Text(
            'سجل العمليات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false, 
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث في سجل العمليات...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue.shade900 : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    final actionType = log['actionType'];
                    final bgColor = colorMap[actionType] ?? Colors.grey.shade200;
                    final icon = iconMap[actionType] ?? Icons.info_outline;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blueGrey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text(
                              log['datetime'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(icon, size: 24, color: Colors.black87),
                                const SizedBox(width: 8),
                                Text(
                                  actionType,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'المستخدم: ${log['userName']} (${log['employeeId']})',
                              style: const TextStyle(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'التفاصيل: ${log['details']}',
                              style: const TextStyle(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 6),
                            if (log['reference'] != '-' && (log['reference'] as String).isNotEmpty)
                              Text(
                                'المرجع: ${log['reference']}',
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.right,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
