import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/ui/screens/home_screen/home_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/setting_screen/setting_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/home_screen/splash_screen.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String home = '/home';
  static const String setting = '/setting';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    home: (BuildContext context) => const HomeScreen(),
    setting: (BuildContext context) => const SettingScreen(),
  };
}
