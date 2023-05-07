import 'dart:async';

import 'package:more_useful_clash_of_clans/repositories/search_player/search_player_cache.dart';
import 'package:more_useful_clash_of_clans/services/coc/coc_api_players.dart';

import '../../models/api/response/player_detail_response_model.dart';

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
