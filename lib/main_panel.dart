import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:traffic_department/screens/web_portal/main_website_home.dart';
import 'theme/staff_theme.dart';

void main() {
  runApp(const PanelApp());
}

class PanelApp extends StatelessWidget {
  const PanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'البوابة الرسمية - دائرة السير',
      debugShowCheckedModeBanner: false,
      theme: StaffTheme.theme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/web-home',
      routes: {
        '/web-home': (context) => const MainWebsiteHome(),
      },
    );
  }
}
