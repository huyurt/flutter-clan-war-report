import 'package:equatable/equatable.dart';

import '../../models/api/player_detail_response_model.dart';

class SearchPlayerCache {
  final _cache = <SearchPlayerCacheKeyModel, SearchPlayerCacheValueModel>{};

  SearchPlayerCacheValueModel? get(SearchPlayerCacheKeyModel term) =>
      _cache[term];

  void set(
          SearchPlayerCacheKeyModel term, SearchPlayerCacheValueModel result) =>
      _cache[term] = result;

  bool contains(SearchPlayerCacheKeyModel term) => _cache.containsKey(term);

  void remove(SearchPlayerCacheKeyModel term) => _cache.remove(term);
}

class SearchPlayerCacheKeyModel extends Equatable {
  const SearchPlayerCacheKeyModel({
    this.playerName,
  });

  final String? playerName;

  @override
  List<Object?> get props => [playerName];
}

class SearchPlayerCacheValueModel {
  SearchPlayerCacheValueModel({
    required this.items,
  });

  final List<PlayerDetailResponseModel> items;
}
