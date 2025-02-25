import 'package:nb_utils/nb_utils.dart';

import '../../models/app/settings_model.dart';
import '../constants/app_constants.dart';
import '../enums/locale_enum.dart';
import '../enums/theme_enum.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static LocaleEnum? getCachedLocale() {
    final localeType = prefs.getInt(AppConstants.hiveLocaleKey);
    if (localeType == null) {
      return null;
    }
    return LocaleEnum.values[localeType];
  }

  static Future<void> setCachedLocale(LocaleEnum localeType) async {
    await prefs.setInt(AppConstants.hiveLocaleKey, localeType.index);
  }

  static ThemeEnum getCachedTheme() {
    final themeType = prefs.getInt(AppConstants.hiveThemeKey) ?? 0;
    return ThemeEnum.values[themeType];
  }

  static Future<void> setCachedTheme(ThemeEnum themeType) async {
    await prefs.setInt(AppConstants.hiveThemeKey, themeType.index);
  }

  static SettingsModel getCachedSettings() {
    final settings = prefs.getString(AppConstants.hiveSettingsKey) ?? '';
    if (settings.isEmptyOrNull) {
      return SettingsModel.getDefault();
    }
    return SettingsModel.fromJson(settings);
  }

  static Future<void> setCachedSettings(SettingsModel settingsModel) async {
    await prefs.setString(AppConstants.hiveSettingsKey, settingsModel.toJson());
  }

  static List<String> getCachedBookmarkedClanTags() {
    return prefs.getStringList(AppConstants.hiveClanTagsKey) ?? <String>[];
  }

  static Future<void> setCachedBookmarkedClanTags(List<String> clanTags) async {
    await prefs.setStringList(AppConstants.hiveClanTagsKey, clanTags);
  }

  static List<String> getCachedBookmarkedPlayerTags() {
    return prefs.getStringList(AppConstants.hivePlayerTagsKey) ?? <String>[];
  }

  static Future<void> setCachedBookmarkedPlayerTags(
      List<String> playerTags) async {
    await prefs.setStringList(AppConstants.hivePlayerTagsKey, playerTags);
  }
}
