import 'package:flutter/material.dart';
import 'package:traffic_department/screens/admin/admin_activity_log_screen.dart';
import 'package:traffic_department/screens/admin/admin_complaints_suggestions_management_screen.dart';
import 'package:traffic_department/screens/admin/admin_content_management_screen.dart';
import 'package:traffic_department/screens/admin/admin_employee_evaluation_screen.dart';
import 'package:traffic_department/screens/admin/admin_employees_management_screen.dart';
import 'package:traffic_department/screens/admin/admin_monthly_report_screen.dart';
import 'package:traffic_department/screens/admin/admin_system_settings_screen.dart';
import 'package:traffic_department/screens/admin/admin_transactions_management_screen.dart';
import 'package:traffic_department/screens/admin/admin_users_management_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF283593),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'القائمة الرئيسية',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'لوحة التحكم', () {}),

          const Divider(color: Colors.white24),

          _buildDrawerItem(Icons.group, 'إدارة المستخدمين', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminUsersManagementScreen(),
              ),
            );
          }),

          _buildDrawerItem(Icons.badge, 'إدارة الموظفين', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEmployeesManagementScreen(),
              ),
            );
          }),

          _buildDrawerItem(Icons.list_alt, 'إدارة المعاملات', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminTransactionsManagementScreen(),
              ),
            );
          }),

          _buildDrawerItem(Icons.report, 'إدارة الشكاوى والمقترحات', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        const AdminComplaintsSuggestionsManagementScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.bar_chart, 'التقارير الشهرية', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminMonthlyReportScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.article, 'إدارة المحتوى', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminContentManagementScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.star_rate, 'تقييم أداء الموظفين', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEmployeeEvaluationScreen(),
              ),
            );
          }),

          _buildDrawerItem(Icons.history, 'سجل العمليات', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminActivityLogScreen(),
              ),
            );
          }),

          _buildDrawerItem(Icons.settings, 'إعدادات النظام', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminSystemSettingsScreen(),
              ),
            );
          }),

          const Divider(color: Colors.white24),

          _buildDrawerItem(Icons.school, 'نتائج الفحوصات', () {}),
          _buildDrawerItem(Icons.local_police, 'المخالفات المرورية', () {}),
          _buildDrawerItem(Icons.mail, 'صندوق الوارد', () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      hoverColor: Colors.white12,
    );
  }
}
