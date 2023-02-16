import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../types/ThemeDark.dart';
import '../types/ThemeLight.dart';
import 'IThemeManager.dart';

enum ThemeEnum { DARK, LIGHT }

extension ThemeContextExtension on BuildContext {
  ThemeData get appTheme => watch<ThemeManager>().currentTheme;
}

class ThemeManager extends ChangeNotifier implements IThemeManager {
  static ThemeManager? _instance;

  static ThemeManager get instance {
    _instance ??= ThemeManager._init();
    return _instance!;
  }

  ThemeManager._init();

  ThemeData currentTheme = ThemeEnum.LIGHT.generate;
  ThemeEnum currentThemeEnum = ThemeEnum.LIGHT;

  @override
  Future<void> changeTheme(ThemeEnum newTheme) async {
    if (newTheme != currentThemeEnum) {
      currentTheme = newTheme.generate;
      currentThemeEnum = newTheme;

      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(THEME_MODE_INDEX, newTheme.index);

      notifyListeners();
    }
    return;
  }

  @override
  bool get darkModeOn => currentThemeEnum == ThemeEnum.DARK;
}

extension ThemeEnumExtension on ThemeEnum {
  ThemeData get generate {
    switch (this) {
      case ThemeEnum.LIGHT:
        return ThemeLight.instance.theme!;
      case ThemeEnum.DARK:
        return ThemeDark.instance.theme!;
      default:
        return ThemeLight.instance.theme!;
    }
  }
}
