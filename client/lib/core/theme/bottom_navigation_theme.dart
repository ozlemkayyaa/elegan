import 'package:elegan/core/constants/colors.dart';
import 'package:elegan/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class EleganBottomNavigationTheme {
  EleganBottomNavigationTheme._();

  static final eleganBottomNavigationTheme = BottomNavigationBarThemeData(
    backgroundColor: EleganColors.darkGrey,
    selectedItemColor: EleganColors.white,
    unselectedItemColor: EleganColors.lightGrey,
    elevation: 0,
    selectedLabelStyle: EleganTextTheme.eleganTextTheme.labelLarge,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}
