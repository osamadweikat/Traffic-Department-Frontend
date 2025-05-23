import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawerWeb extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(bool)? onSettingsReturned;

  const CustomDrawerWeb({
    super.key,
    required this.toggleTheme,
    this.onSettingsReturned,
  });

  Future<String?> _getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Colors.white),
              accountName: const Text(
                'مرحباً بك، المستخدم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              accountEmail: FutureBuilder<String?>(
                future: _getLastLogin(),
                builder: (context, snapshot) {
                  final loginText =
                      snapshot.hasData
                          ? 'آخر دخول: ${snapshot.data}'
                          : 'جارٍ التحميل...';
                  return Text(
                    loginText,
                    style: const TextStyle(color: Colors.black54),
                  );
                },
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xFFFFC107),
                child: Icon(Icons.person, color: Color(0xFF002D5B), size: 30),
              ),
            ),

            _buildSectionHeader("الحساب"),
            _buildListTile(
              Icons.person,
              "الملف الشخصي",
              onTap: () {
              },
            ),
            _buildListTile(
              Icons.assignment,
              "المعاملات",
              onTap: () {
              },
            ),

            const Divider(),

            _buildSectionHeader("المركبات"),
            _buildListTile(Icons.directions_car, "مركباتي", onTap: () {}),

            const Divider(),

            _buildSectionHeader("الدعم والمساعدة"),
            _buildListTile(
              Icons.support_agent,
              "الشكاوى والمقترحات",
              onTap: () {},
            ),
            _buildListTile(
              Icons.question_answer,
              "الأسئلة الشائعة",
              onTap: () {},
            ),
            _buildListTile(Icons.phone_in_talk, "اتصل بنا", onTap: () {}),

            const Divider(),

            _buildSectionHeader("الإعدادات"),
            _buildListTile(
              Icons.settings,
              "الإعدادات العامة",
              onTap: () async {
                final result = await Navigator.pushNamed(context, '/settings');
                if (result == true && onSettingsReturned != null) {
                  onSettingsReturned!(true);
                }
              },
            ),

            const Divider(height: 24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "تسجيل الخروج",
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

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
      splashColor: const Color(0xFFFFC107).withOpacity(0.2),
    );
  }
}
