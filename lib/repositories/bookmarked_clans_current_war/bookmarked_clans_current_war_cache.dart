import '../../models/coc/clans_current_war_state_model.dart';

class BookmarkedClansCurrentWarCache {
  final _cache = <String, ClansCurrentWarStateModel?>{};

  List<String> getKeys() => _cache.keys.toList();

  List<ClansCurrentWarStateModel?> getValues() => _cache.values.toList();

  ClansCurrentWarStateModel? get(String clanTag) => _cache[clanTag];

  void addOrUpdate(String clanTag, ClansCurrentWarStateModel? clanDetail) {
    _cache[clanTag] = clanDetail;
  }

  bool contains(String clanTag) => _cache[clanTag] != null;

  void remove(String clanTag) => _cache.remove(clanTag);
}
