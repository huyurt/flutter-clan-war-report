import 'package:flutter/material.dart';

import '../helpers/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = const Locale('en');

  LanguageProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale?.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    switch (languageCode) {
      case 'tr':
        _appLocale = const Locale('tr');
        break;
      default:
        _appLocale = const Locale('en');
        break;
    }

    _sharedPrefsHelper.changeLanguage(languageCode);
    notifyListeners();
  }
}
