import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/locale/LanguageEn.dart';
import 'package:more_useful_clash_of_clans/locale/LanguageTr.dart';
import 'package:more_useful_clash_of_clans/locale/Languages.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'tr':
        return LanguageTr();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
