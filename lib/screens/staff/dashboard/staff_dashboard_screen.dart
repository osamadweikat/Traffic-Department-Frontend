import 'package:flutter/material.dart';
import 'package:traffic_department/data/notifications_data.dart';
import 'package:traffic_department/screens/staff/dashboard/dashboard_messages_and_stats.dart';
import 'package:traffic_department/screens/staff/dashboard/dashboard_top_bar.dart';
import 'package:traffic_department/screens/staff/dashboard/dashboard_welcome_and_actions.dart';
import 'package:traffic_department/screens/staff/drawer/staff_drawer.dart';
import 'package:traffic_department/screens/staff/notifications/notifications_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/received_transactions_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> with RouteAware {
  late List<Map<String, dynamic>> localNotifications;
  String currentPage = 'home'; // ✅ المتغير اللي بنغيره عند الضغط

  @override
  void initState() {
    super.initState();
    localNotifications = [...notifications];
  }

  int get unreadCount =>
      localNotifications.where((n) => n['isUnread'] == true).length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      localNotifications = [...notifications];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Row(
        children: [
          // ✅ نمرر currentPage و onPageChange
          StaffDrawer(
            currentPage: currentPage,
            onPageChange: (key) {
              setState(() {
                currentPage = key;
              });
            },
          ),
          Expanded(
            child: _buildPageContent(),
          ),
        ],
      ),
    );
  }

  /// ✅ نحدد أي صفحة نعرض حسب currentPage
  Widget _buildPageContent() {
    switch (currentPage) {
      case 'assigned':
        return const ReceivedTransactionsScreen();
      case 'home':
        return Column(
          children: [
            DashboardTopBar(
              unreadCount: unreadCount,
              onNotificationsPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(
                      notifications: localNotifications,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    DashboardWelcomeAndActions(),
                    SizedBox(height: 24),
                    DashboardMessagesAndStats(),
                  ],
                ),
              ),
            ),
          ],
        );

      // ممكن تضيف هنا باقي الشاشات الأخرى مثل:
      // case 'in_progress': return InProgressScreen();
      // case 'completed': return CompletedScreen();

      default:
        return const Center(child: Text('الصفحة غير موجودة'));
    }
  }
}
