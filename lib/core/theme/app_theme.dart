import 'package:flutter/material.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorSchemeSeed: Colors.deepPurple,
    useMaterial3: true,
    typography: Typography.material2021(),
    textTheme: const TextTheme(
      titleLarge: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
    ),
  );
}