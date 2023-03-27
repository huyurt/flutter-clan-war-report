import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/core/enums/locale_enum.dart';

import '../constants/app_constants.dart';
import '../enums/theme_enum.dart';

class EnumHelper {
  static ThemeEnum getThemeType(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return ThemeEnum.light;
      case ThemeMode.dark:
        return ThemeEnum.dark;
      default:
        return ThemeEnum.system;
    }
  }

  static ThemeMode getThemeMode(ThemeEnum themeType) {
    switch (themeType) {
      case ThemeEnum.light:
        return ThemeMode.light;
      case ThemeEnum.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Locale? getLocale(LocaleEnum? localeType) {
    if (localeType == null) {
      return null;
    }
    return Locale(localeType.name);
  }

  static LocaleEnum getLocaleType(Locale locale) {
    return LocaleEnum.values
        .firstWhere((element) => element.name == locale.languageCode);
  }

  static List<Locale> getLocales() {
    return LocaleEnum.values
        .map((localeType) => Locale(localeType.name))
        .toList();
  }

  static String getCountryCode(LocaleEnum localeType) {
    switch (localeType) {
      case LocaleEnum.en:
        return AppConstants.englishFlagCode;
      default:
        return localeType.name;
    }
  }
}
