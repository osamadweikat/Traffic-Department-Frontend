import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:traffic_department/screens/staff/auth/inspection_portal_screen.dart';
import 'package:traffic_department/screens/staff/auth/traffic_police_portal_screen.dart';
import 'package:traffic_department/screens/staff/tasks/transactions/received_transactions_screen.dart';
import 'package:traffic_department/screens/web_portal/citizen_dashboard_web.dart';
import 'package:traffic_department/screens/web_portal/complaint_form_screen.dart';
import 'package:traffic_department/screens/web_portal/contact_screen.dart';
import 'package:traffic_department/screens/web_portal/inspection_results_entry_screen.dart';
import 'package:traffic_department/screens/web_portal/login_screen_web.dart';
import 'package:traffic_department/screens/web_portal/main_website_home.dart';
import 'package:traffic_department/screens/web_portal/news_screen.dart';
import 'package:traffic_department/screens/web_portal/news_details_screen.dart';
import 'package:traffic_department/screens/staff/auth/staff_portal_screen.dart';
import 'package:traffic_department/screens/web_portal/notifications_web.dart';
import 'package:traffic_department/screens/web_portal/portal_rating_screen.dart';
import 'package:traffic_department/screens/web_portal/register_screen_web.dart';
import 'package:traffic_department/screens/web_portal/suggestions_screen.dart';
import 'package:traffic_department/screens/web_portal/test_results_screen_web.dart';
import 'package:traffic_department/screens/web_portal/traffic_violations_screen_web.dart';
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
        '/suggestions': (context) => const SuggestionsScreen(),
        '/rate-portal': (context) => const PortalRatingScreen(),
        '/contact': (context) => const ContactScreen(),
        '/assigned': (context) => const ReceivedTransactionsScreen(),
        '/test-results': (context) => const TestResultsScreenWeb(),
        '/traffic-violations': (context) => const TrafficViolationsScreenWeb(),
        '/login': (context) => const LoginScreenWeb(),
        '/register': (context) => const RegisterScreenWeb(),
        '/citizen-dashboard': (context) => const CitizenDashboardWeb(),
        '/notifications': (context) => const NotificationsWeb(),
        '/inspection_portal': (context) => const InspectionPortalScreen(),
        '/inspection_results':(context) => const InspectionResultsEntryScreen(),
        '/traffic_police_portal': (context) => const TrafficPolicePortalScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/news-details') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder:
                (context) => NewsDetailsScreen(
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
