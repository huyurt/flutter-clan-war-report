import 'package:flutter/material.dart';

import '../../main.dart';
import '../enums/language-type.dart';
import '../helpers/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = Locale(LanguageType.en.name);

  LanguageProvider() {
    _sharedPrefsHelper = locator<SharedPreferenceHelper>();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void changeLanguage(LanguageType languageType) {
    _appLocale = Locale(LanguageType.tr.name);
    _sharedPrefsHelper.saveLanguage(languageType.name);
    notifyListeners();
  }
}
