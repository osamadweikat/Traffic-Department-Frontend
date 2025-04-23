import 'package:flutter/material.dart';
import 'package:traffic_department/screens/contact/contact_us_screen.dart';
import 'package:traffic_department/screens/profile/profile_screen.dart';
import 'package:traffic_department/screens/transactions/transactions_screen.dart';
import 'package:traffic_department/screens/vehicles/vehicles_screen.dart';
import 'package:traffic_department/screens/complaints/complaints_suggestions_screen.dart';
import 'package:traffic_department/screens/settings/general_settings_screen.dart';
import 'package:traffic_department/screens/faq/faq_screen.dart';

import '../theme/app_theme.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback toggleTheme;

  const CustomDrawer({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: AppTheme.navy),
              accountName: const Text(
                'مرحبا، المستخدم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('مفعل - آخر دخول: قبل دقيقة'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppTheme.yellow,
                child: const Icon(Icons.person, color: AppTheme.navy, size: 30),
              ),
            ),

            _buildSectionHeader("الحساب"),
            _buildListTile(
              Icons.person,
              "الملف الشخصي",
              iconColor: AppTheme.navy,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const ProfileScreen(
                          fullName: "محمد أحمد خالد علي",
                          nationalId: "1234567890",
                          birthDate: "1999-01-01",
                        ),
                  ),
                );
              },
            ),
            _buildListTile(
              Icons.assignment,
              "معاملاتي",
              iconColor: Colors.brown.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                );
              },
            ),

            const Divider(),

            _buildSectionHeader("المركبات"),
            _buildListTile(
              Icons.directions_car,
              "مركباتي",
              iconColor: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VehiclesScreen()),
                );
              },
            ),

            const Divider(),

            _buildSectionHeader("المساعدة"),
            _buildListTile(
              Icons.support_agent,
              "الشكاوى والاقتراحات",
              iconColor: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ComplaintsSuggestionsScreen(),
                  ),
                );
              },
            ),
            _buildListTile(
              Icons.question_answer,
              "الأسئلة الشائعة",
              iconColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FAQScreen()),
                );
              },
            ),

            _buildListTile(
              Icons.phone_in_talk,
              "تواصل مع دائرة السير",
              iconColor: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
            ),

            const Divider(),

            _buildSectionHeader("الإعدادات"),
            _buildListTile(
              Icons.settings,
              "الإعدادات العامة",
              iconColor: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GeneralSettingsScreen(),
                  ),
                );
              },
            ),

            const Divider(height: 24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "تسجيل خروج",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
      splashColor: AppTheme.yellow.withOpacity(0.2),
    );
  }
}
