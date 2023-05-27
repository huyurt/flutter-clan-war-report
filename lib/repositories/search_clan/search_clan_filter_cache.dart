import '../../models/api/request/search_clans_request_model.dart';

class SearchClanFilterCache {
  late SearchClansRequestModel? _cache = null;

  SearchClansRequestModel? get() => _cache;

  void set(SearchClansRequestModel? result) => _cache = result;
}
