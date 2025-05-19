import 'package:flutter/material.dart';
import 'package:traffic_department/data/complaints_data.dart';

class TrackComplaintsScreen extends StatefulWidget {
  const TrackComplaintsScreen({super.key});

  @override
  State<TrackComplaintsScreen> createState() => _TrackComplaintsScreenState();
}

class _TrackComplaintsScreenState extends State<TrackComplaintsScreen> {
  int? expandedIndex;
  Map<int, String> selectedStatuses = {};
  Map<int, TextEditingController> commentControllers = {};

  Color getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'new':
        return 'جديدة';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'resolved':
        return 'تم الرد';
      case 'rejected':
        return 'مرفوضة';
      default:
        return 'غير معروف';
    }
  }

  void updateComplaintStatus(int index) {
    final newStatus = selectedStatuses[index];
    if (newStatus != null && newStatus != complaints[index]['status']) {
      setState(() {
        complaints[index]['status'] = newStatus;
        expandedIndex = null;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'تم تحديث حالة الشكوى بنجاح',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepOrange,
          title: const Text(
            'متابعة الشكاوى',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            final isExpanded = expandedIndex == index;
            final currentStatus = complaint['status'];
            final isFinal =
                currentStatus == 'resolved' || currentStatus == 'rejected';

            commentControllers.putIfAbsent(
              index,
              () => TextEditingController(),
            );

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'رقم الشكوى: #${complaint['id']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Chip(
                        label: Text(
                          getStatusLabel(currentStatus),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: getStatusColor(currentStatus),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    complaint['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),
                  Text(complaint['description'], textAlign: TextAlign.right),
                  const SizedBox(height: 6),
                  Text(
                    'تاريخ التقديم: ${complaint['date']}',
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 10),
                  if (!isExpanded)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => expandedIndex = index),
                        icon: const Icon(Icons.visibility),
                        label: const Text('عرض التفاصيل'),
                      ),
                    ),
                  if (isExpanded) ...[
                    const Divider(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _detailRow('نوع الشكوى:', complaint['type']),
                          _detailRow(
                            'الاسم الكامل:',
                            complaint['fullName'] ?? '---',
                          ),
                          _detailRow(
                            'رقم الهوية:',
                            complaint['nationalId'] ?? '---',
                          ),
                          _detailRow(
                            'رقم الهاتف:',
                            complaint['phone'] ?? '---',
                          ),
                          _detailRow(
                            'البريد الإلكتروني:',
                            complaint['email'] ?? '---',
                          ),
                          if (complaint['attachment'] != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    complaint['attachment'],
                                    style: const TextStyle(
                                      color: Color(0xFF1E88E5),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (!isFinal) ...[
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'اختر الحالة الجديدة:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            if (currentStatus != 'in_progress')
                              _statusOption(
                                index,
                                'in_progress',
                                'قيد المعالجة',
                                Colors.orange,
                              ),
                            _statusOption(
                              index,
                              'resolved',
                              'تم الرد',
                              Colors.green,
                            ),
                            _statusOption(
                              index,
                              'rejected',
                              'مرفوضة',
                              Colors.red,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: commentControllers[index],
                        maxLines: 3,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'أدخل تعليق الموظف...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => updateComplaintStatus(index),
                          icon: const Icon(Icons.refresh), 
                          label: const Text('تحديث الحالة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ] else
                      const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => expandedIndex = null),
                        icon: const Icon(Icons.close),
                        label: const Text('إغلاق التفاصيل'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              TextSpan(
                text: ' $value',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusOption(int index, String value, String label, Color color) {
    final selected = selectedStatuses[index] == value;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: color.withOpacity(0.8),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (_) {
        setState(() {
          selectedStatuses[index] = value;
        });
      },
    );
  }
}
