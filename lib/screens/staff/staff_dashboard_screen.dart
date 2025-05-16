import 'package:flutter/material.dart';
import 'package:traffic_department/screens/staff/staff_drawer.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  int notificationCount = 3;
  final String currentPage = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Row(
        children: [
          const StaffDrawer(currentPage: 'home'),

          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeBanner(),
                        const SizedBox(height: 20),
                        _buildStatsRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
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
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'بوابة الموظفين',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E3A5F)),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF1E3A5F)),
                onPressed: () {
                  setState(() {
                    notificationCount = 0;
                  });
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:
                        const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Text(
        '👋 مساء النور، أحمد!',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        _buildStatCard(Icons.assignment, 'الطلبات الجديدة', '12'),
        _buildStatCard(Icons.done_all, 'الطلبات المكتملة', '28'),
        _buildStatCard(Icons.warning_amber, 'الشكاوى المعينة', '3'),
        _buildStatCard(Icons.timer, 'متوسط المعالجة', '1.3 يوم'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Color(0xFF1E3A5F)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
