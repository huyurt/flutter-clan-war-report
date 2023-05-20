import 'package:async/async.dart';
import 'package:more_useful_clash_of_clans/services/coc_api/coc_api_clans.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/api/response/clan_detail_response_model.dart';
import '../models/coc/clan_league_wars_model.dart';
import '../models/coc/clans_current_war_state_model.dart';
import '../models/coc/war_logs_model.dart';

class ClanService {
  static Future<ClanDetailResponseModel> getClanDetail(String clanTag) async {
    return await CocApiClans.getClanDetail(clanTag);
  }

  static Future<ClansCurrentWarStateModel> getCurrentWarDetail(
      String clanTag, String? warTag) async {
    if (warTag.isEmptyOrNull) {
      return await CocApiClans.getClanCurrentWar(clanTag);
    }
    return await CocApiClans.getClanLeagueGroupWar(clanTag, warTag!);
  }

  static Future<WarLogsModel> getWarLogs(String clanTag) async {
    final clan = await CocApiClans.getClanDetail(clanTag);
    final warLogData = await CocApiClans.getWarLog(clanTag);

    return WarLogsModel(
      clan: clan,
      warLogs: warLogData.items,
    );
  }

  static Future<ClanLeagueWarsModel> getClanLeagueWars(String clanTag) async {
    final clanLeagueWars = <ClansCurrentWarStateModel>[];
    final clanLeague = await CocApiClans.getClanLeagueGroup(clanTag);
    final rounds = clanLeague.rounds
        .where((element) =>
            (element.warTags?.isNotEmpty ?? false) &&
            (element.warTags?.any((e2) => e2 != '#0') ?? false))
        .toList();

    final futureGroup = FutureGroup();
    for (final round in rounds) {
      for (String warTag in (round.warTags ?? <String>[])) {
        futureGroup.add(CocApiClans.getClanLeagueGroupWar(clanTag, warTag));
      }
    }
    futureGroup.close();

    final allResponse = await futureGroup.future;
    for (final response in allResponse) {
      clanLeagueWars.add(response);
    }

    return ClanLeagueWarsModel(
      rounds: clanLeague.rounds.length,
      clanLeague: clanLeague,
      clanLeagueWars: clanLeagueWars,
    );
  }
}
