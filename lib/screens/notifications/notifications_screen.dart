import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/notifications/notification_details_screen.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      "title": "تم قبول طلب تجديد رخصة القيادة",
      "date": "2025-03-31",
      "isRead": false,
      "details": "تفاصيل قبول طلب تجديد الرخصة"
    },
    {
      "title": "تم رفض طلب نقل ملكية مركبة",
      "date": "2025-03-30",
      "isRead": true,
      "details": "تفاصيل رفض نقل الملكية"
    },
    {
      "title": "تم إصدار مخالفة جديدة على المركبة",
      "date": "2025-03-29",
      "isRead": false,
      "details": "تفاصيل المخالفة الجديدة"
    },
    {
      "title": "موعد فحص عملي قادم غداً",
      "date": "2025-03-28",
      "isRead": true,
      "details": "تفاصيل موعد الفحص العملي"
    },
  ];

  String filter = 'all';

  List<Map<String, dynamic>> get filteredNotifications {
    if (filter == 'unread') {
      return notifications.where((n) => !n["isRead"]).toList();
    } else if (filter == 'read') {
      return notifications.where((n) => n["isRead"]).toList();
    }
    return notifications;
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('notification_deleted'.tr())),
    );
  }

  void deleteAll() {
    setState(() {
      notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('all_notifications_deleted'.tr())),
    );
  }

  void openNotificationDetails(int index) {
    markAsRead(index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailsScreen(
          title: notifications[index]["title"],
          date: notifications[index]["date"],
          details: notifications[index]["details"],
        ),
      ),
    );
  }

  void showCustomMenu() async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      items: [
        _buildFilterItem('all'),
        _buildFilterItem('unread'),
        _buildFilterItem('read'),
      ],
    );

    if (selected != null) {
      setState(() {
        filter = selected;
      });
    }
  }

  PopupMenuItem<String> _buildFilterItem(String value) {
    return PopupMenuItem(
      value: value,
      child: Text(
        'filter_$value'.tr(),
        style: TextStyle(
          color: filter == value ? Colors.blue : Colors.black,
          fontWeight: filter == value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notifications_title".tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "delete_all_tooltip".tr(),
            onPressed: notifications.isEmpty ? null : deleteAll,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showCustomMenu,
          ),
        ],
      ),
      backgroundColor: AppTheme.lightGrey,
      body: filteredNotifications.isEmpty
          ? Center(child: Text("no_notifications".tr()))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                int realIndex = notifications.indexOf(filteredNotifications[index]);
                bool isNew = !filteredNotifications[index]["isRead"];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => deleteNotification(realIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isNew ? const Color(0xFFFFF8E1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_none, color: Colors.grey, size: 30),
                      title: Text(
                        filteredNotifications[index]["title"],
                        style: TextStyle(
                          fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text("notification_date_prefix".tr(args: [filteredNotifications[index]["date"]])),
                      onTap: () => openNotificationDetails(realIndex),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
