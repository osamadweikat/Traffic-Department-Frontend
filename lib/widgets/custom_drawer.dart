import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/contact/contact_us_screen.dart';
import 'package:traffic_department/screens/citizen/profile/profile_screen.dart';
import 'package:traffic_department/screens/citizen/transactions/transactions_screen.dart';
import 'package:traffic_department/screens/citizen/vehicles/vehicles_screen.dart';
import 'package:traffic_department/screens/citizen/complaints/complaints_suggestions_screen.dart';
import 'package:traffic_department/screens/citizen/settings/general_settings_screen.dart';
import 'package:traffic_department/screens/citizen/faq/faq_screen.dart';
import 'package:flutter/services.dart' as ui;
import '../theme/app_theme.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(bool)? onSettingsReturned;

  const CustomDrawer({
    super.key,
    required this.toggleTheme,
    this.onSettingsReturned,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: AppTheme.navy),
              accountName: Text('drawer_welcome_user'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('drawer_active_last_login'.tr()),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppTheme.yellow,
                child: Icon(Icons.person, color: AppTheme.navy, size: 30),
              ),
            ),

            _buildSectionHeader("drawer_account".tr()),
            _buildListTile(Icons.person, "drawer_profile".tr(), iconColor: AppTheme.navy, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(
                    fullName: "محمد أحمد خالد علي",
                    nationalId: "1234567890",
                    birthDate: "1999-01-01",
                  ),
                ),
              );
            }),
            _buildListTile(Icons.assignment, "drawer_transactions".tr(), iconColor: Colors.brown.shade700, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionsScreen()));
            }),

            const Divider(),

            _buildSectionHeader("drawer_vehicles".tr()),
            _buildListTile(Icons.directions_car, "drawer_my_vehicles".tr(), iconColor: Colors.indigo, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VehiclesScreen()));
            }),

            const Divider(),

            _buildSectionHeader("drawer_help".tr()),
            _buildListTile(Icons.support_agent, "drawer_complaints".tr(), iconColor: Colors.green, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintsSuggestionsScreen()));
            }),
            _buildListTile(Icons.question_answer, "drawer_faq".tr(), iconColor: Colors.blueGrey, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FAQScreen()));
            }),
            _buildListTile(Icons.phone_in_talk, "drawer_contact".tr(), iconColor: Colors.teal, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
            }),

            const Divider(),

            _buildSectionHeader("drawer_settings".tr()),
            _buildListTile(Icons.settings, "drawer_general_settings".tr(), iconColor: Colors.deepPurple, onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GeneralSettingsScreen(toggleTheme: toggleTheme),
                ),
              );
              if (result == true && onSettingsReturned != null) {
                onSettingsReturned!(true); 
              }
            }),

            const Divider(height: 24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text("drawer_logout".tr(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
      splashColor: AppTheme.yellow.withOpacity(0.2),
    );
  }
}
