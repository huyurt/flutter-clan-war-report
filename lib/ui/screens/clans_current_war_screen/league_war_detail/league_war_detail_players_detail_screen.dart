import 'package:animate_do/animate_do.dart';
import "package:collection/collection.dart";
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_league_group_response_model.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../clans_screen/search_clan_screen/player_detail_screen.dart';

class ClanLeagueWarsStats {
  ClanLeagueWarsStats({
    required this.stars,
    required this.totalStarCount,
  });

  final int stars;
  late int totalStarCount;
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
      season = DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(warStartTime);
    }

    final clan = widget.clan;
    final member = widget.member;
    final memberAttacks = widget.memberAttacks;
    final memberDefenceAttacks = widget.memberDefenceAttacks;

    final clanMemberTownHallLevel = (member.townHallLevel) > 11
        ? '${member.townHallLevel}.5'
        : (member.townHallLevel).toString();

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
      averageAttackDuration = memberAttacks.sumBy((e) => e.duration ?? 0) /
          (widget.roundCount - notUsedAttackCount);
    }

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
                              ' (%${totalStarCount == 0 ? 0 : (star.totalStarCount / totalStarCount * 100).toStringAsFixed(2).padLeft(2, '0')})',
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
                  padding: const EdgeInsets.only(top: 24.0),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: RadarChart(
                      RadarChartData(
                        dataSets: [
                          RadarDataSet(
                            fillColor: Colors.amber.withOpacity(0.5),
                            borderColor: Colors.amber,
                            dataEntries: [
                              RadarEntry(value: averageStars / 3),
                              RadarEntry(
                                  value: averageDestructionPercentage / 100),
                              RadarEntry(
                                  value: memberAttacks.length.floorToDouble() /
                                      widget.roundCount.floorToDouble()),
                              RadarEntry(
                                  value: (180 - averageAttackDuration.floor()) /
                                      180),
                              RadarEntry(value: (3 - averageDefenceStars) / 3),
                            ],
                          ),
                        ],
                        radarShape: RadarShape.polygon,
                        tickCount: 3,
                        ticksTextStyle:
                            const TextStyle(color: Colors.transparent),
                        radarBorderData:
                            const BorderSide(color: Colors.white60),
                        tickBorderData: const BorderSide(color: Colors.white60),
                        gridBorderData: const BorderSide(color: Colors.white60),
                        getTitle: (index, angle) {
                          final usedAngle = angle;
                          switch (index) {
                            case 0:
                              return RadarChartTitle(
                                text: tr(LocaleKey.star),
                                angle: usedAngle,
                              );
                            case 1:
                              return RadarChartTitle(
                                text: tr(LocaleKey.destruction),
                                angle: usedAngle,
                              );
                            case 2:
                              return RadarChartTitle(
                                text: tr(LocaleKey.reliability),
                                angle: usedAngle,
                              );
                            case 3:
                              return RadarChartTitle(
                                text: tr(LocaleKey.speed),
                                angle: usedAngle,
                              );
                            case 4:
                              return RadarChartTitle(
                                text: tr(LocaleKey.defence),
                                angle: usedAngle,
                              );
                            default:
                              return const RadarChartTitle(text: '');
                          }
                        },
                      ),
                    ),
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
