import 'package:async/async.dart';

import '../../models/coc/clans_current_war_state_model.dart';
import '../../services/coc_api/coc_api_clans.dart';
import '../../utils/enums/war_state_enum.dart';
import 'bookmarked_clans_current_war_cache.dart';

class BookmarkedClansCurrentWarRepository {
  const BookmarkedClansCurrentWarRepository({required this.cache});

  final BookmarkedClansCurrentWarCache cache;

  List<String> getClanTags() => cache.getKeys();

  ClansCurrentWarStateModel? getClanCurrentWar(String clanTag) {
    return cache.get(clanTag);
  }

  List<ClansCurrentWarStateModel?> getClansCurrentWar() {
    final clansCurrentWar = cache.getValues();
    return List.from(clansCurrentWar);
  }

  bool contains(String clanTag) {
    return cache.contains(clanTag);
  }

  void addOrUpdateBookmarkedClansCurrentWar(
      String clanTag, ClansCurrentWarStateModel? clanCurrentWar) {
    cache.addOrUpdate(clanTag, clanCurrentWar);
  }

  void removeBookmarkedClanCurrentWar(String clanTag) => cache.remove(clanTag);

  void cleanRemovedClanTags(List<String> newClanTagList) {
    final removedClanTags = getClanTags()
        .where((element) => !newClanTagList.contains(element))
        .toList();
    for (final clanTag in removedClanTags) {
      removeBookmarkedClanCurrentWar(clanTag);
    }
  }

  Future fetchClanCurrentWar(String clanTag) async {
    addOrUpdateBookmarkedClansCurrentWar(clanTag, null);

    ClansCurrentWarStateModel? clanCurrentWar;

    // Fetch current clan war
    try {
      clanCurrentWar = await CocApiClans.getClanCurrentWar(clanTag);
    } catch (error) {
      // ignored, fix here
    }

    if (clanCurrentWar == null ||
        clanCurrentWar.war.state == WarStateEnum.notInWar.name) {
      // Fetch clan league wars
      final lastClanLeague = await CocApiClans.getClanLeagueGroup(clanTag);

      int notStartedRoundIndex = lastClanLeague.rounds
          .indexWhere((r) => r.warTags?.contains('#0') ?? false);
      int lastRoundIndex = notStartedRoundIndex > 0
          ? (notStartedRoundIndex - 1)
          : (lastClanLeague.rounds.length - 1);

      if (lastRoundIndex == 0) {
        final round = lastClanLeague.rounds[lastRoundIndex];
        final warTag = round.warTags?.first;
        if (warTag != null) {
          clanCurrentWar = await getClanLeagueWarInRound(clanTag, [warTag]);
          addOrUpdateBookmarkedClansCurrentWar(clanTag, clanCurrentWar);
        }
      } else {
        final round1 = lastClanLeague.rounds[lastRoundIndex - 1];
        clanCurrentWar = await getClanLeagueWarInRound(
            clanTag, (round1.warTags ?? <String>[]));
        if (clanCurrentWar.war.state == WarStateEnum.warEnded.name) {
          final round2 = lastClanLeague.rounds[lastRoundIndex];
          clanCurrentWar = await getClanLeagueWarInRound(
              clanTag, (round2.warTags ?? <String>[]));
        }
        addOrUpdateBookmarkedClansCurrentWar(clanTag, clanCurrentWar);
      }
    } else {
      addOrUpdateBookmarkedClansCurrentWar(clanTag, clanCurrentWar);
    }
  }

  Future<ClansCurrentWarStateModel> getClanLeagueWarInRound(
      String clanTag, List<String> warTags) async {
    final clanLeagueWars = <ClansCurrentWarStateModel>[];
    final futureGroup = FutureGroup();
    for (final warTag in warTags) {
      futureGroup.add(CocApiClans.getClanLeagueGroupWar(clanTag, warTag));
    }
    futureGroup.close();

    final allResponse = await futureGroup.future;
    for (final response in allResponse) {
      clanLeagueWars.add(response);
    }
    return clanLeagueWars.firstWhere(
        (e) => e.war.clan.tag == clanTag || e.war.opponent.tag == clanTag);
  }
}
