import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/providers/screen_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/enums/screen_enum.dart';
import '../../views/wars/wars_screen.dart';

class AppBodyBuilder extends StatelessWidget {
  const AppBodyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedScreen = context.watch<ScreenProvider>().currentScreen;
    switch (selectedScreen) {
      case ScreenEnum.Wars:
        return const WarsScreen();
      default:
        return Text(
          '$selectedScreen',
        );
    }
  }
}
