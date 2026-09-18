import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// ----- Light & Dark Outlined Button Theme
class SOutlinedButtonTheme {
  SOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.textPrimary,
      side: const BorderSide(color: SColors.borderPrimary),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.textWhite,
      side: BorderSide(color: SColors.darkerGrey.withValues(alpha: 0.5)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SColors.textWhite),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
