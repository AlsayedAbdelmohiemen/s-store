import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColors.darkGrey,
    suffixIconColor: SColors.darkGrey,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: SColors.textPrimary),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: SColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, color: SColors.error),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: SColors.borderPrimary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: SColors.borderSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1.5, color: SColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: SColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1.5, color: SColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColors.grey,
    suffixIconColor: SColors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: SColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: SColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, color: SColors.error),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: SColors.darkerGrey.withValues(alpha: 0.4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: SColors.darkerGrey.withValues(alpha: 0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1.5, color: SColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: SColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1.5, color: SColors.warning),
    ),
  );
}
