import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الإعدادات العامة"),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("المظهر"),
            _buildSwitchTile(
              title: "الوضع الليلي",
              value: isDarkMode,
              onChanged: (val) {
                setState(() => isDarkMode = val);
              },
            ),
            _buildNavigationTile(
              icon: Icons.language,
              title: "تغيير اللغة",
              onTap: () {
                Navigator.pushNamed(context, "/language-settings");
              },
            ),
            const Divider(),

            _buildSectionTitle("الإشعارات"),
            _buildSwitchTile(
              title: "تفعيل إشعارات المعاملات",
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
              },
            ),
            const Divider(),

            _buildSectionTitle("الحساب"),
            _buildNavigationTile(
              icon: Icons.lock_reset,
              title: "إعادة تعيين كلمة المرور",
              onTap: () {
              },
            ),
            const Divider(),

            _buildSectionTitle("عام"),
            _buildNavigationTile(
              icon: Icons.info_outline,
              title: "عن التطبيق",
              onTap: () {
              },
            ),
            _buildNavigationTile(
              icon: Icons.privacy_tip,
              title: "سياسة الخصوصية",
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required Function(bool) onChanged}) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.navy,
    );
  }

  Widget _buildNavigationTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.navy),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
