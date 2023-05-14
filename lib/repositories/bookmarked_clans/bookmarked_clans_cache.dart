import "package:collection/collection.dart";

import '../../models/api/response/clan_detail_response_model.dart';

class BookmarkedClansCache {
  late List<ClanDetailResponseModel> _cache = <ClanDetailResponseModel>[];

  List<String> getClanTags() =>
      _cache.map((e) => e.tag).toList();

  List<ClanDetailResponseModel> getValues() => List.of(_cache);

  ClanDetailResponseModel? get(String clanTag) =>
      _cache.firstWhereOrNull((e) => e.tag == clanTag);

  void addOrUpdate(String clanTag, ClanDetailResponseModel clanDetail) {
    final index = _cache.indexWhere((e) => e.tag == clanTag);
    if (index > -1) {
      _cache[index] = clanDetail;
    } else {
      _cache.add(clanDetail);
    }
  }

  bool contains(String clanTag) => _cache.any((e) => e.tag == clanTag);

  void remove(String clanTag) => _cache.removeWhere((e) => e.tag == clanTag);

  void reorder(ClanDetailResponseModel clanDetail, int newIndex) {
    final reorderedClanDetails = getValues()
      ..removeWhere((e) => e.tag == clanDetail.tag)
      ..insert(newIndex, clanDetail);
    _cache = List.of(reorderedClanDetails);
  }
}
