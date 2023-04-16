import '../../models/api/clan_war_response_model.dart';
import 'bookmarked_clans_current_war_cache.dart';

class BookmarkedClansCurrentWarRepository {
  const BookmarkedClansCurrentWarRepository({required this.cache});

  final BookmarkedClansCurrentWarCache cache;

  ClanWarResponseModel? getClanCurrentWar(String clanTag) {
    return cache.get(clanTag);
  }

  List<ClanWarResponseModel?> getClansCurrentWar() {
    final clansCurrentWar = cache.getValues();
    return List.of(clansCurrentWar);
  }

  bool contains(String clanTag) {
    return cache.contains(clanTag);
  }

  void addOrUpdateBookmarkedClansCurrentWar(
      String clanTag, ClanWarResponseModel? clanCurrentWar) {
    cache.addOrUpdate(clanTag, clanCurrentWar);
  }

  void removeBookmarkedClansCurrentWar(String clanTag) => cache.remove(clanTag);
}
