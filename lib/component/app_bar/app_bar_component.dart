import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/providers/screen_provider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants/localization.dart';
import '../../utils/enums/screen_enum.dart';
import '../../utils/localization/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../../views/setting/setting_screen.dart';

AppBar appBarComponent(
    BuildContext context, ThemeProvider themeProviderRef, ScreenProvider screenProviderRef) {
  switch (screenProviderRef.currentScreen) {
    case ScreenEnum.Wars:
      return AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings,
                color: themeProviderRef.isDarkModeOn ? white : black),
            onPressed: () {
              const SettingScreen().launch(context);
            },
          ),
        ],
        title: Text(
          AppLocalizations.of(context).translate(Localization.Wars),
        ),
      );
    default:
      return AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          '${AppLocalizations.of(context).translate(Localization.Screen)} ${screenProviderRef.currentScreen}',
        ),
      );
  }
}
