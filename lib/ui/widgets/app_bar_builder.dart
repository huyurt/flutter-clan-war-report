import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../states/widgets/bottom_nav_bar/bottom_nav_bar_state.dart';
import '../../utils/constants/localization.dart';
import '../../utils/enums/screen_enum.dart';
import '../screens/setting_screen.dart';
import 'app_bar_widget.dart';
import 'app_bar_gone.dart';

PreferredSizeWidget appBarBuilder(BuildContext context, WidgetRef ref) {
  final ScreenEnum? navScreen = ref.watch(bottomNavProvider) as ScreenEnum?;

  switch (navScreen) {
    case ScreenEnum.wars:
      return AppBarWidget(
        title: Localization.wars,
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
        title: Localization.clans,
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.reload,
              color: context.theme.accentColor,
            ),
            onPressed: () {
            },
          ),
        ],
      );
    default:
      return const AppBarGone();
  }
}
