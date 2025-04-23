import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_drawer.dart';
import '../notifications/notifications_screen.dart';

class CitizenDashboard extends StatelessWidget {
  final VoidCallback toggleTheme;

  const CitizenDashboard({super.key, required this.toggleTheme});

  final List<Map<String, dynamic>> services = const [
    {"title": "تجديد رخصة قيادة", "icon": Icons.credit_card, "route": "/license_renewal"},
    {"title": "تجديد رخصة مركبة", "icon": Icons.car_repair, "route": "/vehicle_license_renewal"},
    {"title": "نقل ملكية مركبة", "icon": Icons.swap_horiz, "route": "/ownership_transfer"},
    {"title": "ترخيص مركبة", "icon": Icons.directions_car, "route": "/vehicle_registration"},
    {"title": "نتيجة فحص نظري", "icon": Icons.description, "route": "/theoretical_test_result"},
    {"title": "نتيجة فحص عملي", "icon": Icons.assignment_turned_in, "route": "/practical_test_result"},
    {"title": "تغيير لون مركبة", "icon": Icons.color_lens, "route": "/color_change"},
    {"title": "بدل فاقد رخصة قيادة", "icon": Icons.credit_card_off, "route": "/lost_license"},
    {"title": "بدل فاقد رقم مركبة", "icon": Icons.confirmation_number, "route": "/lost_plate"},
    {"title": "مخالفات مرورية", "icon": Icons.warning, "route": "/traffic_violations"},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الخدمات'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    tooltip: 'الإشعارات',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        drawer: CustomDrawer(toggleTheme: toggleTheme),
        backgroundColor: AppTheme.lightGrey,

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        services[index]["icon"],
                        size: 50,
                        color: AppTheme.navy,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        services[index]["title"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
