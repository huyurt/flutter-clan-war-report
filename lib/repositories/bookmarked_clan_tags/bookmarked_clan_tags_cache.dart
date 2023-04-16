import '../../utils/helpers/cache_helper.dart';

class BookmarkedClanTagsCache {
  final _cache = CacheHelper.getCachedBookmarkedClanTags();

  List<String> get() => _cache;

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
}
