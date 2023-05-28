import 'package:flutter/material.dart';

import '../../models/api/request/search_clans_request_model.dart';
import '../../utils/constants/app_constants.dart';

class SearchClanFilterCache {
  late SearchClansRequestModel _cache = SearchClansRequestModel(
    clanName: '',
    locationId: -1,
    minMembers: AppConstants.minMembersFilter.round(),
    maxMembers: AppConstants.maxMembersFilter.round(),
    minClanLevel: AppConstants.minClanLevelFilter.round(),
  );

  SearchClansRequestModel get() => _cache;

  void set(SearchClansRequestModel result) => _cache = result;

  RangeValues getMembers() =>
      RangeValues(_cache.minMembers.toDouble(), _cache.maxMembers.toDouble());
}
