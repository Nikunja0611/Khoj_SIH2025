import 'package:flutter/material.dart';

class AppTheme {
  static const primaryGreen = Color(0xFF1B5E20);
  static const creamWhite = Color(0xFFF9F9F9);
  static const charcoalGray = Color(0xFF3A3A3A);
  static const earthOrange = Color(0xFFD97D0D);

  static final theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: creamWhite,
    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      secondary: earthOrange,
      background: creamWhite,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: charcoalGray,
      onBackground: charcoalGray,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
  elevation: 2,
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  color: Colors.white,
),

  );
}
