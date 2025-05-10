import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/notifications/notification_details_screen.dart';
import 'package:flutter/services.dart' as ui;
import '../../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      "title_ar": "تم قبول طلب تجديد رخصة القيادة",
      "title_en": "Driving license renewal request approved",
      "date": "2025-03-31",
      "isRead": false,
      "details": "تفاصيل قبول طلب تجديد الرخصة"
    },
    {
      "title_ar": "تم رفض طلب نقل ملكية مركبة",
      "title_en": "Vehicle ownership transfer request rejected",
      "date": "2025-03-30",
      "isRead": true,
      "details": "تفاصيل رفض نقل الملكية"
    },
    {
      "title_ar": "تم إصدار مخالفة جديدة على المركبة",
      "title_en": "New violation issued on the vehicle",
      "date": "2025-03-29",
      "isRead": false,
      "details": "تفاصيل المخالفة الجديدة"
    },
    {
      "title_ar": "موعد فحص عملي قادم غداً",
      "title_en": "Practical test scheduled for tomorrow",
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
          title: getLocalizedTitle(notifications[index]),
          date: notifications[index]["date"],
          details: notifications[index]["details"],
        ),
      ),
    );
  }

  String getLocalizedTitle(Map<String, dynamic> item) {
    return context.locale.languageCode == 'ar'
        ? item["title_ar"]
        : item["title_en"];
  }

  void showCustomMenu() async {
    final isArabic = context.locale.languageCode == 'ar';

    final selected = await showMenu<String>(
      context: context,
      position: isArabic
          ? const RelativeRect.fromLTRB(0, 80, 16, 0) 
          : const RelativeRect.fromLTRB(1000, 80, 0, 0), 
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
    final isArabic = context.locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
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
                          getLocalizedTitle(filteredNotifications[index]),
                          style: TextStyle(
                            fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          "notification_date_prefix".tr(args: [filteredNotifications[index]["date"]]),
                        ),
                        onTap: () => openNotificationDetails(realIndex),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
