import 'dart:async';

import 'bookmarked_player_tags_cache.dart';

class BookmarkedPlayerTagsRepository {
  const BookmarkedPlayerTagsRepository({required this.cache});

  final BookmarkedPlayerTagsCache cache;

  List<String> getPlayerTags() => List.of(cache.get());

  Future<List<String>> changeBookmarkedPlayerTags(String playerTag) async {
    if (cache.contains(playerTag)) {
      await cache.remove(playerTag);
    } else {
      await cache.add(playerTag);
    }
    final playerTags = cache.get();
    return List.of(playerTags);
  }

  Future<void> reorder(String playerTag, int newIndex) async {
    await cache.reorder(playerTag, newIndex);
  }
}
