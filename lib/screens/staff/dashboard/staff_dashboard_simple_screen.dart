import 'package:flutter/material.dart';
import 'package:traffic_department/data/notifications_data.dart';
import 'package:traffic_department/data/received_transactions.dart';
import 'package:traffic_department/screens/staff/dashboard/dashboard_welcome_and_actions.dart';
import 'package:traffic_department/screens/staff/drawer/staff_drawer.dart';
import 'package:traffic_department/screens/staff/notifications/notifications_screen.dart';
import 'package:traffic_department/screens/staff/tasks/change_password_in_screen.dart';
import 'package:traffic_department/screens/staff/tasks/contact_admin_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/completed_transactions_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/in_progress_transactions_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/received_transactions_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/rejected_transactions_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/transferred_transactions_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class StaffDashboardSimpleScreen extends StatefulWidget {
  const StaffDashboardSimpleScreen({super.key});

  @override
  State<StaffDashboardSimpleScreen> createState() => _StaffDashboardSimpleScreenState();
}

class _StaffDashboardSimpleScreenState extends State<StaffDashboardSimpleScreen>
    with RouteAware {
  late List<Map<String, dynamic>> localNotifications;
  String currentPage = 'home';

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
          StaffDrawer(
            currentPage: currentPage,
            onPageChange: (key) {
              setState(() {
                currentPage = key;
              });
            },
          ),
          Expanded(child: _buildPageContent()),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (currentPage) {
      case 'assigned':
        return const ReceivedTransactionsScreen();

      case 'home':
        return Column(
          children: [
            Container(
              height: 60,
              color: const Color(0xFFE8EDF3),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset('assets/images/traffic_logo.png', width: 36, height: 36),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'دائرة السير الفلسطينية',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'بوابة الموظفين',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E3A5F)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Color(0xFF1E3A5F)),
                    onPressed: () async {
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
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    DashboardWelcomeAndActions(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );

      case 'in_progress':
        return InProgressTransactionsScreen(
          inProgressTransactions: receivedTransactions.take(5).toList(),
        );

      case 'completed':
        return const CompletedTransactionsScreen();

      case 'rejected':
        return const RejectedTransactionsScreen();

      case 'transfer':
        return const TransferredTransactionsScreen();

      case 'contact':
        return const ContactAdminScreen();

      case 'change_password':
        return const ChangePasswordinScreen();

      default:
        return const Center(child: Text('الصفحة غير موجودة'));
    }
  }
}
