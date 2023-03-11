import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/helpers/shared_preference_helper.dart';

class ThemeProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  bool _isDarkModeOn = false;

  ThemeProvider() {
    _sharedPrefsHelper = locator<SharedPreferenceHelper>();
  }

  bool get isDarkModeOn {
    _sharedPrefsHelper.isDarkMode.then((statusValue) {
      if (_isDarkModeOn != statusValue) {
        notifyListeners();
      }
      _isDarkModeOn = statusValue;
    });

    return _isDarkModeOn;
  }

  void toggleDarkMode(bool isDarkModeOn) {
    _sharedPrefsHelper.saveTheme(isDarkModeOn);
    _isDarkModeOn = isDarkModeOn;

    notifyListeners();
  }
}
