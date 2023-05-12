import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_clans/bookmarked_clans_bloc.dart';
import '../../../bloc/widgets/bookmarked_clans/bookmarked_clans_event.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_event.dart';
import '../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_event.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/enums/screen_enum.dart';
import 'app_bar_gone.dart';
import 'app_bar_widget.dart';

PreferredSizeWidget appBarBuilder(BuildContext context, ScreenEnum screenType) {
  final bookmarkedClansCurrentWarBloc =
      context.read<BookmarkedClansCurrentWarBloc>();
  final bookmarkedClansBloc = context.read<BookmarkedClansBloc>();
  final bookmarkedPlayersBloc = context.read<BookmarkedPlayersBloc>();

  switch (screenType) {
    case ScreenEnum.wars:
      return AppBarWidget(
        title: LocaleKey.wars,
        actions: [
          IconButton(
            icon: const Icon(Ionicons.reload),
            onPressed: () {
              bookmarkedClansCurrentWarBloc.add(
                RefreshBookmarkedClansCurrentWar(
                  clanTagList:
                      context.read<BookmarkedClanTagsCubit>().state.clanTags,
                ),
              );
            },
          ),
        ],
      );
    case ScreenEnum.clans:
      return AppBarWidget(
        title: LocaleKey.clans,
        actions: [
          IconButton(
            icon: const Icon(Ionicons.reload),
            onPressed: () {
              bookmarkedClansBloc.add(
                RefreshBookmarkedClanDetail(
                  clanTagList:
                      context.read<BookmarkedClanTagsCubit>().state.clanTags,
                ),
              );
            },
          ),
        ],
      );
    case ScreenEnum.players:
      return AppBarWidget(
        title: LocaleKey.players,
        actions: [
          IconButton(
            icon: const Icon(Ionicons.reload),
            onPressed: () {
              bookmarkedPlayersBloc.add(
                RefreshBookmarkedPlayerDetail(
                  playerTagList: context
                      .read<BookmarkedPlayerTagsCubit>()
                      .state
                      .playerTags,
                ),
              );
            },
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
