import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: AppColors.mainColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    textTheme: TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 36), //34
      titleLarge: TextStyle(fontWeight: FontWeight.w400), //20
      titleMedium: TextStyle(fontWeight: FontWeight.w400), //16
      titleSmall: TextStyle(fontWeight: FontWeight.w500), //14
      bodySmall: TextStyle(fontWeight: FontWeight.w500), //12
      bodyMedium: TextStyle(fontWeight: FontWeight.w500), //14
      bodyLarge: TextStyle(fontWeight: FontWeight.w500), //16
    ),
  );
}
