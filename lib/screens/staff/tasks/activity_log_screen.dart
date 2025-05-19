import 'package:flutter/material.dart';
import 'package:traffic_department/data/activity_log.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  String selectedTypeGroup = 'الكل';

  final List<String> typeGroups = [
    'الكل',
    'المعاملات',
    'المستخدمين',
    'المراسلات',
    'التقارير',
    'البيانات',
    'الاستعلامات',
  ];

  List<Map<String, dynamic>> get filteredActivities {
    return activityLog.where((activity) {
      final activityDate = DateTime.parse(activity['date']);
      final matchesDate =
          (fromDate == null || !activityDate.isBefore(fromDate!)) &&
          (toDate == null || !activityDate.isAfter(toDate!));
      final matchesType =
          selectedTypeGroup == 'الكل' ||
          _matchesGroup(activity['type'], selectedTypeGroup);
      return matchesDate && matchesType;
    }).toList();
  }

  bool _matchesGroup(String type, String group) {
    switch (group) {
      case 'المعاملات':
        return type.contains('معاملة');
      case 'المستخدمين':
        return type.contains('تأكيد');
      case 'المراسلات':
        return type.contains('مراسلة') || type.contains('ملاحظة');
      case 'التقارير':
        return type.contains('تقرير');
      case 'البيانات':
        return type.contains('تعديل');
      case 'الاستعلامات':
        return type.contains('بحث') || type.contains('شكوى');
      default:
        return true;
    }
  }

  void setQuickDateRange(String range) {
    final now = DateTime.now();
    setState(() {
      switch (range) {
        case 'اليوم':
          fromDate = DateTime(now.year, now.month, now.day);
          toDate = now;
          break;
        case 'هذا الأسبوع':
          fromDate = now.subtract(const Duration(days: 7));
          toDate = now;
          break;
        case 'هذا الشهر':
          fromDate = DateTime(now.year, now.month, 1);
          toDate = now;
          break;
        case 'الكل':
          fromDate = null;
          toDate = null;
          break;
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
          backgroundColor: Color(0xFF837060),
          centerTitle: true,
          title: const Text(
            'سجل النشاطات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickFilters(),
              const SizedBox(height: 20),
              Text(
                'عدد السجلات: ${filteredActivities.length}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredActivities.length,
                  itemBuilder: (context, index) {
                    final activity = filteredActivities[index];
                    return _buildActivityCard(activity);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfWeek = now.subtract(const Duration(days: 7));
    final startOfMonth = DateTime(now.year, now.month, 1);

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today, color: Color(0xFF837060)),
            SizedBox(width: 8),
            Text(
              'الفلترة حسب التاريخ:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children:
              ['الكل', 'اليوم', 'هذا الأسبوع', 'هذا الشهر'].map((label) {
                final isSelected =
                    (label == 'اليوم' &&
                        fromDate != null &&
                        isSameDay(fromDate!, startOfToday) &&
                        isSameDay(toDate!, now)) ||
                    (label == 'هذا الأسبوع' &&
                        fromDate != null &&
                        isSameDay(fromDate!, startOfWeek) &&
                        isSameDay(toDate!, now)) ||
                    (label == 'هذا الشهر' &&
                        fromDate != null &&
                        isSameDay(fromDate!, startOfMonth) &&
                        isSameDay(toDate!, now)) ||
                    (label == 'الكل' && fromDate == null && toDate == null);

                return ChoiceChip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Color(0xFF837060),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => setQuickDateRange(label),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.auto_awesome_motion, color: Color(0xFF837060)),
            SizedBox(width: 8),
            Text(
              'الفلترة حسب نوع النساط:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children:
              typeGroups.map((type) {
                final isSelected = selectedTypeGroup == type;
                return ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Color(0xFF837060),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => setState(() => selectedTypeGroup = type),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(activity['color']).withOpacity(0.15),
          child: Icon(
            _getIcon(activity['icon']),
            color: Color(activity['color']),
          ),
        ),
        title: Text(
          activity['type'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity['details']),
            const SizedBox(height: 4),
            Text(
              '${activity['date']} • ${activity['time']}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'download':
        return Icons.download;
      case 'verified':
        return Icons.verified_user;
      case 'cancel':
        return Icons.cancel;
      case 'autorenew':
        return Icons.autorenew;
      case 'send':
        return Icons.send;
      case 'note_alt':
        return Icons.note_alt;
      case 'search':
        return Icons.search;
      case 'directions_car':
        return Icons.directions_car;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf;
      case 'report_problem':
        return Icons.report_problem;
      default:
        return Icons.info_outline;
    }
  }
}
