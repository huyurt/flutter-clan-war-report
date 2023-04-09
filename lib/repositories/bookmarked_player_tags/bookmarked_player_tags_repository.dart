import 'dart:async';

import '../../utils/helpers/cache_helper.dart';
import 'bookmarked_player_tags_cache.dart';

class BookmarkedPlayerTagsRepository {
  const BookmarkedPlayerTagsRepository({required this.cache});

  final BookmarkedPlayerTagsCache cache;

  Future<List<String>> changeBookmarkedPlayerTags(String playerTag) async {
    if (cache.contains(playerTag)) {
      cache.remove(playerTag);
    } else {
      cache.add(playerTag);
    }
    final playerTags = cache.get();
    await CacheHelper.setCachedBookmarkedPlayerTags(playerTags);
    return List.of(playerTags);
  }
}
