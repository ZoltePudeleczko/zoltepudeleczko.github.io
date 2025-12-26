import 'package:flutter/material.dart';

class AppTextStyles {
  // Theme-based text styles
  static TextStyle headlineLarge(bool isDark) => TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: isDark ? Colors.white : Colors.black,
  );

  static TextStyle titleMedium(bool isDark) => TextStyle(
    fontSize: 20,
    color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
  );

  static TextStyle bodyMedium(bool isDark) => TextStyle(
    fontSize: 16,
    color: isDark ? Colors.white70 : Colors.black54,
  );

  // Button text style
  static TextStyle get buttonText =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  // Footer text styles
  static TextStyle footerText(bool isDark) => TextStyle(
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
    fontSize: 14,
  );

  static TextStyle footerBodyText(bool isDark) => TextStyle(
    fontSize: 14,
    color: isDark ? Colors.white70 : Colors.black54,
  );
}
