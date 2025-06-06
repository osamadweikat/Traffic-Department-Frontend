import 'package:flutter/material.dart';
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

          _buildDrawerItem(Icons.badge, 'إدارة الموظفين', () {}),
          _buildDrawerItem(Icons.assignment, 'إدارة المعاملات', () {}),
          _buildDrawerItem(Icons.report, 'إدارة الشكاوى والمقترحات', () {}),
          _buildDrawerItem(Icons.bar_chart, 'التقارير الشهرية', () {}),
          _buildDrawerItem(Icons.article, 'إدارة المحتوى', () {}),
          _buildDrawerItem(Icons.star_rate, 'تقييم الأداء', () {}),
          _buildDrawerItem(Icons.history, 'سجل العمليات', () {}),
          _buildDrawerItem(Icons.settings, 'إعدادات النظام', () {}),

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
