import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/theme/app_theme.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const GeneralSettingsScreen({super.key, required this.toggleTheme});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isDarkMode = value);
    await prefs.setBool('isDarkMode', value);
    widget.toggleTheme();
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => notificationsEnabled = value);
    await prefs.setBool('notificationsEnabled', value);
  }

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
            SwitchListTile(
              title: const Text("الوضع الليلي"),
              value: isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: AppTheme.navy,
            ),
            ListTile(
              leading: const Icon(Icons.language, color: AppTheme.navy),
              title: const Text("تغيير اللغة"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, "/language-settings");
              },
            ),
            const Divider(),
            _buildSectionTitle("الإشعارات"),
            SwitchListTile(
              title: const Text("تفعيل إشعارات المعاملات"),
              value: notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: AppTheme.navy,
            ),
            const Divider(),
            _buildSectionTitle("الحساب"),
            ListTile(
              leading: const Icon(Icons.lock_reset, color: AppTheme.navy),
              title: const Text("إعادة تعيين كلمة المرور"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // صفحة إعادة تعيين كلمة المرور
              },
            ),
            const Divider(),
            _buildSectionTitle("عام"),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppTheme.navy),
              title: const Text("عن التطبيق"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // صفحة عن التطبيق
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: AppTheme.navy),
              title: const Text("سياسة الخصوصية"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // صفحة سياسة الخصوصية
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
}
