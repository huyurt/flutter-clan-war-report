import '../../models/api/player_detail_response_model.dart';

class BookmarkedPlayersCache {
  final _cache = <String, PlayerDetailResponseModel>{};

  List<String> getKeys() => _cache.keys.toList();

  List<PlayerDetailResponseModel> getValues() => _cache.values.toList();

  PlayerDetailResponseModel? get(String playerTag) => _cache[playerTag];

  void addOrUpdate(String playerTag, PlayerDetailResponseModel playerDetail) {
    _cache[playerTag] = playerDetail;
  }

  bool contains(String playerTag) => _cache[playerTag] != null;

  void remove(String playerTag) => _cache.remove(playerTag);
}
