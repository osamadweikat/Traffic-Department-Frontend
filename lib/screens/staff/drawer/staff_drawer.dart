import 'package:flutter/material.dart';
import 'package:traffic_department/screens/web_portal/main_website_home.dart';

class StaffDrawer extends StatelessWidget {
  final String currentPage;
  final Function(String key) onPageChange;

  const StaffDrawer({
    super.key,
    required this.currentPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF102542),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 38, color: Color(0xFF1A2F4A)),
              ),
              const SizedBox(height: 10),
              const Text(
                'أحمد يوسف',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'قسم الترخيص',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Text(
                'رقم الموظف: 388253',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const Divider(color: Colors.white24, thickness: 0.6, height: 30),
            ],
          ),

          Column(
            children: [
              _buildItem(
                context,
                Icons.account_box_outlined,
                'بوابة الموظف',
                'home',
              ),
              _buildItem(
                context,
                Icons.move_to_inbox,
                'المعاملات المستلمة',
                'assigned',
              ),
              _buildItem(
                context,
                Icons.pending_actions,
                'معاملات قيد الإنجاز',
                'in_progress',
              ),
              _buildItem(
                context,
                Icons.task_alt_rounded,
                'المعاملات المنجزة',
                'completed',
              ),
              _buildItem(
                context,
                Icons.cancel_outlined,
                'المعاملات المرفوضة',
                'rejected',
              ),
              _buildItem(
                context,
                Icons.swap_horiz_rounded,
                'المعاملات المحولة',
                'transfer',
              ),
              _buildItem(
                context,
                Icons.email_outlined,
                'مراسلة الإدارة',
                'contact',
              ),
              _buildItem(
                context,
                Icons.lock_reset_rounded,
                'تغيير كلمة المرور',
                'change_password',
              ),
            ],
          ),

          Column(
            children: [
              const Divider(color: Colors.white24, thickness: 0.5),
              _buildItem(
                context,
                Icons.logout_rounded,
                'تسجيل الخروج',
                'logout',
                isLogout: true,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String label,
    String key, {
    bool isLogout = false,
  }) {
    final bool isActive = currentPage == key && !isLogout;

    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white10 : Colors.transparent,
        border:
            isActive
                ? const Border(
                  right: BorderSide(color: Color(0xFFFFC107), width: 4),
                )
                : null,
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
        onTap: () {
          if (!isLogout) {
            onPageChange(key);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainWebsiteHome()),
            );
          }
        },
      ),
    );
  }
}
