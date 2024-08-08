import 'package:elegan/core/constants/colors.dart';
import 'package:elegan/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class EleganAppBarTheme {
  EleganAppBarTheme._();

  static const eleganAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: EleganColors.white,
    surfaceTintColor: EleganColors.white,
    iconTheme:
        IconThemeData(color: EleganColors.darkGrey, size: EleganSizes.iconMd),
    actionsIconTheme:
        IconThemeData(color: EleganColors.darkGrey, size: EleganSizes.iconMd),
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: EleganColors.darkGrey,
    ),
  );
}
