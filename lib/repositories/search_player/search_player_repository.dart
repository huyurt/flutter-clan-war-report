import 'dart:async';

import 'package:clan_war_report/repositories/search_player/search_player_cache.dart';

import '../../models/api/response/player_detail_response_model.dart';
import '../../services/coc_api/coc_api_players.dart';

class SearchPlayerRepository {
  const SearchPlayerRepository({required this.cache});

  final SearchPlayerCache cache;

  Future<SearchPlayerCacheValueModel> searchPlayers(String searchTerm) async {
    SearchPlayerCacheKeyModel cacheKey = SearchPlayerCacheKeyModel(
      playerName: searchTerm,
    );

    final result = await CocApiPlayers.getPlayerDetail(searchTerm);
    SearchPlayerCacheValueModel? cachedResult = SearchPlayerCacheValueModel(
      items: <PlayerDetailResponseModel>[result],
    );
    cache.set(cacheKey, cachedResult);
    return cachedResult;
  }
}
