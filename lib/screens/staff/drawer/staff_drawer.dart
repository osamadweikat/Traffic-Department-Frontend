import 'package:flutter/material.dart';
class StaffDrawer extends StatelessWidget {
  final String currentPage;
  const StaffDrawer({super.key, required this.currentPage});

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
              _buildItem(Icons.account_box_outlined, 'بوابة الموظف', 'home'),
              _buildItem(Icons.move_to_inbox, 'المعاملات المستلمة', 'assigned'),
              _buildItem(
                Icons.pending_actions,
                'معاملات قيد الإنجاز',
                'in_progress',
              ),
              _buildItem(
                Icons.task_alt_rounded,
                'المعاملات المنجزة',
                'completed',
              ),
              _buildItem(
                Icons.swap_horiz_rounded,
                'المعاملات المحولة',
                'transfer',
              ),

              _buildItem(
                Icons.email_outlined,
                'مراسلة الإدارة',
                'contact',
              ), 
              _buildItem(
                Icons.support_agent,
                'طلب دعم فني',
                'report',
              ), 
              _buildItem(
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
          // TODO: handle navigation
        },
      ),
    );
  }
}
