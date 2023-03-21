import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../enums/locale_enum.dart';
import '../enums/theme_enum.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static LocaleEnum? getCachedLocale() {
    final localeType = prefs.getInt(AppConstants.hiveLocaleKey);
    if (localeType == null) {
      return null;
    }
    return LocaleEnum.values[localeType];
  }

  static Future<void> setCachedLocale(LocaleEnum localeType) async {
    await prefs.setInt(AppConstants.hiveLocaleKey, localeType.index);
  }

  static ThemeEnum getCachedTheme() {
    final themeType = prefs.getInt(AppConstants.hiveThemeKey) ?? 0;
    return ThemeEnum.values[themeType];
  }

  static Future<void> setCachedTheme(ThemeEnum themeType) async {
    await prefs.setInt(AppConstants.hiveThemeKey, themeType.index);
  }
}
