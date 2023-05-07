import '../../models/coc/clans_current_war_state_model.dart';
import 'bookmarked_clans_current_war_cache.dart';

class BookmarkedClansCurrentWarRepository {
  const BookmarkedClansCurrentWarRepository({required this.cache});

  final BookmarkedClansCurrentWarCache cache;

  List<String> getClanTags() => cache.getKeys();

  ClansCurrentWarStateModel? getClanCurrentWar(String clanTag) {
    return cache.get(clanTag);
  }

  List<ClansCurrentWarStateModel?> getClansCurrentWar() {
    final clansCurrentWar = cache.getValues();
    return List.of(clansCurrentWar);
  }

  bool contains(String clanTag) {
    return cache.contains(clanTag);
  }

  void addOrUpdateBookmarkedClansCurrentWar(
      String clanTag, ClansCurrentWarStateModel? clanCurrentWar) {
    cache.addOrUpdate(clanTag, clanCurrentWar);
  }

  void removeBookmarkedClanCurrentWar(String clanTag) => cache.remove(clanTag);

  void cleanRemovedClanTags(List<String> newClanTagList) {
    final removedClanTags = getClanTags()
        .where((element) => !newClanTagList.contains(element))
        .toList();
    for (final clanTag in removedClanTags) {
      removeBookmarkedClanCurrentWar(clanTag);
    }
  }
}
