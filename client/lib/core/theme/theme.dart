import 'package:elegan/core/constants/colors.dart';
import 'package:elegan/core/theme/appbar_theme.dart';
import 'package:elegan/core/theme/bottom_navigation_theme.dart';
import 'package:elegan/core/theme/elevated_button_theme.dart';
import 'package:elegan/core/theme/outlined_button_theme.dart';
import 'package:elegan/core/theme/text_field_theme.dart';
import 'package:elegan/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class EleganAppTheme {
  EleganAppTheme._();

  static ThemeData eleganAppTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: EleganColors.grey,
    textTheme: EleganTextTheme.eleganTextTheme,
    scaffoldBackgroundColor: EleganColors.white,
    appBarTheme: EleganAppBarTheme.eleganAppBarTheme,
    elevatedButtonTheme: EleganElevatedButtonTheme.eleganElevatedButtonTheme,
    outlinedButtonTheme: EleganOutlineButtonTheme.eleganOutlinedButtonTheme,
    inputDecorationTheme: EleganTextFormFieldTheme.eleganInputDecorationTheme,
    bottomNavigationBarTheme:
        EleganBottomNavigationTheme.eleganBottomNavigationTheme,
    buttonTheme: const ButtonThemeData(buttonColor: EleganColors.lightGrey),
  );
}
