import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:traffic_department/screens/web_portal/complaint_form_screen.dart';
import 'package:traffic_department/screens/web_portal/main_website_home.dart';
import 'package:traffic_department/screens/web_portal/news_screen.dart';
import 'package:traffic_department/screens/web_portal/news_details_screen.dart';
import 'package:traffic_department/screens/staff/staff_portal_screen.dart';
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
        '/': (context) => const MainWebsiteHome(),
        '/web-home': (context) => const MainWebsiteHome(),
        '/staff-portal': (context) => const StaffPortalScreen(),
        '/news': (context) => const NewsScreen(),
        '/complaints': (context) => const ComplaintFormScreen(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/news-details') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => NewsDetailsScreen(
              title: args['title'] ?? '',
              date: args['date'] ?? '',
              time: args['time'] ?? '',
              content: args['content'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}
