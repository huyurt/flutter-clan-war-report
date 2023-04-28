import 'package:more_useful_clash_of_clans/utils/constants/app_constants.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_type_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/api/clan_detail_response_model.dart';
import '../../models/api/clan_league_group_response_model.dart';
import '../../models/api/clan_war_and_war_type_response_model.dart';
import '../../models/api/clan_war_response_model.dart';
import '../../models/api/search_clans_request_model.dart';
import '../../models/api/search_clans_response_model.dart';
import 'coc_api_connector.dart';

class CocApiClans {
  static Future<SearchClansResponseModel> searchClans(
      SearchClansRequestModel input) async {
    Map<String, dynamic> parameters = {
      'limit': AppConstants.pageSize,
      'name': input.clanName,
    };
    if (input.minMembers! > 1) {
      parameters['minMembers'] = input.minMembers;
    }
    if (input.maxMembers! > 0 && input.maxMembers! < 50) {
      parameters['maxMembers'] = input.maxMembers;
    }
    if (input.minClanLevel! > 1) {
      parameters['minClanLevel'] = input.minClanLevel;
    }
    if (!input.after.isEmptyOrNull) {
      parameters['after'] = input.after;
    }
    if (!input.before.isEmptyOrNull) {
      parameters['before'] = input.before;
    }

    final response = await CocApiConnector.dio.get(
      '/clans',
      queryParameters: parameters,
    );
    final result = SearchClansResponseModel.fromJson(response.data);
    return result;
  }

  static Future<ClanDetailResponseModel> getClanDetail(String clanTag) async {
    final response = await CocApiConnector.dio.get(
      '/clans/${Uri.encodeComponent(clanTag)}',
    );
    final result = ClanDetailResponseModel.fromMap(response.data);
    return result;
  }

  static Future<ClanWarAndWarTypeResponseModel> getClanCurrentWar(
      String clanTag) async {
    final response = await CocApiConnector.dio.get(
      '/clans/${Uri.encodeComponent(clanTag)}/currentwar',
    );
    final result = ClanWarResponseModel.fromMap(response.data);
    return ClanWarAndWarTypeResponseModel(
      warType: WarTypeEnum.clanWar,
      clanTag: clanTag,
      clanWarResponseModel: result,
    );
  }

  static Future<ClanLeagueGroupResponseModel> getClanLeagueGroup(
      String clanTag) async {
    final response = await CocApiConnector.dio.get(
      '/clans/${Uri.encodeComponent(clanTag)}/currentwar/leaguegroup',
    );
    final result = ClanLeagueGroupResponseModel.fromMap(response.data);
    return result;
  }

  static Future<ClanWarAndWarTypeResponseModel> getClanLeagueGroupWar(
      String clanTag, String warTag) async {
    final response = await CocApiConnector.dio.get(
      '/clanwarleagues/wars/${Uri.encodeComponent(warTag)}',
    );
    final result = ClanWarResponseModel.fromMap(response.data);
    return ClanWarAndWarTypeResponseModel(
      warType: WarTypeEnum.leagueWar,
      warTag: warTag,
      clanTag: clanTag,
      clanWarResponseModel: result,
    );
  }
}
