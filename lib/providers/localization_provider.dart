import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/enums/localization_enum.dart';
import '../utils/helpers/shared_preference_helper.dart';

class LocalizationProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocalization = Locale(LocalizationEnum.en.name);

  LocalizationProvider() {
    _sharedPrefsHelper = locator<SharedPreferenceHelper>();
  }

  Future<Locale> get appLocale async {
    await _sharedPrefsHelper.appLocale.then((localeValue) {
      _appLocalization = Locale(localeValue);
    });

    return _appLocalization;
  }

  void changeLocalization(LocalizationEnum languageType) {
    _appLocalization = Locale(languageType.name);
    _sharedPrefsHelper.saveLocalization(languageType.name);

    notifyListeners();
  }
}
