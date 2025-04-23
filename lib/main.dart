import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/citizen_dashboard.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'دائرة السير',
    theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,

    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ar'), 
      Locale('en'), 
    ],
    locale: const Locale('ar'), 

    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(toggleTheme: toggleTheme),
      '/login': (context) => LoginScreen(toggleTheme: toggleTheme),
      '/register': (context) => RegisterScreen(toggleTheme: toggleTheme),
      '/dashboard': (context) => CitizenDashboard(toggleTheme: toggleTheme),
    },
  );
}
}