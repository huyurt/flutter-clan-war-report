import '../../models/api/clan_detail_response_model.dart';
import 'bookmarked_clans_cache.dart';

class BookmarkedClansRepository {
  const BookmarkedClansRepository({required this.cache});

  final BookmarkedClansCache cache;

  List<String> getClanTags() {
    final clanTags = cache.getKeys();
    return List.of(clanTags);
  }

  List<ClanDetailResponseModel> getClanDetails() {
    final clanDetails = cache.getValues();
    return List.of(clanDetails);
  }

  bool contains(String clanTag) {
    return cache.contains(clanTag);
  }

  void addOrUpdateBookmarkedClans(
      String clanTag, ClanDetailResponseModel clanDetail) {
    cache.addOrUpdate(clanTag, clanDetail);
  }

  void removeBookmarkedClans(String clanTag) {
    cache.remove(clanTag);
  }

  changeBookmarkedClans(String clanTag, ClanDetailResponseModel clanDetail) {
    if (cache.contains(clanTag)) {
      cache.remove(clanTag);
    } else {
      cache.addOrUpdate(clanTag, clanDetail);
    }
  }
}
