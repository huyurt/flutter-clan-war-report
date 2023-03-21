import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/constants/locale_keys.dart';
import '../../core/enums/screen_enum.dart';
import '../view/setting_screen.dart';
import 'app_bar_widget.dart';
import 'app_bar_gone.dart';

PreferredSizeWidget appBarBuilder(BuildContext context, ScreenEnum screenType) {
  switch (screenType) {
    case ScreenEnum.wars:
      return AppBarWidget(
        title: LocaleKey.wars,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: context.theme.accentColor,
            ),
            onPressed: () {
              const SettingScreen().launch(context);
            },
          ),
        ],
      );
    case ScreenEnum.clans:
      return AppBarWidget(
        title: LocaleKey.clans,
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.reload,
              color: context.theme.accentColor,
            ),
            onPressed: () {},
          ),
        ],
      );
    default:
      return const AppBarGone();
  }
}
