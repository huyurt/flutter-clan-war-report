import 'dart:async';

import 'package:more_useful_clash_of_clans/repositories/war_log/war_log_cache.dart';

import '../../../services/coc_api/coc_api_clans.dart';

class WarLogRepository {
  const WarLogRepository({required this.cache});

  final WarLogCache cache;

  Future<WarLogCacheValueModel> getWarLog(String clanTag) async {
    WarLogCacheKeyModel cacheKey = WarLogCacheKeyModel(
      clanTag: clanTag,
    );

    WarLogCacheValueModel? cachedResult;
    final result = await CocApiClans.getWarLog(clanTag);
    cachedResult = WarLogCacheValueModel(
      items: result.items,
    );
    cache.set(cacheKey, cachedResult);
    return cachedResult;
  }
}
