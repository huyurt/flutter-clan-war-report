import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/views/home/home_screen.dart';
import 'package:more_useful_clash_of_clans/views/splash/splash_screen.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    home: (BuildContext context) => const HomeScreen(),
  };
}
