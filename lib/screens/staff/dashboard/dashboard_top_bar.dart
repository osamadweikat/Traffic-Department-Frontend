import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onNotificationsPressed;

  const DashboardTopBar({
    super.key,
    required this.unreadCount,
    required this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF1E3A5F)),
                onPressed: onNotificationsPressed,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}