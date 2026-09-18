import 'package:flutter/material.dart';

class SColors {
  SColors._();

  // App Basic Colors (Modern Indigo & Gold)
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryColor = primary;
  static const Color secondary = Color(0xFFF59E0B);
  static const Color secondaryColor = secondary;
  static const Color accent = Color(0xFFEEF2FF);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    colors: [
      Color(0xFF4F46E5),
      Color(0xFF6366F1),
      Color(0xFF818CF8),
    ],
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.7, -0.7),
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textWhite = Colors.white;

  // Background colors (Clean Slate Palette)
  static const Color light = Color(0xFFF8FAFC);
  static const Color dark = Color(0xFF0F172A);
  static const Color primaryBackground = Color(0xFFF1F5F9);

  // Background Container colors
  static const Color lightContainer = Color(0xFFFFFFFF);
  static Color darkContainer = const Color(0xFF1E293B);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4F46E5);
  static const Color buttonSecondary = Color(0xFF64748B);
  static const Color buttonDisabled = Color(0xFFCBD5E1);

  // Border Colors
  static const Color borderPrimary = Color(0xFFCBD5E1);
  static const Color borderSecondary = Color(0xFFE2E8F0);

  // Error and validation
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color waring = warning; // Backwards compatibility for typo
  static const Color info = Color(0xFF06B6D4);

  // Neutral shades
  static const Color black = Color(0xFF0F172A);
  static const Color darkerGrey = Color(0xFF334155);
  static const Color darkGrey = Color(0xFF64748B);
  static const Color grey = Color(0xFF94A3B8);
  static const Color softGrey = Color(0xFFF1F5F9);
  static const Color lightGrey = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);
}
