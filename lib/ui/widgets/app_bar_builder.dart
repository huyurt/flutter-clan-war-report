import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../bloc/widgets/bookmarked_clans/bookmarked_clans_bloc.dart';
import '../../bloc/widgets/bookmarked_clans/bookmarked_clans_event.dart';
import '../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import '../../bloc/widgets/bookmarked_players/bookmarked_players_event.dart';
import '../../utils/constants/locale_key.dart';
import '../../utils/enums/screen_enum.dart';
import 'app_bar_widget.dart';
import 'app_bar_gone.dart';

PreferredSizeWidget appBarBuilder(BuildContext context, ScreenEnum screenType) {
  late BookmarkedClansBloc bookmarkedClansBloc =
      context.read<BookmarkedClansBloc>();
  late BookmarkedPlayersBloc bookmarkedPlayersBloc =
      context.read<BookmarkedPlayersBloc>();

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
            onPressed: () {
              bookmarkedClansBloc.add(
                GetBookmarkedClanDetail(
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
            icon: Icon(
              Ionicons.reload,
              color: context.theme.accentColor,
            ),
            onPressed: () {
              bookmarkedPlayersBloc.add(
                GetBookmarkedPlayerDetail(
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
