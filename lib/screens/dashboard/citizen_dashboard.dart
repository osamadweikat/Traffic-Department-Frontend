import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_drawer.dart';
import '../notifications/notifications_screen.dart';
import '../services/license_renewal/license_renewal_screen.dart';
import '../services/vehicle_renewal/vehicle_renewal_form.dart'; // تم إضافة استيراد صفحة تجديد رخصة مركبة

class CitizenDashboard extends StatefulWidget {
  final VoidCallback toggleTheme;

  const CitizenDashboard({super.key, required this.toggleTheme});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  bool notificationsEnabled = true;

  final List<Map<String, dynamic>> services = const [
    {"title": "renew_driver_license", "icon": Icons.credit_card, "route": "/license_renewal"},
    {"title": "renew_vehicle_license", "icon": Icons.car_repair, "route": "/vehicle_license_renewal"},
    {"title": "transfer_ownership", "icon": Icons.swap_horiz, "route": "/ownership_transfer"},
    {"title": "vehicle_registration", "icon": Icons.directions_car, "route": "/vehicle_registration"},
    {"title": "theory_test_result", "icon": Icons.description, "route": "/theoretical_test_result"},
    {"title": "practical_test_result", "icon": Icons.assignment_turned_in, "route": "/practical_test_result"},
    {"title": "change_vehicle_color", "icon": Icons.color_lens, "route": "/color_change"},
    {"title": "lost_driver_license", "icon": Icons.credit_card_off, "route": "/lost_license"},
    {"title": "lost_vehicle_plate", "icon": Icons.confirmation_number, "route": "/lost_plate"},
    {"title": "traffic_violations", "icon": Icons.warning, "route": "/traffic_violations"},
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dashboard_title').tr(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: notificationsEnabled ? Colors.white : Colors.grey.withOpacity(0.5),
                  ),
                  tooltip: 'notifications'.tr(),
                  onPressed: notificationsEnabled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                        }
                      : null,
                ),
                if (notificationsEnabled)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                else
                  Positioned(
                    right: 4,
                    top: 6,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Icon(Icons.block, size: 16, color: Colors.grey.withOpacity(0.7)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        toggleTheme: widget.toggleTheme,
        onSettingsReturned: (bool settingsChanged) {
          if (settingsChanged) {
            _loadNotificationSettings();
          }
        },
      ),
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
            return StatefulBuilder(
              builder: (context, setState) {
                double scale = 1.0;
                return Listener(
                  onPointerDown: (_) => setState(() => scale = 0.95),
                  onPointerUp: (_) => setState(() => scale = 1.0),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LicenseRenewalScreen()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VehicleLicenseRenewalScreen()),
                          );
                        }
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                              services[index]["title"].toString().tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
