import '../../models/api/clan_war_and_war_type_response_model.dart';

class BookmarkedClansCurrentWarCache {
  final _cache = <String, ClanWarAndWarTypeResponseModel?>{};

  List<String> getKeys() => _cache.keys.toList();

  List<ClanWarAndWarTypeResponseModel?> getValues() => _cache.values.toList();

  ClanWarAndWarTypeResponseModel? get(String clanTag) => _cache[clanTag];

  void addOrUpdate(String clanTag, ClanWarAndWarTypeResponseModel? clanDetail) {
    _cache[clanTag] = clanDetail;
  }

  bool contains(String clanTag) => _cache[clanTag] != null;

  void remove(String clanTag) => _cache.remove(clanTag);
}
