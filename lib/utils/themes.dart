import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/colors.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
        primarySwatch: AppColors.primaryMaterialSwatchDark,
        fontFamily: 'cafe24Ohsquareair',
        textTheme: _textTheme,
        splashColor: Colors.white,
        brightness: Brightness.light,
      );
  static ThemeData get darkTheme => ThemeData(
        primarySwatch: AppColors.primaryMaterialSwatchLight,
        fontFamily: 'cafe24Ohsquareair',
        textTheme: _textTheme,
        splashColor: Colors.white,
        brightness: Brightness.dark,
      );

  static const TextTheme _textTheme = TextTheme(
    // <-------- headline ----------> //
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),

    // <-------- title ----------> //
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),

    // <-------- label ----------> //
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),

    // <-------- body ----------> //
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
