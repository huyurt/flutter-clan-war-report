import 'package:more_useful_clash_of_clans/services/coc/coc_api_connector.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/api/search_clans_request_model.dart';
import '../../models/api/search_clans_response_model.dart';

class CocApiClans {
  static Future<SearchClansResponseModel>? searchClans(
      SearchClansRequestModel input) async {
    Map<String, dynamic> parameters = {
      'limit': 20,
      'name': input.clanName,
      'minMembers': input.minMembers,
      'maxMembers': input.maxMembers,
      'minClanLevel': input.minClanLevel,
    };
    if (!input.after.isEmptyOrNull) {
      parameters['after'] = input.after;
    }
    if (!input.before.isEmptyOrNull) {
      parameters['before'] = input.before;
    }

    final response = await CocApi.dio().get(
      '/clans',
      queryParameters: parameters,
    );
    SearchClansResponseModel result =
        SearchClansResponseModel.fromJson(response.data);
    return result;
  }
}
