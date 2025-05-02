import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_department/screens/services/appointment_booking/appointment_booking_screen.dart';
import 'package:traffic_department/screens/services/lost_documents/lost_documents_screen.dart';
import 'package:traffic_department/screens/services/ownership_transfer/ownership_transfer_screen.dart';
import 'package:traffic_department/screens/services/test_results/test_results_screen.dart';
import 'package:traffic_department/screens/services/traffic_violations/traffic_violations_screen.dart';
import 'package:traffic_department/screens/services/vehicle_conversion/vehicle_conversion_screen.dart';
import 'package:traffic_department/screens/services/vehicle_deregistration/vehicle_deregistration_screen.dart';
import 'package:traffic_department/screens/services/vehicle_modification/vehicle_modification_screen.dart';
import 'package:traffic_department/screens/services/vehicle_mortgage_release/vehicle_mortgage_release_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_drawer.dart';
import '../notifications/notifications_screen.dart';
import '../services/license_renewal/license_renewal_screen.dart';
import '../services/vehicle_renewal/vehicle_renewal_form.dart';
import '../services/vehicle_registration/vehicle_registration_screen.dart';

class CitizenDashboard extends StatefulWidget {
  final VoidCallback toggleTheme;

  const CitizenDashboard({super.key, required this.toggleTheme});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  bool notificationsEnabled = true;

  final List<Map<String, dynamic>> services = const [
  {"title": "renew_driver_license", "icon": Icons.credit_card, "screen": LicenseRenewalScreen()},
  {"title": "renew_vehicle_license", "icon": Icons.car_repair, "screen": VehicleLicenseRenewalScreen()},
  {"title": "vehicle_registration", "icon": Icons.directions_car, "screen": VehicleRegistrationNewScreen()},
  {"title": "transfer_ownership", "icon": Icons.swap_horiz, "screen": OwnershipTransferScreen()},
  {"title": "lost_or_damaged_documents", "icon": Icons.credit_card_off, "screen": LostDocumentsScreen()},
  {"title": "test_results", "icon": Icons.assignment_turned_in, "screen": TestResultsScreen()},
  {"title": "vehicle_technical_change", "icon": Icons.engineering, "screen": VehicleModificationScreen()},
  {"title": "vehicle_conversion", "icon": Icons.cached, "screen": VehicleConversionScreen()},
  {"title": "vehicle_deregistration", "icon": Icons.car_crash, "screen": VehicleDeregistrationScreen()},
  {"title": "appointment_booking", "icon": Icons.calendar_month, "screen": AppointmentBookingScreen()},
  {"title": "vehicle_mortgage_release", "icon": Icons.lock_open, "screen": VehicleMortgageReleaseScreen()},
  {"title": "traffic_violations", "icon": Icons.warning_amber_outlined, "screen": TrafficViolationsScreen()}
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

  void _navigateToService(dynamic screen) {
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('coming_soon'.tr())),
      );
    }
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
            final service = services[index];
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
                      onTap: () => _navigateToService(service['screen']),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              service["icon"],
                              size: 50,
                              color: AppTheme.navy,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              service["title"].toString().tr(),
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
