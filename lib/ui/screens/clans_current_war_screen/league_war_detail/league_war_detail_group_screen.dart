import "package:collection/collection.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_league_enum.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/enum_helper.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/api/response/clan_league_group_response_model.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/league_state_enum.dart';
import '../../../../utils/enums/war_winning_enum.dart';
import 'league_war_detail_group_detail_screen.dart';

class ClanLeagueWarsStats {
  ClanLeagueWarsStats({
    required this.clanTag,
    required this.stars,
    required this.destructionPercentage,
    required this.clan,
  });

  final String? clanTag;
  final int stars;
  final int destructionPercentage;
  final WarClan? clan;
}

class LeagueWarDetailGroupScreen extends StatefulWidget {
  const LeagueWarDetailGroupScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clanDetail,
    required this.otherClans,
    required this.clanLeague,
    required this.clanLeagueWars,
    required this.totalRoundCount,
    required this.refreshCallback,
  });

  final String clanTag;
  final String warStartTime;
  final ClanDetailResponseModel clanDetail;
  final List<ClanDetailResponseModel> otherClans;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;
  final int totalRoundCount;
  final VoidCallback refreshCallback;

  @override
  State<LeagueWarDetailGroupScreen> createState() =>
      _LeagueWarDetailGroupScreenState();
}

class _LeagueWarDetailGroupScreenState
    extends State<LeagueWarDetailGroupScreen> {
  Future<void> _refresh() async {
    widget.refreshCallback();
  }

  @override
  Widget build(BuildContext context) {
    final warStartTime = DateTime.tryParse(widget.warStartTime);
    String season = '';
    if (warStartTime != null) {
      season = DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(warStartTime);
    }
    final clanDetail = widget.clanDetail;

    final winSeries = <String?, List<WarWinningEnum>>{};
    final stats = <WarClan>[];
    for (final warModel in widget.clanLeagueWars) {
      final war = warModel.war;

      winSeries[war.clan.tag] ??= List<WarWinningEnum>.generate(
          widget.totalRoundCount, (i) => WarWinningEnum.notStarted);
      winSeries[war.opponent.tag] ??= List<WarWinningEnum>.generate(
          widget.totalRoundCount, (i) => WarWinningEnum.notStarted);

      stats.add(war.clan);
      stats.add(war.opponent);
    }

    final groupByClan = groupBy(stats, (war) => war.tag);
    final clanTags = groupByClan.keys;
    int gameCountPerRound = (clanTags.length / 2).round();

    int gameIndex = 0;
    for (int warIndex = 0;
        warIndex < widget.clanLeagueWars.length;
        warIndex++) {
      final war = widget.clanLeagueWars[warIndex].war;

      if (warIndex > 0 && warIndex % gameCountPerRound == 0) {
        gameIndex += 1;
      }

      if (war.state == WarStateEnum.warEnded.name) {
        bool clanWon = false;
        if (war.clan.stars > war.opponent.stars) {
          clanWon = true;
        } else if (war.clan.stars == war.opponent.stars &&
            war.clan.destructionPercentage >
                war.opponent.destructionPercentage) {
          clanWon = true;
        }
        winSeries[war.clan.tag]?[gameIndex] =
            clanWon ? WarWinningEnum.won : WarWinningEnum.lost;
        winSeries[war.opponent.tag]?[gameIndex] =
            !clanWon ? WarWinningEnum.won : WarWinningEnum.lost;
      } else if (war.state == WarStateEnum.inWar.name) {
        final clanWinning = war.clan.stars > war.opponent.stars ||
            (war.clan.stars == war.opponent.stars &&
                war.clan.destructionPercentage >
                    war.opponent.destructionPercentage);
        final equal = war.clan.stars == war.opponent.stars &&
            war.clan.destructionPercentage ==
                war.opponent.destructionPercentage;

        if (equal) {
          winSeries[war.clan.tag]?[gameIndex] = WarWinningEnum.equal;
          winSeries[war.opponent.tag]?[gameIndex] = WarWinningEnum.equal;
        } else {
          winSeries[war.clan.tag]?[gameIndex] =
              clanWinning ? WarWinningEnum.winning : WarWinningEnum.losing;
          winSeries[war.opponent.tag]?[gameIndex] =
              !clanWinning ? WarWinningEnum.winning : WarWinningEnum.losing;
        }
      } else {
        winSeries[war.clan.tag]?[gameIndex] = WarWinningEnum.notStarted;
        winSeries[war.opponent.tag]?[gameIndex] = WarWinningEnum.notStarted;
      }
    }

    final warPlayerCount =
        widget.clanLeagueWars.first.war.clan.members?.length ?? 0;
    final totals = <ClanLeagueWarsStats>[];
    for (String? clanTag in clanTags) {
      final clanStats = groupByClan[clanTag];
      int winCount =
          winSeries[clanTag]?.where((ws) => ws == WarWinningEnum.won).length ??
              0;
      int? totalStars = clanStats?.fold(
          0, (previousValue, element) => (previousValue ?? 0) + element.stars);
      double? totalDestructionPercentages = clanStats?.fold(
          0,
          (previousValue, element) =>
              (previousValue ?? 0) + element.destructionPercentage);
      totals.add(ClanLeagueWarsStats(
          clanTag: clanTag,
          stars: (totalStars ?? 0) + winCount * 10,
          destructionPercentage:
              ((totalDestructionPercentages ?? 0) * warPlayerCount).round(),
          clan: clanStats?.first));
    }
    totals.sort((a, b) => <Comparator<ClanLeagueWarsStats>>[
          (o1, o2) => o2.stars.compareTo(o1.stars),
          (o1, o2) =>
              o2.destructionPercentage.compareTo(o1.destructionPercentage),
        ].map((e) => e(a, b)).firstWhere((e) => e != 0, orElse: () => 0));

    int lastWarLeagueId = clanDetail.warLeague?.id ?? 0;
    final warLeague = EnumHelper.getWarLeagueById(lastWarLeagueId);
    final warEnded = widget.clanLeague.state == LeagueStateEnum.ended.name;
    final clanOrder =
        totals.indexWhere((element) => element.clanTag == clanDetail.tag) + 1;
    if (warEnded) {
      if (warLeague == WarLeagueEnum.values.last) {
        if (clanOrder == 1) {
          final secondClan =
              widget.otherClans.firstWhere((c) => c.tag == totals[1].clanTag);
          if (secondClan.warLeague?.id == lastWarLeagueId - 1) {
            lastWarLeagueId -= 1;
          }
        }
      } else if (warLeague == WarLeagueEnum.values[1]) {
        final firstClan =
            widget.otherClans.firstWhere((c) => c.tag == totals.first.clanTag);
        if (firstClan.warLeague?.id == lastWarLeagueId + 2) {
          lastWarLeagueId += 1;
        }
      } else {
        if (clanOrder == 1) {
          lastWarLeagueId -= 1;
        } else if (clanOrder == totals.length) {
          lastWarLeagueId += 1;
        } else {
          final firstClan = widget.otherClans
              .firstWhere((c) => c.tag == totals.first.clanTag);
          if (firstClan.warLeague?.id == lastWarLeagueId + 2) {
            lastWarLeagueId += 1;
          } else if (firstClan.warLeague?.id == lastWarLeagueId) {
            lastWarLeagueId -= 1;
          }
        }
      }
    }

    final lastWarLeague = EnumHelper.getWarLeagueById(lastWarLeagueId);
    final lastWarLeagueResult = EnumHelper.getLeagueResult(lastWarLeague);

    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: _refresh,
      child: ListView(
        key: PageStorageKey(widget.key),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((clanDetail.warLeague?.id ?? 0) >
                    AppConstants.warLeagueUnranked)
                  Image.asset(
                    '${AppConstants.clanWarLeaguesImagePath}$lastWarLeagueId.png',
                    height: 64,
                    fit: BoxFit.cover,
                  )
                else if (clanDetail.warLeague?.id ==
                    AppConstants.warLeagueUnranked)
                  Image.asset(
                    '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    ' ${tr('warLeague$lastWarLeagueId')}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '$season ${tr(LocaleKey.season)}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
          ...totals.map(
            (total) {
              final clan = total.clan;
              return Card(
                margin: EdgeInsets.zero,
                elevation: 0.0,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: InkWell(
                  onTap: () {
                    LeagueWarDetailGroupDetailScreen(
                      clanTag: clan?.tag ?? '',
                      warStartTime: widget.warStartTime,
                      clan: clan,
                      clanLeagueWars: widget.clanLeagueWars
                          .where((warModel) =>
                              warModel.war.clan.tag == clan?.tag ||
                              warModel.war.opponent.tag == clan?.tag)
                          .toList(),
                    ).launch(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 4.0),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          totals.indexOf(total) + 1 <=
                                  lastWarLeagueResult.promoted
                              ? const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 24.0,
                                  color: Colors.green,
                                )
                              : (totals.indexOf(total) + 1 >
                                      totals.length -
                                          lastWarLeagueResult.demoted
                                  ? const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 24.0,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 24.0,
                                      color: Colors.transparent,
                                    )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text('${totals.indexOf(total) + 1}. '),
                          ),
                          FadeInImage.assetNetwork(
                            height: 45.0,
                            width: 45.0,
                            image: clan?.badgeUrls.large ??
                                AppConstants.placeholderImage,
                            placeholder: AppConstants.placeholderImage,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      clan?.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          height: 1.2, fontSize: 14.0),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      ...winSeries[total.clanTag]?.map(
                                            (win) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0,
                                                    left: 2.0,
                                                    right: 2.0),
                                                child: Container(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: win ==
                                                            WarWinningEnum
                                                                .notStarted
                                                        ? Colors.black38
                                                        : win ==
                                                                WarWinningEnum
                                                                    .winning
                                                            ? Colors.lightGreen
                                                                .shade200
                                                            : (win ==
                                                                    WarWinningEnum
                                                                        .losing
                                                                ? Colors.red
                                                                    .shade200
                                                                : (win ==
                                                                        WarWinningEnum
                                                                            .equal
                                                                    ? Colors
                                                                        .yellow
                                                                        .shade200
                                                                    : (win ==
                                                                            WarWinningEnum
                                                                                .won
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red))),
                                                  ),
                                                ),
                                              );
                                            },
                                          ) ??
                                          <Widget>[],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 80,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${total.stars} '),
                                      Image.asset(
                                        '${AppConstants.clashResourceImagePath}${AppConstants.star2Image}',
                                        height: 14,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 80,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          '%${(total.destructionPercentage).toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
