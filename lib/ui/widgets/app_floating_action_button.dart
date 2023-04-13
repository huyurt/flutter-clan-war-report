import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/players_screen/search_player_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../../utils/constants/locale_key.dart';
import '../../utils/enums/screen_enum.dart';
import 'clans_screen/search_clan_screen.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.watch<BottomNavigationBarCubit>().state.screenType) {
      case ScreenEnum.clans:
        return FloatingActionButton.extended(
          label: Text(tr(LocaleKey.search)),
          icon: const Icon(Icons.search),
          onPressed: () {
            const SearchClanScreen().launch(context);
          },
        );
      case ScreenEnum.players:
        return FloatingActionButton.extended(
          label: Text(tr(LocaleKey.search)),
          icon: const Icon(Icons.search),
          onPressed: () {
            const SearchPlayerScreen().launch(context);
          },
        );
      default:
        return Container();
    }
  }
}
