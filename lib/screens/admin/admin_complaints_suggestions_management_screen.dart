import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_complaints_suggestions_data.dart';

class AdminComplaintsSuggestionsManagementScreen extends StatefulWidget {
  const AdminComplaintsSuggestionsManagementScreen({super.key});

  @override
  State<AdminComplaintsSuggestionsManagementScreen> createState() =>
      _AdminComplaintsSuggestionsManagementScreenState();
}

class _AdminComplaintsSuggestionsManagementScreenState
    extends State<AdminComplaintsSuggestionsManagementScreen> {
  String selectedTypeFilter = 'الكل';
  String selectedStatusFilter = 'الكل';
  String searchQuery = '';
  List<String> selectedComplaintIds = [];

  List<Map<String, String>> get filteredItems {
    List<Map<String, String>> filtered = adminComplaintsSuggestionsData;

    if (selectedTypeFilter != 'الكل') {
      filtered =
          filtered.where((item) => item['type'] == selectedTypeFilter).toList();
    }

    if (selectedStatusFilter != 'الكل') {
      filtered =
          filtered
              .where((item) => item['status'] == selectedStatusFilter)
              .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (item) =>
                    item['id']!.contains(searchQuery) ||
                    item['citizenName']!.contains(searchQuery) ||
                    item['nationalId']!.contains(searchQuery),
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
            'إدارة الشكاوي والاقتراحات',
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
                  hintText: 'ابحث عن عنصر (رقم / اسم المواطن / رقم الهوية)',
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

              Row(
                children: [
                  _buildTypeFilterButton('الكل'),
                  _buildTypeFilterButton('شكوى'),
                  _buildTypeFilterButton('اقتراح'),
                  const SizedBox(width: 16),
                  ..._getAvailableStatusFilters().map(
                    (status) => _buildStatusFilterButton(status),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (selectedComplaintIds.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    _showAssignEmployeeDialog();
                  },
                  icon: const Icon(Icons.send),
                  label: Text(
                    'إرسال ${selectedComplaintIds.length} شكوى إلى موظف',
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
                              if (selectedTypeFilter != 'اقتراح')
                                Checkbox(
                                  value: _areAllSelected(),
                                  onChanged: (value) {
                                    _toggleSelectAll(value ?? false);
                                  },
                                ),
                              const SizedBox(width: 8),
                              const Text('رقم العنصر'),
                            ],
                          ),
                        ),
                        const DataColumn(label: Text('اسم المواطن')),
                        const DataColumn(label: Text('رقم الهوية')),
                        const DataColumn(label: Text('النوع')),
                        const DataColumn(label: Text('الفئة')),
                        const DataColumn(label: Text('المحتوى')),
                        const DataColumn(label: Text('الحالة')),
                        const DataColumn(label: Text('تاريخ الإرسال')),
                        const DataColumn(label: Text('موظف معين')),
                        const DataColumn(label: Text('إجراءات')),
                      ],
                      rows:
                          filteredItems.map((item) {
                            final isSelected = selectedComplaintIds.contains(
                              item['id'],
                            );
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (states) =>
                                    isSelected
                                        ? Colors.lightBlue.shade100
                                        : null,
                              ),
                              cells: [
                                _buildInteractiveCell(item, item['id']!),
                                _buildInteractiveCell(
                                  item,
                                  item['citizenName']!,
                                ),
                                _buildInteractiveCell(
                                  item,
                                  item['nationalId']!,
                                ),
                                _buildInteractiveCell(item, item['type']!),
                                _buildInteractiveCell(item, item['category']!),
                                _buildInteractiveContentCell(
                                  item,
                                  item['content']!.length > 40
                                      ? '${item['content']!.substring(0, 40)}...'
                                      : item['content']!,
                                ),

                                _buildInteractiveCell(
                                  item,
                                  item['status']!,
                                  style: TextStyle(
                                    color: _getStatusColor(item['status']!),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildInteractiveCell(item, item['createdAt']!),
                                _buildInteractiveCell(
                                  item,
                                  item['assignedEmployeeId']!.isEmpty
                                      ? '-'
                                      : item['assignedEmployeeId']!,
                                ),
                                DataCell(
                                  item['type'] == 'اقتراح'
                                      ? ElevatedButton(
                                        onPressed:
                                            item['status'] == 'جديدة'
                                                ? () {
                                                  _showReplyDialog(item);
                                                }
                                                : null,
                                        child: const Text('رد على اقتراح'),
                                      )
                                      : const SizedBox(),
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

  DataCell _buildInteractiveCell(
    Map<String, String> item,
    String text, {
    TextStyle? style,
  }) {
    return DataCell(
      InkWell(
        onTap: () {
          if (item['type'] == 'شكوى' && item['status'] == 'جديدة') {
            _toggleComplaintSelection(item['id']!);
          } else if (item['type'] == 'اقتراح') {
            _showItemDetails(item);
          }
        },
        child: Text(text, style: style),
      ),
    );
  }

  List<String> _getAvailableStatusFilters() {
    if (selectedTypeFilter == 'اقتراح') {
      return ['الكل', 'جديدة', 'تم الرد'];
    } else {
      return ['الكل', 'جديدة', 'قيد المعالجة', 'تم الرد', 'مرفوضة'];
    }
  }

  DataCell _buildInteractiveContentCell(Map<String, String> item, String text) {
    return DataCell(
      InkWell(
        onTap: () {
          if (item['type'] == 'شكوى') {
            _showContentDialog(item);
          } else if (item['type'] == 'اقتراح') {
            _showItemDetails(
              item,
            );
          }
        },
        child: Text(text),
      ),
    );
  }

  void _showContentDialog(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('محتوى ${item['type']} رقم ${item['id']}'),
          content: SingleChildScrollView(child: Text(item['content']!)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTypeFilterButton(String type) {
    final bool isSelected = selectedTypeFilter == type;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedTypeFilter = type;
            selectedComplaintIds.clear();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(type),
      ),
    );
  }

  Widget _buildStatusFilterButton(String status) {
    final bool isSelected = selectedStatusFilter == status;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedStatusFilter = status;
            selectedComplaintIds.clear();
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

  void _toggleComplaintSelection(String complaintId) {
    setState(() {
      if (selectedComplaintIds.contains(complaintId)) {
        selectedComplaintIds.remove(complaintId);
      } else {
        selectedComplaintIds.add(complaintId);
      }
    });
  }

  bool _areAllSelected() {
    final newComplaints =
        filteredItems
            .where(
              (item) => item['type'] == 'شكوى' && item['status'] == 'جديدة',
            )
            .toList();
    return newComplaints.isNotEmpty &&
        newComplaints.every(
          (item) => selectedComplaintIds.contains(item['id']),
        );
  }

  void _toggleSelectAll(bool selectAll) {
    setState(() {
      final newComplaints =
          filteredItems
              .where(
                (item) => item['type'] == 'شكوى' && item['status'] == 'جديدة',
              )
              .toList();
      if (selectAll) {
        selectedComplaintIds =
            newComplaints.map((item) => item['id']!).toList();
      } else {
        selectedComplaintIds.clear();
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
          title: const Text('إرسال الشكاوي إلى موظف'),
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
                  for (var item in adminComplaintsSuggestionsData) {
                    if (selectedComplaintIds.contains(item['id'])) {
                      item['status'] = 'قيد المعالجة';
                      item['assignedEmployeeId'] = employeeId;
                      item['lastUpdated'] = DateTime.now().toString().substring(
                        0,
                        10,
                      );
                    }
                  }
                  selectedComplaintIds.clear();
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

  void _showReplyDialog(Map<String, String> item) {
    final _replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('رد على الاقتراح: ${item['id']}'),
          content: TextField(
            controller: _replyController,
            decoration: const InputDecoration(labelText: 'نص الرد'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  item['status'] = 'تم الرد';
                  item['adminReply'] = _replyController.text;
                  item['lastUpdated'] = DateTime.now().toString().substring(
                    0,
                    10,
                  );
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

  void _showItemDetails(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تفاصيل العنصر: ${item['id']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('النوع: ${item['type']}'),
                Text('الفئة: ${item['category']}'),
                const SizedBox(height: 8),
                const Text('النص الكامل:'),
                const SizedBox(height: 4),
                Text(item['content']!),
                if (item['type'] == 'اقتراح' &&
                    item['adminReply']!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('رد الأدمن:'),
                  const SizedBox(height: 4),
                  Text(item['adminReply']!),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
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
      case 'قيد المعالجة':
        return Colors.orange;
      case 'تم الرد':
        return Colors.green;
      case 'مرفوضة':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
