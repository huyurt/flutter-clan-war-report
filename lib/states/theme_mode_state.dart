import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../utils/constants/app_constants.dart';

final AutoDisposeChangeNotifierProvider<ThemeModeState> themeProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<ThemeModeState> ref) {
  return ThemeModeState();
});

class ThemeModeState extends ChangeNotifier {
  ThemeModeState() {
    final String mode = Hive.box(AppConstants.hivePreferenceKey).get(
        AppConstants.hiveThemeKey,
        defaultValue: ThemeMode.system.toString()) as String;
    switch (mode) {
      case 'ThemeMode.dark':
        themeMode = ThemeMode.dark;
        break;
      case 'ThemeMode.light':
        themeMode = ThemeMode.light;
        break;
      case 'ThemeMode.system':
        themeMode = ThemeMode.system;
        break;
    }
  }

  ThemeMode? themeMode;

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    Hive.box(AppConstants.hivePreferenceKey)
        .put(AppConstants.hiveThemeKey, themeMode.toString());
    notifyListeners();
  }
}
