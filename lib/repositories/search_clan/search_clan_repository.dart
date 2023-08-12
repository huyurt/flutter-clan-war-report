import 'dart:async';

import 'package:clan_war_report/repositories/search_clan/search_clan_cache.dart';

import '../../models/api/request/search_clans_request_model.dart';
import '../../../services/coc_api/coc_api_clans.dart';

class SearchClanRepository {
  const SearchClanRepository({required this.cache});

  final SearchClanCache cache;

  Future<SearchClanCacheValueModel> searchClans(
      bool isNextPageRequest, SearchClansRequestModel searchTerm) async {
    SearchClanCacheKeyModel cacheKey = SearchClanCacheKeyModel(
      clanName: searchTerm.clanName,
      minMembers: searchTerm.minMembers,
      maxMembers: searchTerm.maxMembers,
      minClanLevel: searchTerm.minClanLevel,
    );

    SearchClanCacheValueModel? cachedResult;
    final result = await CocApiClans.searchClans(searchTerm);
    if (isNextPageRequest) {
      cachedResult = cache.get(cacheKey);
      if (cachedResult != null) {
        cachedResult.after = result.paging.cursors.after;
        cachedResult.items.addAll(result.items);
      } else {
        cachedResult = SearchClanCacheValueModel(
          after: result.paging.cursors.after,
          items: result.items,
        );
      }
    } else {
      cachedResult = SearchClanCacheValueModel(
        after: result.paging.cursors.after,
        items: result.items,
      );
    }
    cache.set(cacheKey, cachedResult);
    return cachedResult;
  }
}
