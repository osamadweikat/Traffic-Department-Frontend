import 'package:flutter/material.dart';

enum NotificationType { all, system, transaction, admin, other }

class NotificationsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;
  const NotificationsScreen({super.key, required this.notifications});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<Map<String, dynamic>> localNotifications;
  NotificationType selectedType = NotificationType.all;
  int? hoveredIndex;

  @override
  void initState() {
    super.initState();
    localNotifications = [...widget.notifications];
  }

  void markAllAsRead() {
    setState(() {
      for (var n in localNotifications) {
        n['isUnread'] = false;
      }
    });
  }

  void markAsRead(int index) {
    setState(() {
      localNotifications[index]['isUnread'] = false;
    });
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedType == NotificationType.all) return localNotifications;
    return localNotifications.where((n) => n['type'] == selectedType).toList();
  }

  @override
  void dispose() {
    Navigator.pop(context, localNotifications);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF1E3A5F),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Spacer(),
                const Text(
                  'الإشعارات',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 8,
              children: NotificationType.values.map((type) {
                final label = _typeLabel(type);
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedType = type),
                  selectedColor: Colors.orange.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.deepOrange : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: markAllAsRead,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.done_all),
                label: const Text('تمييز الكل كمقروء'),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredNotifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد إشعارات حالياً',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final n = filteredNotifications[index];
                      final fullIndex = localNotifications.indexOf(n);
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = fullIndex),
                        onExit: (_) => setState(() => hoveredIndex = null),
                        child: _buildCard(n, fullIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    final isUnread = item['isUnread'] == true;
    final type = item['type'] as NotificationType;
    final color = _typeColor(type);
    final isHovered = hoveredIndex == index;

    return GestureDetector(
      onTap: () => markAsRead(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread ? color.withOpacity(0.07) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread ? color.withOpacity(0.4) : Colors.grey.shade300,
          ),
          boxShadow: isHovered
              ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_typeIcon(type), color: isUnread ? color : Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  item['title'],
                  style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item['message'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(item['date'], style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(width: 10),
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(item['time'], style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return 'النظام';
      case NotificationType.transaction:
        return 'المعاملات';
      case NotificationType.admin:
        return 'إدارية';
      case NotificationType.other:
        return 'أخرى';
      default:
        return 'الكل';
    }
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.transaction:
        return Icons.directions_car;
      case NotificationType.admin:
        return Icons.policy;
      case NotificationType.other:
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Colors.blue;
      case NotificationType.transaction:
        return Colors.indigo;
      case NotificationType.admin:
        return Colors.deepOrange;
      case NotificationType.other:
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}
