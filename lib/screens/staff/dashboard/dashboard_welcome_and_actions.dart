import 'package:flutter/material.dart';
import 'package:traffic_department/screens/staff/tasks/activity_log_screen.dart';
import 'package:traffic_department/screens/staff/tasks/confirm_user_screen.dart';
import 'package:traffic_department/screens/staff/tasks/smart_search_screen.dart';
import 'package:traffic_department/screens/staff/tasks/staff_messages/message_inbox_screen.dart';
import 'package:traffic_department/screens/staff/tasks/track_complaints_screen.dart';

class DashboardWelcomeAndActions extends StatelessWidget {
  const DashboardWelcomeAndActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeBanner(),
        const SizedBox(height: 16),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0ECF8), Color(0xFFD4E1F1)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A5F),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'مرحبًا بك في منصتك الوظيفية. حضورك هو بداية الإنجاز، ودورك محور في خدمة الوطن والمواطن.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A5F),
                height: 1.6,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final actions = [
      {
        'icon': Icons.verified_user_rounded,
        'label': 'تأكيد حساب مستخدم',
        'color': Colors.green.shade700,
        'onTap':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConfirmUserScreen()),
            ),
      },
      {
        'icon': Icons.report_gmailerrorred_rounded,
        'label': 'متابعة الشكاوى',
        'color': Colors.deepOrange,
        'onTap':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrackComplaintsScreen()),
            ),
      },
      {
        'icon': Icons.chat_bubble_outline,
        'label': 'مراسلة موظف',
        'color': Colors.teal.shade600,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MessageInboxScreen()),
          );
        },
      },
      {
        'icon': Icons.manage_search_rounded,
        'label': 'البحث في النظام',
        'color': Colors.indigo.shade600,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SmartSearchScreen()),
          );
        },
      },
      {
        'icon': Icons.history_rounded,
        'label': 'سجل النشاطات',
        'color': Color(0xFF837060),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityLogScreen()),
          );
        },
      },
      {
        'icon': Icons.insert_chart_outlined,
        'label': 'تقريري الشهري',
        'color': Colors.blueGrey.shade700,
        'onTap': () {},
      },
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children:
          actions.map((action) {
            return ElevatedButton.icon(
              onPressed: () => (action['onTap'] as VoidCallback)(),
              icon: Icon(action['icon'] as IconData, size: 20),
              label: Text(action['label'] as String),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                backgroundColor: action['color'] as Color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }).toList(),
    );
  }
}
