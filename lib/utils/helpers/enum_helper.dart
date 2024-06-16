import 'package:flutter/material.dart';
import 'package:clan_war_report/utils/enums/locale_enum.dart';
import 'package:clan_war_report/utils/enums/war_league_enum.dart';

import '../../models/coc/league_result_model.dart';
import '../constants/app_constants.dart';
import '../enums/theme_enum.dart';

class EnumHelper {
  static ThemeEnum getThemeType(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return ThemeEnum.light;
      case ThemeMode.dark:
        return ThemeEnum.dark;
      default:
        return ThemeEnum.system;
    }
  }

  static ThemeMode getThemeMode(ThemeEnum themeType) {
    switch (themeType) {
      case ThemeEnum.light:
        return ThemeMode.light;
      case ThemeEnum.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Locale? getLocale(LocaleEnum? localeType) {
    if (localeType == null) {
      return null;
    }
    return Locale(localeType.name);
  }

  static LocaleEnum getLocaleType(Locale locale) {
    return LocaleEnum.values
        .firstWhere((element) => element.name == locale.languageCode);
  }

  static List<Locale> getLocales() {
    return LocaleEnum.values
        .map((localeType) => Locale(localeType.name))
        .toList();
  }

  static String getCountryCode(LocaleEnum localeType) {
    switch (localeType) {
      case LocaleEnum.en:
        return AppConstants.englishFlagCode;
      default:
        return localeType.name;
    }
  }

  static WarLeagueEnum getWarLeagueById(int warLeagueId) {
    int war = 48000000 + warLeagueId % 100;
    return WarLeagueEnum.values.firstWhere((w) => w.value == war);
  }

  static int getWarLeagueId(WarLeagueEnum warLeague) {
    return AppConstants.warLeagueUnranked +
        WarLeagueEnum.values.indexOf(warLeague);
  }

  static LeagueResultModel getLeagueResult(WarLeagueEnum warLeague) {
    switch (warLeague) {
      case WarLeagueEnum.bronzeLeagueIII:
        return LeagueResultModel(promoted: 3, demoted: 0);
      case WarLeagueEnum.bronzeLeagueII:
        return LeagueResultModel(promoted: 3, demoted: 1);
      case WarLeagueEnum.bronzeLeagueI:
        return LeagueResultModel(promoted: 3, demoted: 1);
      case WarLeagueEnum.silverLeagueIII:
        return LeagueResultModel(promoted: 2, demoted: 1);
      case WarLeagueEnum.silverLeagueII:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.silverLeagueI:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.goldLeagueIII:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.goldLeagueII:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.goldLeagueI:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.crystalLeagueIII:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.crystalLeagueII:
        return LeagueResultModel(promoted: 2, demoted: 2);
      case WarLeagueEnum.crystalLeagueI:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.masterLeagueIII:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.masterLeagueII:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.masterLeagueI:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.championLeagueIII:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.championLeagueII:
        return LeagueResultModel(promoted: 1, demoted: 2);
      case WarLeagueEnum.championLeagueI:
        return LeagueResultModel(promoted: 0, demoted: 3);
      default:
        return LeagueResultModel(promoted: 0, demoted: 0);
    }
  }
}
