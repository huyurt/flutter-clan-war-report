import '../../utils/helpers/cache_helper.dart';

class BookmarkedClanTagsCache {
  final _cache = CacheHelper.getCachedBookmarkedClanTags();

  List<String> get() => _cache;

  void add(String clanTag) async {
    if (!_cache.contains(clanTag)) {
      _cache.add(clanTag);
    }
  }

  bool contains(String clanTag) => _cache.contains(clanTag);

  void remove(String clanTag) => _cache.remove(clanTag);
}
