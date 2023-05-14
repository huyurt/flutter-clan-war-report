import '../../utils/helpers/cache_helper.dart';

class BookmarkedClanTagsCache {
  late List<String> _cache = CacheHelper.getCachedBookmarkedClanTags();

  List<String> get() => List.of(_cache);

  Future<void> add(String clanTag) async {
    if (!_cache.contains(clanTag)) {
      _cache.add(clanTag);
      final clanTags = get();
      await CacheHelper.setCachedBookmarkedClanTags(clanTags);
    }
  }

  bool contains(String clanTag) => _cache.contains(clanTag);

  Future<void> remove(String clanTag) async {
    if (_cache.contains(clanTag)) {
      _cache.remove(clanTag);
      final clanTags = get();
      await CacheHelper.setCachedBookmarkedClanTags(clanTags);
    }
  }

  Future<void> reorder(String clanTag, int newIndex) async {
    final reorderedClanTags = get()
      ..removeWhere((element) => element == clanTag)
      ..insert(newIndex, clanTag);
    final newList = List.of(reorderedClanTags);
    CacheHelper.setCachedBookmarkedClanTags(newList);
    _cache = newList;
  }
}
