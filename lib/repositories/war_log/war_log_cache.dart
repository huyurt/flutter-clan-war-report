import 'package:equatable/equatable.dart';

import '../../models/api/response/war_log_response_model.dart';

class WarLogCache {
  final _cache = <WarLogCacheKeyModel, WarLogCacheValueModel>{};

  WarLogCacheValueModel? get(WarLogCacheKeyModel term) => _cache[term];

  void set(WarLogCacheKeyModel term, WarLogCacheValueModel result) =>
      _cache[term] = result;

  bool contains(WarLogCacheKeyModel term) => _cache.containsKey(term);

  void remove(WarLogCacheKeyModel term) => _cache.remove(term);
}

class WarLogCacheKeyModel extends Equatable {
  const WarLogCacheKeyModel({
    this.clanTag,
  });

  final String? clanTag;

  @override
  List<Object?> get props => [clanTag];
}

class WarLogCacheValueModel {
  WarLogCacheValueModel({
    required this.items,
  });

  final List<WarLogItem> items;
}
