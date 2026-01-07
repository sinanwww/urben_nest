import 'package:flutter/material.dart';
import 'package:urben_nest/utls/font_style.dart';

class AppTheme {
  static const Color primary = Color(0xFFE52C4A);
  static const Color errorRed = Color(0xFFFF0000);
  static const Color neutralGray = Color(0xFF979899);
  static const Color infoBlue = Color(0xFF007FFF);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      primary: Colors.black,
      seedColor: primary,
      brightness: Brightness.light,
      error: errorRed,
      surfaceTint: neutralGray,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: Fontstyle.light(
        fontWeight: FontWeight.w500,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      // bodyMedium: const TextStyle(fontFamily: 'poppins', color: Colors.black87),
      headlineLarge: Fontstyle.light(fontWeight: FontWeight.w500, fontSize: 28),
      bodySmall: Fontstyle.light(fontWeight: FontWeight.w400, fontSize: 12),
      labelMedium: Fontstyle.light(fontWeight: FontWeight.w400, fontSize: 16),
    ),
  );

  //dark theme

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      primary: Colors.white,
      seedColor: primary,
      brightness: Brightness.dark,
      error: errorRed,
      surfaceTint: neutralGray,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: Fontstyle.dark(fontWeight: FontWeight.w500, fontSize: 17),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: Fontstyle.dark(fontWeight: FontWeight.w500, fontSize: 28),
      headlineMedium: Fontstyle.dark(fontWeight: FontWeight.w500, fontSize: 24),
      labelMedium: Fontstyle.dark(fontWeight: FontWeight.w400, fontSize: 16),

      // bodyMedium: TextStyle(fontFamily: 'poppins', color: Colors.white70),
      bodySmall: Fontstyle.dark(fontWeight: FontWeight.w400, fontSize: 12),
    ),
  );
}
