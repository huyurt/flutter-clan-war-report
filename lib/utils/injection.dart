import 'package:get_it/get_it.dart';

import '../repositories/search_clan/search_clan_filter_cache.dart';

final locator = GetIt.instance;

void init() {
  locator.registerSingleton(SearchClanFilterCache());
}
