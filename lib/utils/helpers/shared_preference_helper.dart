import 'dart:io';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';

import '../enums/language-type.dart';

class SharedPreferenceHelper {
  static const String themeModeKey = 'themeMode';
  static const String languageCodeKey = 'languageCode';

  final Future<SharedPreferences> _sharedPreference =
      SharedPreferences.getInstance();

  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(themeModeKey) ?? SystemTheme.isDarkMode;
    });
  }

  Future<void> saveTheme(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(themeModeKey, value);
    });
  }

  Future<String> get appLocale {
    return _sharedPreference.then((prefs) {
      String languageCode =
          prefs.getString(languageCodeKey) ?? Platform.localeName.split('_')[0];
      LanguageType languageType = LanguageType.values.firstWhereOrNull(
              (languageType) => languageType.name == languageCode) ??
          LanguageType.en;
      return languageType.name;
    });
  }

  Future<void> saveLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(languageCodeKey, value);
    });
  }
}
