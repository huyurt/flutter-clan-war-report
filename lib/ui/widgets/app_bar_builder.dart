import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/constants/locale_key.dart';
import '../../core/enums/screen_enum.dart';
import 'app_bar_widget.dart';
import 'app_bar_gone.dart';

PreferredSizeWidget appBarBuilder(BuildContext context, ScreenEnum screenType) {
  switch (screenType) {
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
    case ScreenEnum.setting:
      return const AppBarWidget(
        title: LocaleKey.settings,
      );
    default:
      return const AppBarGone();
  }
}
