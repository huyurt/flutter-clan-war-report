import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/theme/theme_cubit.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bookmarked_clans/bookmarked_clans_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/clan_current_war_detail/clan_current_war_detail_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/clan_detail/clan_detail_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/clan_league_wars/clan_league_wars_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/player_detail/player_detail_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/search_clan/search_clan_bloc.dart';
import 'package:more_useful_clash_of_clans/bloc/widgets/search_player/search_player_bloc.dart';

import '../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import '../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../repositories/search_clan/search_clan_repository.dart';
import '../repositories/search_player/search_player_repository.dart';
import 'locale/locale_cubit.dart';

getBlocProviders() {
  return [
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
      create: (context) => ClanDetailBloc(),
    ),
    BlocProvider(
      create: (context) => PlayerDetailBloc(),
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
    BlocProvider(
      create: (context) => ClanCurrentWarDetailBloc(),
    ),
    BlocProvider(
      create: (context) => ClanLeagueWarsBloc(),
    ),
  ];
}
