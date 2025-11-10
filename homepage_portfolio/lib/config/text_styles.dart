import 'package:flutter/material.dart';

class AppTextStyles {
  // Theme-based text styles
  static TextStyle get headlineLarge => const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle get titleMedium =>
      const TextStyle(fontSize: 20, color: Colors.black87);

  static TextStyle get bodyMedium =>
      const TextStyle(fontSize: 16, color: Colors.black54);

  // Button text style
  static TextStyle get buttonText =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  // Footer text styles
  static const TextStyle footerText = TextStyle(
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
    fontSize: 14,
  );

  static const TextStyle footerBodyText = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );
}
