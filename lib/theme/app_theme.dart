import 'package:flutter/material.dart';

class AppTheme {
  static const Color navy = Color(0xFF002147);
  static const Color yellow = Color(0xFFFFC107);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: navy,
      scaffoldBackgroundColor: lightGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Cairo'),
        bodyMedium: TextStyle(fontFamily: 'Cairo'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: yellow,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Cairo'),
        bodyMedium: TextStyle(fontFamily: 'Cairo'),
      ),
    );
  }
}
