import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/bookmarked_clan_tags/bookmarked_clan_tags_cache.dart';
import '../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../repositories/bookmarked_clans/bookmarked_clans_cache.dart';
import '../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_cache.dart';
import '../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../repositories/bookmarked_player_tags/bookmarked_player_tags_cache.dart';
import '../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import '../repositories/bookmarked_players/bookmarked_players_cache.dart';
import '../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../repositories/search_clan/search_clan_cache.dart';
import '../repositories/search_clan/search_clan_repository.dart';
import '../repositories/search_player/search_player_cache.dart';
import '../repositories/search_player/search_player_repository.dart';
import '../repositories/war_log/war_log_cache.dart';
import '../repositories/war_log/war_log_repository.dart';

getBlocRepositoryProviders() {
  return [
    RepositoryProvider(
      create: (context) => SearchClanRepository(
        cache: SearchClanCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => SearchPlayerRepository(
        cache: SearchPlayerCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => BookmarkedClanTagsRepository(
        cache: BookmarkedClanTagsCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => BookmarkedPlayerTagsRepository(
        cache: BookmarkedPlayerTagsCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => BookmarkedClansRepository(
        cache: BookmarkedClansCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => BookmarkedPlayersRepository(
        cache: BookmarkedPlayersCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => BookmarkedClansCurrentWarRepository(
        cache: BookmarkedClansCurrentWarCache(),
      ),
    ),
    RepositoryProvider(
      create: (context) => WarLogRepository(
        cache: WarLogCache(),
      ),
    ),
  ];
}
