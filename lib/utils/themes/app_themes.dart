import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  );
}
