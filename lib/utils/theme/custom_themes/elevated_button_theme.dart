import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// ----- Light & Dark Elevated Button Theme
class SElevatedButtonTheme {
  SElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.textWhite,
      backgroundColor: SColors.primary,
      disabledBackgroundColor: SColors.buttonDisabled,
      disabledForegroundColor: SColors.darkGrey,
      side: const BorderSide(color: SColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SColors.textWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.textWhite,
      backgroundColor: SColors.primary,
      disabledBackgroundColor: SColors.buttonDisabled,
      disabledForegroundColor: SColors.darkGrey,
      side: const BorderSide(color: SColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SColors.textWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
