import 'package:equatable/equatable.dart';

import '../../../models/api/search_clans_response_model.dart';

class SearchClanCache {
  final _cache = <SearchClanCacheKeyModel, SearchClanCacheValueModel>{};

  SearchClanCacheValueModel? get(SearchClanCacheKeyModel term) => _cache[term];

  void set(SearchClanCacheKeyModel term, SearchClanCacheValueModel result) =>
      _cache[term] = result;

  bool contains(SearchClanCacheKeyModel term) => _cache.containsKey(term);

  void remove(SearchClanCacheKeyModel term) => _cache.remove(term);
}

class SearchClanCacheKeyModel extends Equatable {
  const SearchClanCacheKeyModel({
    this.clanName,
    this.minMembers,
    this.maxMembers,
    this.minClanLevel,
  });

  final String? clanName;
  final int? minMembers;
  final int? maxMembers;
  final int? minClanLevel;

  @override
  List<Object?> get props => [clanName, minMembers, maxMembers, minClanLevel];
}

class SearchClanCacheValueModel {
  SearchClanCacheValueModel({
    this.after,
    required this.items,
  });

  late String? after;
  final List<SearchedClanItem> items;
}
