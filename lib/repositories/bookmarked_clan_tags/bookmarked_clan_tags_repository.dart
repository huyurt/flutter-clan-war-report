import 'dart:async';

import 'bookmarked_clan_tags_cache.dart';

class BookmarkedClanTagsRepository {
  const BookmarkedClanTagsRepository({required this.cache});

  final BookmarkedClanTagsCache cache;

  List<String> getClanTags() => List.of(cache.get());

  Future<List<String>> changeBookmarkedClanTags(String clanTag) async {
    if (cache.contains(clanTag)) {
      await cache.remove(clanTag);
    } else {
      await cache.add(clanTag);
    }
    final clanTags = cache.get();
    return List.of(clanTags);
  }

  Future<void> reorder(String clanTag, int newIndex) async {
    await cache.reorder(clanTag, newIndex);
  }
}
