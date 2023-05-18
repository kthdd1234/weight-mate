import 'package:flutter/material.dart';

class AppColors {
  static const int _primaryColorValue = 0xFF40465E;
  static const int _primarySwatchLight = 0xFFFFFFFF;
  static const int _primarySwatchDark = 0xFF40465E;
  static const primaryColor = Color(_primaryColorValue);
  static const primarySwatchLight = Color(_primarySwatchLight);
  static const primarySwatchDark = Color(_primarySwatchDark);

  static const MaterialColor primaryMaterialColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(_primaryColorValue),
      100: Color(_primaryColorValue),
      200: Color(_primaryColorValue),
      300: Color(_primaryColorValue),
      400: Color(_primaryColorValue),
      500: Color(_primaryColorValue),
      600: Color(_primaryColorValue),
      700: Color(_primaryColorValue),
      800: Color(_primaryColorValue),
      900: Color(_primaryColorValue),
    },
  );

  static const MaterialColor primaryMaterialSwatchLight = MaterialColor(
    _primarySwatchLight,
    <int, Color>{
      50: Color(_primarySwatchLight),
      100: Color(_primarySwatchLight),
      200: Color(_primarySwatchLight),
      300: Color(_primarySwatchLight),
      400: Color(_primarySwatchLight),
      500: Color(_primarySwatchLight),
      600: Color(_primarySwatchLight),
      700: Color(_primarySwatchLight),
      800: Color(_primarySwatchLight),
      900: Color(_primarySwatchLight),
    },
  );

  static const MaterialColor primaryMaterialSwatchDark = MaterialColor(
    _primarySwatchDark,
    <int, Color>{
      50: Color(_primarySwatchDark),
      100: Color(_primarySwatchDark),
      200: Color(_primarySwatchDark),
      300: Color(_primarySwatchDark),
      400: Color(_primarySwatchDark),
      500: Color(_primarySwatchDark),
      600: Color(_primarySwatchDark),
      700: Color(_primarySwatchDark),
      800: Color(_primarySwatchDark),
      900: Color(_primarySwatchDark),
    },
  );
}
