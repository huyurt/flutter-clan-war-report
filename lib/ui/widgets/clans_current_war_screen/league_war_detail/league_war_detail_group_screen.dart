import "package:collection/collection.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_league_enum.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/enum_helper.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/clan_detail_response_model.dart';
import '../../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
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
  final Clan? clan;
}

class LeagueWarDetailGroupScreen extends StatefulWidget {
  const LeagueWarDetailGroupScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clanDetail,
    required this.clanLeagueWars,
    required this.totalRoundCount,
  });

  final String clanTag;
  final String warStartTime;
  final ClanDetailResponseModel clanDetail;
  final List<ClanWarAndWarTypeResponseModel> clanLeagueWars;
  final int totalRoundCount;

  @override
  State<LeagueWarDetailGroupScreen> createState() =>
      _LeagueWarDetailGroupScreenState();
}

class _LeagueWarDetailGroupScreenState
    extends State<LeagueWarDetailGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final warStartTime = DateTime.tryParse(widget.warStartTime);
    String season = '';
    if (warStartTime != null) {
      season = DateFormat.yMMMM().format(warStartTime);
    }
    final clanDetail = widget.clanDetail;

    final winSeries = <String?, List<bool?>>{};
    final stats = <Clan>[];
    for (final warModel in widget.clanLeagueWars) {
      final war = warModel.clanWarResponseModel;

      winSeries[war.clan.tag] ??=
          List<bool?>.generate(widget.totalRoundCount, (i) => null);
      winSeries[war.opponent.tag] ??=
          List<bool?>.generate(widget.totalRoundCount, (i) => null);

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
      final war = widget.clanLeagueWars[warIndex].clanWarResponseModel;

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
        winSeries[war.clan.tag]?[gameIndex] = clanWon;
        winSeries[war.opponent.tag]?[gameIndex] = !clanWon;
      } else {
        winSeries[war.clan.tag]?[gameIndex] = null;
        winSeries[war.opponent.tag]?[gameIndex] = null;
      }
    }

    final warPlayerCount = widget.clanLeagueWars.first.clanWarResponseModel.clan.members?.length ?? 0;
    final totals = <ClanLeagueWarsStats>[];
    for (String? clanTag in clanTags) {
      final clanStats = groupByClan[clanTag];
      int winCount =
          winSeries[clanTag]?.where((element) => element == true).length ?? 0;
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

    int warLeagueId = clanDetail.warLeague?.id ?? 0;
    if (warLeagueId > AppConstants.warLeagueUnranked) {
      final warEnded =
          !(winSeries[clanDetail.tag]?.any((element) => element == null) ??
              true);
      if (warEnded) {
        final clanOrder =
            totals.indexWhere((element) => element.clanTag == clanDetail.tag) +
                1;
        final currentWarLeague = EnumHelper.getWarLeagueById(warLeagueId);
        if (currentWarLeague == WarLeagueEnum.values[1]) {
          if (clanOrder > totals.length - 3) {
            // Birincinin detayını çek.
            // Birinci Bronz 1'de ise baktığım klan 2'den düşmüştür. Birinci Bronz 2'de ise baktığım klan 3'deymiş.
          }
        } else if (currentWarLeague == WarLeagueEnum.values.last) {}

        if (clanOrder == 1) {
          //warLeagueId = (clanDetail.warLeague?.id ?? 1) - 1;
        }
      }
    }

    return ListView(
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
                  '${AppConstants.clanWarLeaguesImagePath}$warLeagueId.png',
                  height: 72,
                  fit: BoxFit.cover,
                )
              else if (clanDetail.warLeague?.id ==
                  AppConstants.warLeagueUnranked)
                Image.asset(
                  '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                  height: 72,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  ' ${tr('warLeague$warLeagueId')}',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '$season ${tr(LocaleKey.season)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        ...totals.map(
          (total) {
            final clan = total.clan;
            return Card(
              margin: EdgeInsetsDirectional.zero,
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
                            warModel.clanWarResponseModel.clan.tag ==
                                clan?.tag ||
                            warModel.clanWarResponseModel.opponent.tag ==
                                clan?.tag)
                        .toList(),
                  ).launch(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('${totals.indexOf(total) + 1}. '),
                        ),
                        FadeInImage.assetNetwork(
                          height: 55,
                          width: 55,
                          image: clan?.badgeUrls.large ??
                              AppConstants.placeholderImage,
                          placeholder: AppConstants.placeholderImage,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    clan?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  children: [
                                    ...winSeries[total.clanTag]?.map((win) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Container(
                                              height: 10.0,
                                              width: 10.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                color: win == null
                                                    ? Colors.black38
                                                    : win == true
                                                        ? Colors.lightGreen
                                                        : Colors.redAccent,
                                              ),
                                            ),
                                          );
                                        }) ??
                                        <Widget>[],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: 70,
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
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: 75,
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
      ],
    );
  }
}
