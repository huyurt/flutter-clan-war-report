import '../../models/api/response/clan_detail_response_model.dart';

class BookmarkedClansCache {
  final _cache = <String, ClanDetailResponseModel?>{};

  List<String> getKeys() => _cache.keys.toList();

  List<ClanDetailResponseModel?> getValues() => _cache.values.toList();

  ClanDetailResponseModel? get(String clanTag) => _cache[clanTag];

  void addOrUpdate(String clanTag, ClanDetailResponseModel? clanDetail) {
    _cache[clanTag] = clanDetail;
  }

  bool contains(String clanTag) => _cache[clanTag] != null;

  void remove(String clanTag) => _cache.remove(clanTag);
}
