import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' as ui;
import '../../theme/app_theme.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  Future<void> _changeLanguage(BuildContext context, String languageCode) async {
    final locale = Locale(languageCode);
    await context.setLocale(locale);

    // Optional: Save language manually (although `easy_localization` does it if `saveLocale` is true)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    String currentLangCode = context.locale.languageCode;

    return Directionality(
      textDirection:
          currentLangCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text("change_language".tr()),
          backgroundColor: AppTheme.navy,
          centerTitle: true,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: ListView(
          children: [
            RadioListTile<String>(
              title: Text("language_ar".tr()),
              value: 'ar',
              groupValue: currentLangCode,
              onChanged: (value) => _changeLanguage(context, value!),
            ),
            RadioListTile<String>(
              title: Text("language_en".tr()),
              value: 'en',
              groupValue: currentLangCode,
              onChanged: (value) => _changeLanguage(context, value!),
            ),
          ],
        ),
      ),
    );
  }
}
