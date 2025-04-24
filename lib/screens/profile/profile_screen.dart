import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_department/screens/profile/edit_contact_screen.dart';
import 'package:flutter/services.dart' as ui;
import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.fullName,
    required this.nationalId,
    required this.birthDate,
    this.email,
    this.phone,
    this.address,
  });

  final String fullName;
  final String nationalId;
  final String birthDate;
  final String? email;
  final String? phone;
  final String? address;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String lastLogin = "not_available".tr();

  @override
  void initState() {
    super.initState();
    loadLastLogin();
  }

  Future<void> loadLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastLogin = prefs.getString('last_login') ?? "not_available".tr();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool missingContact = (widget.email == null || widget.email!.isEmpty) ||
        (widget.phone == null || widget.phone!.isEmpty);

    return Directionality(
      textDirection:
          context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("profile_title").tr(),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.yellow,
                child: const Icon(Icons.person, size: 50, color: AppTheme.navy),
              ),
              const SizedBox(height: 16),
              if (missingContact)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: const Text("profile_missing_contact").tr(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              buildInfoRow("profile_name".tr(), widget.fullName),
              buildInfoRow("profile_id".tr(), widget.nationalId),
              buildInfoRow("profile_birthdate".tr(), widget.birthDate),
              buildInfoRow("profile_email".tr(), widget.email ?? "not_registered".tr()),
              buildInfoRow("profile_phone".tr(), widget.phone ?? "not_registered".tr()),
              buildInfoRow("profile_address".tr(), widget.address ?? "not_specified".tr()),
              const SizedBox(height: 10),
              Text("profile_last_login".tr(args: [lastLogin]),
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditContactScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellow,
                  foregroundColor: AppTheme.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("profile_edit_contact").tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Column(
      children: [
        ListTile(
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value),
        ),
        const Divider(),
      ],
    );
  }
}
