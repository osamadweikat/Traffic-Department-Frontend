import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(8, (i) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + i * 200),
        vsync: this,
      )..forward();
    });

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy'.tr()),
        backgroundColor: AppTheme.navy,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightGrey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                : [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: List.generate(_animations.length, (index) {
            return SlideTransition(
              position: _animations[index],
              child: _buildSection(
                context,
                icon: _getIcon(index),
                title: _getTitle(index).tr(),
                content: _getContent(index).tr(),
              ),
            );
          })
          ..add(const SizedBox(height: 20))
          ..add(
            Center(
              child: Text(
                'privacy_last_updated'.tr(),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.navy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppTheme.navy, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    const icons = [
      Icons.info_outline,
      Icons.list_alt,
      Icons.settings_outlined,
      Icons.share_outlined,
      Icons.lock_outline,
      Icons.calendar_today_outlined,
      Icons.verified_user_outlined,
      Icons.email_outlined,
    ];
    return icons[index % icons.length];
  }

  String _getTitle(int index) {
    const titles = [
      'privacy_intro_title',
      'privacy_data_title',
      'privacy_usage_title',
      'privacy_share_title',
      'privacy_protection_title',
      'privacy_retention_title',
      'privacy_rights_title',
      'privacy_contact_title'
    ];
    return titles[index % titles.length];
  }

  String _getContent(int index) {
    const contents = [
      'privacy_intro_text',
      'privacy_data_text',
      'privacy_usage_text',
      'privacy_share_text',
      'privacy_protection_text',
      'privacy_retention_text',
      'privacy_rights_text',
      'privacy_contact_text'
    ];
    return contents[index % contents.length];
  }
}
