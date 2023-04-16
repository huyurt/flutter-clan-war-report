import '../../models/api/clan_war_response_model.dart';

class BookmarkedClansCurrentWarCache {
  final _cache = <String, ClanWarResponseModel?>{};

  List<String> getKeys() => _cache.keys.toList();

  List<ClanWarResponseModel?> getValues() => _cache.values.toList();

  ClanWarResponseModel? get(String clanTag) => _cache[clanTag];

  void addOrUpdate(String clanTag, ClanWarResponseModel? clanDetail) {
    _cache[clanTag] = clanDetail;
  }

  bool contains(String clanTag) => _cache[clanTag] != null;

  void remove(String clanTag) => _cache.remove(clanTag);
}
