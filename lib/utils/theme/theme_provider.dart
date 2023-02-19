import 'package:flutter/material.dart';

import '../helpers/shared_preference_helper.dart';

class ThemeProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  bool _isDarkModeOn = false;

  ThemeProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
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

  void changeTheme(bool isDarkModeOn) {
    _sharedPrefsHelper.changeTheme(isDarkModeOn);
    _sharedPrefsHelper.isDarkMode.then((darkModeStatus) {
      _isDarkModeOn = darkModeStatus;
    });

    notifyListeners();
  }
}
