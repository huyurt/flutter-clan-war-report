import 'package:animate_do/animate_do.dart';
import "package:collection/collection.dart";
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kg_charts/kg_charts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/clan_league_group_response_model.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../clans_screen/player_detail_screen.dart';

class ClanLeagueWarsStats {
  ClanLeagueWarsStats({
    required this.stars,
    required this.totalStarCount,
  });

  final int stars;
  final int totalStarCount;
}

class LeagueWarDetailPlayersDetailScreen extends StatefulWidget {
  const LeagueWarDetailPlayersDetailScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clan,
    required this.member,
    required this.memberAttacks,
    required this.memberDefenceAttacks,
    required this.roundCount,
  });

  final String clanTag;
  final String warStartTime;
  final LeagueGroupClan? clan;
  final Member member;
  final List<Attack> memberAttacks;
  final List<Attack> memberDefenceAttacks;
  final int roundCount;

  @override
  State<LeagueWarDetailPlayersDetailScreen> createState() =>
      _LeagueWarDetailPlayersDetailScreenState();
}

class _LeagueWarDetailPlayersDetailScreenState
    extends State<LeagueWarDetailPlayersDetailScreen> {
  List<Widget> getStarsWidget(int stars) {
    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (var index = 0; index < stars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }
    for (var index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_3Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final warStartTime = DateTime.tryParse(widget.warStartTime);
    String season = '';
    if (warStartTime != null) {
      season = DateFormat.yMMMM().format(warStartTime);
    }

    final clan = widget.clan;
    final member = widget.member;
    final memberAttacks = widget.memberAttacks;
    final memberDefenceAttacks = widget.memberDefenceAttacks;

    final clanMemberTownHallLevel = (member.townhallLevel) > 11
        ? '${member.townhallLevel}.5'
        : (member.townhallLevel).toString();

    final groupedStars =
        groupBy(memberAttacks, (memberAttack) => memberAttack.stars);
    final stars = <ClanLeagueWarsStats>[];
    for (final star in groupedStars.keys) {
      stars.add(ClanLeagueWarsStats(
        stars: star ?? 0,
        totalStarCount: groupedStars[star]?.length ?? 0,
      ));
    }
    if (!stars.any((element) => element.stars == 0)) {
      stars.add(ClanLeagueWarsStats(
        stars: 0,
        totalStarCount: 0,
      ));
    }
    if (!stars.any((element) => element.stars == 1)) {
      stars.add(ClanLeagueWarsStats(
        stars: 1,
        totalStarCount: 0,
      ));
    }
    if (!stars.any((element) => element.stars == 2)) {
      stars.add(ClanLeagueWarsStats(
        stars: 2,
        totalStarCount: 0,
      ));
    }
    if (!stars.any((element) => element.stars == 3)) {
      stars.add(ClanLeagueWarsStats(
        stars: 3,
        totalStarCount: 0,
      ));
    }
    stars.sort((a, b) => b.stars.compareTo(a.stars));
    int totalStarCount = stars.sumBy((e) => e.totalStarCount);

    final groupedDefenceStars = groupBy(memberDefenceAttacks,
        (memberDefenceAttack) => memberDefenceAttack.stars);
    final defenceStars = <ClanLeagueWarsStats>[];
    for (final star in groupedDefenceStars.keys) {
      defenceStars.add(ClanLeagueWarsStats(
        stars: star ?? 0,
        totalStarCount: groupedDefenceStars[star]?.length ?? 0,
      ));
    }

    double averageStars =
        stars.sumBy((e) => e.totalStarCount * e.stars) / widget.roundCount;
    double averageDefenceStars =
        defenceStars.sumBy((e) => e.totalStarCount * e.stars) /
            widget.roundCount;
    double averageDestructionPercentage =
        memberAttacks.sumBy((e) => e.destructionPercentage ?? 0) /
            widget.roundCount;
    double averageAttackDuration =
        memberAttacks.sumBy((e) => e.duration ?? 0) / widget.roundCount;

    final clanAverageDuration =
        Duration(seconds: averageAttackDuration.floor());
    final durationLocale =
        DurationLocale.fromLanguageCode(context.locale.languageCode);
    final clanAverageDurationText = durationLocale != null
        ? printDuration(
            clanAverageDuration,
            abbreviated: true,
            conjugation: ' ',
            tersity: DurationTersity.second,
            upperTersity: DurationTersity.minute,
            locale: durationLocale,
          )
        : printDuration(
            clanAverageDuration,
            abbreviated: true,
            conjugation: ' ',
            tersity: DurationTersity.second,
            upperTersity: DurationTersity.minute,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${tr(LocaleKey.clanWarLeague)} - $season ${tr(LocaleKey.season)}'),
      ),
      body: ListView(
        key: PageStorageKey(widget.key),
        shrinkWrap: true,
        children: [
          Card(
            margin: EdgeInsetsDirectional.zero,
            elevation: 0.0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: InkWell(
              onTap: () {
                PlayerDetailScreen(
                  playerTag: member.tag,
                ).launch(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: SizedBox(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FadeIn(
                          animate: true,
                          duration: const Duration(milliseconds: 250),
                          child: Image.asset(
                            '${AppConstants.townHallsImagePath}$clanMemberTownHallLevel.png',
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              member.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: FadeInImage.assetNetwork(
                                  height: 18,
                                  width: 18,
                                  image: clan?.badgeUrls?.large ??
                                      AppConstants.placeholderImage,
                                  placeholder: AppConstants.placeholderImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                clan?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 32.0,
              children: [
                ...stars.map((star) {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          ...getStarsWidget(star.stars),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          children: [
                            Text(star.totalStarCount.toString()),
                            Text(
                              ' (%${(star.totalStarCount / totalStarCount * 100).toStringAsFixed(2).padLeft(2, '0')})',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                            '${memberAttacks.length}/${widget.roundCount}'),
                      ),
                      Text(
                        tr(LocaleKey.attacksUsed),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '${averageStars.toStringAsFixed(2).padLeft(2, '0')} '),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 12,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ),
                      Text(
                        tr(LocaleKey.averageStars),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                            '%${averageDestructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                      ),
                      Text(
                        tr(LocaleKey.averageDestruction),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(clanAverageDurationText),
                      ),
                      Text(
                        tr(LocaleKey.averageAttackDuration),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '${averageDefenceStars.toStringAsFixed(2).padLeft(2, '0')} '),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 12,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ),
                      Text(
                        tr(LocaleKey.averageDefence),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: RadarWidget(
                    skewing: 0,
                    radarMap: RadarMapModel(
                      legend: [
                        LegendModel('', Colors.amber),
                      ],
                      indicator: [
                        IndicatorModel(tr(LocaleKey.star), 3),
                        IndicatorModel(tr(LocaleKey.destruction), 100),
                        IndicatorModel(tr(LocaleKey.reliability),
                            widget.roundCount.floorToDouble()),
                        IndicatorModel(tr(LocaleKey.speed), 180),
                        IndicatorModel(tr(LocaleKey.defence), 3),
                      ],
                      data: [
                        MapDataModel([
                          averageStars,
                          averageDestructionPercentage,
                          memberAttacks.length.floorToDouble(),
                          averageAttackDuration,
                          (3 - averageDefenceStars),
                        ]),
                      ],
                      radius: 100,
                      shape: Shape.square,
                      maxWidth: 75,
                      line: LineModel(4),
                    ),
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    isNeedDrawLegend: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
