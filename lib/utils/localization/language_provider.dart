import 'package:flutter/material.dart';

import '../../main.dart';
import '../enums/language-type-enum.dart';
import '../helpers/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = Locale(LanguageTypeEnum.en.name);

  LanguageProvider() {
    _sharedPrefsHelper = locator<SharedPreferenceHelper>();
  }

  Future<Locale> get appLocale async {
    await _sharedPrefsHelper.appLocale.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void changeLanguage(LanguageTypeEnum languageType) {
    _appLocale = Locale(languageType.name);
    _sharedPrefsHelper.saveLanguage(languageType.name);

    notifyListeners();
  }
}
