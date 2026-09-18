import 'package:flutter/material.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:s_store/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:s_store/utils/theme/custom_themes/chip_theme.dart';
import 'package:s_store/utils/theme/custom_themes/outlined_botton_theme.dart';
import 'package:s_store/utils/theme/custom_themes/text_field_theme.dart';
import 'package:s_store/utils/theme/custom_themes/text_theme.dart';

import 'custom_themes/appbar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';

class SAppTheme {
  SAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: SColors.primary,
    scaffoldBackgroundColor: SColors.light,
    textTheme: STextTheme.lightTextTheme,
    elevatedButtonTheme: SElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: SAppBarTheme.lightAppBarTheme,
    checkboxTheme: SCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: SBottomSheetTheme.lightBottomSheetTheme,
    inputDecorationTheme: STextFormFieldTheme.lightInputDecorationTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.lightOutlinedButtonTheme,
    chipTheme: SChipTheme.lightChipTheme,
    cardTheme: CardThemeData(
      color: SColors.lightContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: SColors.borderSecondary),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: SColors.primary,
    scaffoldBackgroundColor: SColors.dark,
    textTheme: STextTheme.darkTextTheme,
    elevatedButtonTheme: SElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: SAppBarTheme.darkAppBarTheme,
    checkboxTheme: SCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: SBottomSheetTheme.darkBottomSheetTheme,
    inputDecorationTheme: STextFormFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.darkOutlinedButtonTheme,
    chipTheme: SChipTheme.darkChipTheme,
    cardTheme: CardThemeData(
      color: SColors.darkContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: SColors.darkerGrey.withValues(alpha: 0.25)),
      ),
    ),
  );
}
