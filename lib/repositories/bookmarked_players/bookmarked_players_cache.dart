import "package:collection/collection.dart";

import '../../models/api/response/player_detail_response_model.dart';

class BookmarkedPlayersCache {
  late List<PlayerDetailResponseModel> _cache = <PlayerDetailResponseModel>[];

  List<String> getPlayerTags() => _cache.map((e) => e.tag).toList();

  List<PlayerDetailResponseModel> getValues() => List.of(_cache);

  PlayerDetailResponseModel? get(String playerTag) =>
      _cache.firstWhereOrNull((e) => e.tag == playerTag);

  void addOrUpdate(String playerTag, PlayerDetailResponseModel playerDetail) {
    final index = _cache.indexWhere((e) => e.tag == playerTag);
    if (index > -1) {
      _cache[index] = playerDetail;
    } else {
      _cache.add(playerDetail);
    }
  }

  bool contains(String playerTag) => _cache.any((e) => e.tag == playerTag);

  void remove(String playerTag) =>
      _cache.removeWhere((e) => e.tag == playerTag);

  void reorder(PlayerDetailResponseModel playerDetail, int newIndex) {
    final reorderedPlayerDetails = getValues()
      ..removeWhere((e) => e.tag == playerDetail.tag)
      ..insert(newIndex, playerDetail);
    _cache = List.of(reorderedPlayerDetails);
  }
}
