import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String themeMode = 'themeMode';
  static const String languageCode = 'languageCode';

  Future<SharedPreferences>? _sharedPreference;

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  Future<bool> get isDarkMode {
    return _sharedPreference!.then((prefs) {
      return prefs.getBool(themeMode) ?? false;
    });
  }

  Future<void> changeTheme(bool value) {
    return _sharedPreference!.then((prefs) {
      return prefs.setBool(themeMode, value);
    });
  }

  Future<String>? get appLocale {
    return _sharedPreference?.then((prefs) {
      return prefs.getString(languageCode) ?? 'en';
    });
  }

  Future<void> changeLanguage(String value) {
    return _sharedPreference!.then((prefs) {
      return prefs.setString(languageCode, value);
    });
  }
}
