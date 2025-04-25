import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/policy/privacy_policy_screen.dart';
import 'package:traffic_department/screens/about/about_app_screen.dart';
import 'package:traffic_department/screens/auth/verify_and_change_password_screen.dart';
import 'package:traffic_department/screens/settings/language_settings_screen.dart';
import 'package:flutter/services.dart' as ui;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Directionality(
        textDirection:
            context.locale.languageCode == 'ar'
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text("general_settings_title".tr()),
            backgroundColor: AppTheme.navy,
          ),
          backgroundColor: AppTheme.lightGrey,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle("appearance".tr()),
              SwitchListTile(
                title: Text("dark_mode".tr()),
                value: isDarkMode,
                onChanged: _toggleDarkMode,
                activeColor: AppTheme.navy,
              ),
              ListTile(
                leading: const Icon(Icons.language, color: AppTheme.navy),
                title: Text("change_language".tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguageSettingsScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              _buildSectionTitle("notifications".tr()),
              SwitchListTile(
                title: Text("enable_notifications".tr()),
                value: notificationsEnabled,
                onChanged: (value) async {
                  await _toggleNotifications(value);
                },
                activeColor: AppTheme.navy,
              ),
              const Divider(),
              _buildSectionTitle("account".tr()),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: AppTheme.navy),
                title: Text("reset_password".tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerifyAndChangePasswordScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              _buildSectionTitle("general".tr()),
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppTheme.navy),
                title: Text("about_app".tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.privacy_tip, color: AppTheme.navy),
                title: Text("privacy_policy".tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
