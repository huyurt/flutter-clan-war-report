import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import "package:collection/collection.dart";
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphic/graphic.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_league_group_response_model.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clan_league_wars_stat_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/helpers/image_helper.dart';
import '../../../widgets/app_widgets/rank_image.dart';
import '../../../widgets/app_widgets/star_stats_widget.dart';
import '../../clans_screen/search_clan_screen/player_detail_screen.dart';

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
  final LeagueGroupMember member;
  final List<Attack> memberAttacks;
  final List<Attack> memberDefenceAttacks;
  final int roundCount;

  @override
  State<LeagueWarDetailPlayersDetailScreen> createState() =>
      _LeagueWarDetailPlayersDetailScreenState();
}

class _LeagueWarDetailPlayersDetailScreenState
    extends State<LeagueWarDetailPlayersDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Colors.white60
            : Colors.black26;
    final warStartTime = DateTime.tryParse(widget.warStartTime);
    String season = '';
    if (warStartTime != null) {
      season = DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(warStartTime);
    }

    final clan = widget.clan;
    final member = widget.member;
    final memberAttacks = widget.memberAttacks;
    final memberDefenceAttacks = widget.memberDefenceAttacks;

    final clanMemberTownHallLevel =
        ImageHelper.getTownhallImage(member.townHallLevel, 1);

    final notUsedAttackCount = widget.roundCount - memberAttacks.length;
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
    if (notUsedAttackCount > 0) {
      final zeroStars = stars.firstWhere((element) => element.stars == 0);
      zeroStars.totalStarCount += notUsedAttackCount;
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

    double averageStars = 0;
    double averageDefenceStars = 0;
    double averageDestructionPercentage = 0;
    double averageAttackDuration = 0;
    if (widget.roundCount != 0) {
      averageStars =
          stars.sumBy((e) => e.totalStarCount * e.stars) / widget.roundCount;
      averageDefenceStars =
          defenceStars.sumBy((e) => e.totalStarCount * e.stars) /
              widget.roundCount;
      averageDestructionPercentage =
          memberAttacks.sumBy((e) => e.destructionPercentage ?? 0) /
              widget.roundCount;
      averageAttackDuration = (widget.roundCount - notUsedAttackCount) == 0
          ? 0
          : memberAttacks.sumBy((e) => e.duration ?? 0) /
              (widget.roundCount - notUsedAttackCount);
    }

    var averageStats = [
      {'name': tr(LocaleKey.star), 'value': ((averageStars / 3) * 100).round()},
      {
        'name': tr(LocaleKey.destruction),
        'value': ((averageDestructionPercentage / 100) * 100).round(),
      },
      {
        'name': tr(LocaleKey.reliability),
        'value': widget.roundCount == 0
            ? 0
            : ((memberAttacks.length.floorToDouble() /
                        widget.roundCount.floorToDouble()) *
                    100)
                .round(),
      },
      {
        'name': tr(LocaleKey.speed),
        'value': widget.roundCount == 0
            ? 0
            : ((memberAttacks.isEmpty
                        ? 0
                        : (180 - averageAttackDuration.floor()) / 180) *
                    100)
                .round(),
      },
      {
        'name': tr(LocaleKey.defence),
        'value':
            ((widget.roundCount == 0 ? 0 : (3 - averageDefenceStars) / 3) * 100)
                .round(),
      },
    ];

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
            margin: EdgeInsets.zero,
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
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
                              style:
                                  const TextStyle(height: 1.2, fontSize: 18.0),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: RankImage(
                                  imageUrl: clan?.badgeUrls?.large,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              Text(
                                clan?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(height: 1.2),
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
          StarStatWidget(
            stars: stars,
            totalStarCount: totalStarCount,
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
                Visibility(
                  visible: widget.roundCount > 0,
                  child: SizedBox(
                    height: 300,
                    child: Chart(
                      rebuild: true,
                      data: averageStats,
                      variables: {
                        'name': Variable(
                          accessor: (Map map) => map['name'] as String,
                        ),
                        'value': Variable(
                          accessor: (Map map) => map['value'] as num,
                          scale: LinearScale(min: 0, max: 100),
                        ),
                      },
                      marks: [
                        IntervalMark(
                          label: LabelEncode(
                            encoder: (tuple) => Label(
                              '${tuple['name']} %${tuple['value']}',
                              LabelStyle(
                                textStyle: const TextStyle(
                                  fontFamily: 'Clash-Light',
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                          shape: ShapeEncode(
                            encoder: (tuple) => RectShape(
                              labelPosition: tuple['value'] > 50 ? 0.5 : 1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          color: ColorEncode(
                              variable: 'name', values: Defaults.colors10),
                          elevation: ElevationEncode(value: 5),
                          transition: Transition(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOutCirc),
                          entrance: {MarkEntrance.x, MarkEntrance.y},
                        ),
                      ],
                      axes: [
                        Defaults.radialAxis,
                        Defaults.circularAxis..label = null,
                      ],
                      coord: PolarCoord(startRadius: 0.15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
