import 'package:flutter/material.dart';

class AppTheme {
  // Custom colors
  static const Color softBeige = Color(0xFFFddebf); // #fddebf
  static const Color earthyBrown = Color(0xFFcd9158); // #cd9158
  static const Color charcoalGray = Color(0xFF3A3A3A);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: softBeige,
    colorScheme: ColorScheme.light(
      primary: earthyBrown,
      secondary: earthyBrown,
      background: softBeige,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: charcoalGray,
      onBackground: charcoalGray,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: earthyBrown,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
  elevation: 3,
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  color: Colors.white,
),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: earthyBrown,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: earthyBrown,
      foregroundColor: Colors.white,
    ),
  );
}
