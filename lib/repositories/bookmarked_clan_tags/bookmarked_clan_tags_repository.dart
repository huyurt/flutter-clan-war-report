import 'dart:async';

import '../../utils/helpers/cache_helper.dart';
import 'bookmarked_clan_tags_cache.dart';

// TODO: Use single repository! Merge this repo to BookmarkedClansRepository.

class BookmarkedClanTagsRepository {
  const BookmarkedClanTagsRepository({required this.cache});

  final BookmarkedClanTagsCache cache;

  Future<List<String>> changeBookmarkedClanTags(String clanTag) async {
    if (cache.contains(clanTag)) {
      cache.remove(clanTag);
    } else {
      cache.add(clanTag);
    }
    final clanTags = cache.get();
    await CacheHelper.setCachedBookmarkedClanTags(clanTags);
    return List.of(clanTags);
  }
}
