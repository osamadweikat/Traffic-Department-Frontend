import 'package:flutter/material.dart';
import 'notification_details_web.dart';

class NotificationsWeb extends StatefulWidget {
  const NotificationsWeb({super.key});

  @override
  State<NotificationsWeb> createState() => _NotificationsWebState();
}

class _NotificationsWebState extends State<NotificationsWeb> {
  List<Map<String, dynamic>> notifications = [
    {
      "title": "تم قبول طلب تجديد رخصة القيادة",
      "date": "2025-03-31",
      "isRead": false,
      "details": "تفاصيل قبول طلب تجديد الرخصة",
    },
    {
      "title": "تم رفض طلب نقل ملكية مركبة",
      "date": "2025-03-30",
      "isRead": true,
      "details": "تفاصيل رفض نقل الملكية",
    },
    {
      "title": "تم إصدار مخالفة جديدة على المركبة",
      "date": "2025-03-29",
      "isRead": false,
      "details": "تفاصيل المخالفة الجديدة",
    },
    {
      "title": "موعد فحص عملي قادم غداً",
      "date": "2025-03-28",
      "isRead": true,
      "details": "تفاصيل موعد الفحص العملي",
    },
  ];

  String filter = 'الكل';

  List<Map<String, dynamic>> get filteredNotifications {
    if (filter == 'غير المقروءة') {
      return notifications.where((n) => !n["isRead"]).toList();
    } else if (filter == 'المقروءة') {
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
  }

  void deleteAll() {
    setState(() {
      notifications.clear();
    });
  }

  void openNotificationDetails(int index) {
    markAsRead(index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => NotificationDetailsWeb(
              title: notifications[index]["title"],
              date: notifications[index]["date"],
              details: notifications[index]["details"],
            ),
      ),
    );
  }

  void showFilterMenu() async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items:
          ['الكل', 'غير المقروءة', 'المقروءة']
              .map(
                (value) => PopupMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight:
                          filter == value ? FontWeight.bold : FontWeight.normal,
                      color: filter == value ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
    );

    if (selected != null) {
      setState(() {
        filter = selected;
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
          title: const Text(
            'الإشعارات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF002D5B),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              onPressed: notifications.isEmpty ? null : deleteAll,
              tooltip: 'حذف الكل',
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: showFilterMenu,
              tooltip: 'تصفية الإشعارات',
            ),
          ],
        ),
        body:
            filteredNotifications.isEmpty
                ? const Center(child: Text("لا توجد إشعارات حالياً"))
                : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: filteredNotifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    int realIndex = notifications.indexOf(
                      filteredNotifications[index],
                    );
                    bool isNew = !filteredNotifications[index]["isRead"];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => deleteNotification(realIndex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isNew ? const Color(0xFFFFF8E1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications_none,
                            color: Colors.grey,
                            size: 30,
                          ),
                          title: Text(
                            filteredNotifications[index]["title"],
                            style: TextStyle(
                              fontWeight:
                                  isNew ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            "تاريخ الإشعار: ${filteredNotifications[index]["date"]}",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => NotificationDetailsWeb(
                                      title:
                                          filteredNotifications[index]["title"],
                                      date:
                                          filteredNotifications[index]["date"],
                                      details:
                                          filteredNotifications[index]["details"],
                                    ),
                              ),
                            );
                            markAsRead(realIndex);
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
