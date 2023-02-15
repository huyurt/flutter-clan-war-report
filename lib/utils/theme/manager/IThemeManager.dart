import 'ThemeManager.dart';

abstract class IThemeManager {
  void changeTheme(ThemeEnum theme);

  bool get darkModeOn;
}
