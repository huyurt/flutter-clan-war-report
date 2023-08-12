import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clan_war_report/bloc/settings/locale_cubit.dart';
import 'package:clan_war_report/bloc/settings/settings_cubit.dart';
import 'package:clan_war_report/bloc/settings/theme_cubit.dart';
import 'package:clan_war_report/bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import 'package:clan_war_report/bloc/widgets/bookmarked_clans/bookmarked_clans_bloc.dart';
import 'package:clan_war_report/bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import 'package:clan_war_report/bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import 'package:clan_war_report/bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import 'package:clan_war_report/bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'package:clan_war_report/bloc/widgets/search_clan/search_clan_bloc.dart';
import 'package:clan_war_report/bloc/widgets/search_player/search_player_bloc.dart';

import '../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import '../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../repositories/search_clan/search_clan_repository.dart';
import '../repositories/search_player/search_player_repository.dart';

getBlocProviders() {
  return [
    BlocProvider(
      create: (context) => SettingsCubit(),
    ),
    BlocProvider(
      create: (context) => LocaleCubit(),
    ),
    BlocProvider(
      create: (context) => ThemeCubit(),
    ),
    BlocProvider(
      create: (context) => BottomNavigationBarCubit(),
    ),
    BlocProvider(
      create: (context) => SearchClanBloc(
        searchClanRepository: context.read<SearchClanRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => SearchPlayerBloc(
        searchPlayerRepository: context.read<SearchPlayerRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => BookmarkedClanTagsCubit(
        bookmarkedClanTagsRepository:
            context.read<BookmarkedClanTagsRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => BookmarkedPlayerTagsCubit(
        bookmarkedPlayerTagsRepository:
            context.read<BookmarkedPlayerTagsRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => BookmarkedClansBloc(
        bookmarkedClansRepository: context.read<BookmarkedClansRepository>(),
        bookmarkedClanTagsRepository:
            context.read<BookmarkedClanTagsRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => BookmarkedPlayersBloc(
        bookmarkedPlayersRepository:
            context.read<BookmarkedPlayersRepository>(),
        bookmarkedPlayerTagsRepository:
            context.read<BookmarkedPlayerTagsRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => BookmarkedClansCurrentWarBloc(
        bookmarkedClansCurrentWarRepository:
            context.read<BookmarkedClansCurrentWarRepository>(),
      ),
    ),
  ];
}
