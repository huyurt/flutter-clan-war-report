import '../../utils/helpers/cache_helper.dart';

class BookmarkedPlayerTagsCache {
  late List<String> _cache = CacheHelper.getCachedBookmarkedPlayerTags();

  List<String> get() => List.of(_cache);

  Future<void> add(String playerTag) async {
    if (!_cache.contains(playerTag)) {
      _cache.add(playerTag);
      final clanTags = get();
      await CacheHelper.setCachedBookmarkedPlayerTags(clanTags);
    }
  }

  bool contains(String playerTag) => _cache.contains(playerTag);

  Future<void> remove(String playerTag) async {
    if (_cache.contains(playerTag)) {
      _cache.remove(playerTag);
      final clanTags = get();
      await CacheHelper.setCachedBookmarkedPlayerTags(clanTags);
    }
  }

  Future<void> reorder(String playerTag, int newIndex) async {
    final reorderedClanTags = get()
      ..removeWhere((element) => element == playerTag)
      ..insert(newIndex, playerTag);
    final newList = List.of(reorderedClanTags);
    CacheHelper.setCachedBookmarkedPlayerTags(newList);
    _cache = newList;
  }
}
