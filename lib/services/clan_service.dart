import 'package:async/async.dart';
import 'package:clan_war_report/services/coc_api/coc_api_clans.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/api/response/clan_detail_response_model.dart';
import '../models/coc/clan_details_and_league_wars_model.dart';
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

  static Future<ClanDetailsAndLeagueWarsModel> getClanDetailsAndLeagueWars(
      String clanTag) async {
    final clanLeagueWars = <ClansCurrentWarStateModel>[];
    final clanLeague = await CocApiClans.getClanLeagueGroup(clanTag);
    final rounds = clanLeague.rounds
        .where((element) =>
            (element.warTags?.isNotEmpty ?? false) &&
            (element.warTags?.any((e2) => e2 != '#0') ?? false))
        .toList();

    final futureGroupWars = FutureGroup();
    for (final round in rounds) {
      for (String warTag in (round.warTags ?? <String>[])) {
        futureGroupWars.add(CocApiClans.getClanLeagueGroupWar(clanTag, warTag));
      }
    }
    futureGroupWars.close();

    final allResponseWars = await futureGroupWars.future;
    for (final responseWar in allResponseWars) {
      clanLeagueWars.add(responseWar);
    }

    final otherClanTags = clanLeagueWars.map((w) => w.war.clan.tag).toList();
    otherClanTags.addAll(clanLeagueWars.map((w) => w.war.opponent.tag));
    otherClanTags.toSet().toList();
    final otherClanDetails = <ClanDetailResponseModel>[];
    final futureGroupDetails = FutureGroup();
    for (final otherClanTag in otherClanTags) {
      if (otherClanTag.isEmptyOrNull || otherClanTag == clanTag) {
        continue;
      }
      futureGroupDetails.add(CocApiClans.getClanDetail(otherClanTag ?? ''));
    }
    futureGroupDetails.close();

    final allResponseDetails = await futureGroupDetails.future;
    for (final responseDetail in allResponseDetails) {
      otherClanDetails.add(responseDetail);
    }

    return ClanDetailsAndLeagueWarsModel(
      rounds: clanLeague.rounds.length,
      otherClans: otherClanDetails,
      clanLeague: clanLeague,
      clanLeagueWars: clanLeagueWars,
    );
  }
}
