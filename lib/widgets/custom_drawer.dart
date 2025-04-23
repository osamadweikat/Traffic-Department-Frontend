import 'package:flutter/material.dart';
import 'package:traffic_department/screens/contact/contact_us_screen.dart';
import 'package:traffic_department/screens/profile/profile_screen.dart';
import 'package:traffic_department/screens/transactions/transactions_screen.dart';
import 'package:traffic_department/screens/vehicles/vehicles_screen.dart';
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
              accountName: const Text('مرحبا، المستخدم'),
              accountEmail: const Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppTheme.yellow,
                child: const Icon(Icons.person, color: AppTheme.navy, size: 30),
              ),
            ),

            _buildListTile(
              Icons.person,
              "الملف الشخصي",
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                );
              },
            ),

            _buildListTile(
              Icons.directions_car,
              "مركباتي",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VehiclesScreen()),
                );
              },
            ),
            _buildListTile(
              Icons.contact_phone,
              "تواصل مع دائرة السير",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
            ),

            _buildListTile(Icons.support_agent, "الشكاوى والاقتراحات"),
            _buildListTile(Icons.g_translate, "تغيير اللغة"),
            _buildListTile(Icons.settings, "الإعدادات العامة"),
            _buildListTile(Icons.help, "الأسئلة الشائعة"),
            _buildListTile(Icons.info, "عن التطبيق"),
            const Divider(),
            _buildListTile(
              Icons.brightness_6,
              "تبديل الوضع الليلي",
              onTap: () {
                Navigator.pop(context);
                toggleTheme();
              },
            ),
            _buildListTile(
              Icons.logout,
              "تسجيل خروج",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title),
      onTap: onTap ?? () {},
    );
  }
}
