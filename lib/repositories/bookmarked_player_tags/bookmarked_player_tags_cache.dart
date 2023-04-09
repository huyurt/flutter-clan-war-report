import '../../utils/helpers/cache_helper.dart';

class BookmarkedPlayerTagsCache {
  final _cache = CacheHelper.getCachedBookmarkedPlayerTags();

  List<String> get() => _cache;

  void add(String playerTag) async {
    if (!_cache.contains(playerTag)) {
      _cache.add(playerTag);
    }
  }

  bool contains(String playerTag) => _cache.contains(playerTag);

  void remove(String playerTag) => _cache.remove(playerTag);
}
