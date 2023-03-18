import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../states/widgets/bottom_nav_bar/bottom_nav_bar_state.dart';
import '../../utils/constants/localization.dart';
import '../../utils/enums/screen_enum.dart';
import 'clans_screen/search_clan_screen.dart';

class AppFloatingActionButton extends ConsumerWidget {
  const AppFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenEnum? navScreen = ref.watch(bottomNavProvider) as ScreenEnum?;

    switch (navScreen) {
      case ScreenEnum.clans:
        return FloatingActionButton.extended(
          label: Text(tr(Localization.search)),
          icon: const Icon(Icons.search),
          onPressed: () {
            const SearchClanScreen().launch(context);
          },
        );
      default:
        return FloatingActionButton.extended(
          label: Text(tr(Localization.search)),
          icon: const Icon(Icons.search),
          onPressed: () {
            toast('...Ekleniyor');
          },
        );
    }
  }
}
