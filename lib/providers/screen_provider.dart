import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/screen_enum.dart';

class ScreenProvider extends ChangeNotifier {
  ScreenEnum _screen = ScreenEnum.Wars;

  ScreenEnum get currentScreen {
    return _screen;
  }

  void changeScreen(ScreenEnum newScreen) {
    _screen = newScreen;

    notifyListeners();
  }
}
