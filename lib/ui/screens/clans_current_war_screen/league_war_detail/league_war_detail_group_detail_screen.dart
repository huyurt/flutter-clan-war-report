import "package:collection/collection.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_state_enum.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../../widgets/countdown_timer/countdown_timer_widget.dart';
import '../../clans_screen/search_clan_screen/clan_detail_screen.dart';
import '../war_detail/war_detail_screen.dart';

class ClanLeagueWarsStats {
  ClanLeagueWarsStats({
    required this.stars,
    required this.totalStarCount,
  });

  final int stars;
  final int totalStarCount;
}

class LeagueWarDetailGroupDetailScreen extends StatefulWidget {
  const LeagueWarDetailGroupDetailScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clan,
    required this.clanLeagueWars,
  });

  final String clanTag;
  final String warStartTime;
  final WarClan? clan;
  final List<ClansCurrentWarStateModel> clanLeagueWars;

  @override
  State<LeagueWarDetailGroupDetailScreen> createState() =>
      _LeagueWarDetailGroupDetailScreenState();
}

class _LeagueWarDetailGroupDetailScreenState
    extends State<LeagueWarDetailGroupDetailScreen> {
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

    final stats = <WarClan>[];
    for (final warModel in widget.clanLeagueWars) {
      final war = warModel.war;
      if (war.clan.tag == widget.clanTag) {
        stats.add(war.clan);
      } else {
        stats.add(war.opponent);
      }
    }

    final attacks = <Attack?>[];
    for (final stat in stats) {
      stat.members?.forEach((e) {
        attacks.addAll(e.attacks ?? <Attack>[]);
      });
    }
    final groupedStars = groupBy(attacks, (attack) => attack?.stars);

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
                ClanDetailScreen(
                  viewWarButton: false,
                  clanTag: widget.clanTag,
                ).launch(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FadeInImage.assetNetwork(
                        height: 75,
                        width: 75,
                        image: widget.clan?.badgeUrls.large ??
                            AppConstants.placeholderImage,
                        placeholder: AppConstants.placeholderImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            widget.clan?.name ?? '',
                            style: const TextStyle(fontSize: 24.0),
                          ),
                        ),
                        Text(widget.clan?.tag ?? ''),
                      ],
                    ),
                  ],
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
          ...widget.clanLeagueWars.map((warModel) {
            final war = warModel.war;
            WarClan clan;
            WarClan opponent;
            if (war.clan.tag == widget.clanTag) {
              clan = war.clan;
              opponent = war.opponent;
            } else {
              clan = war.opponent;
              opponent = war.clan;
            }

            final warState = WarStateEnum.values
                .firstWhere((element) => element.name == war.state);
            bool? clanWon = warState == WarStateEnum.warEnded
                ? (clan.stars > opponent.stars ||
                    (clan.stars == opponent.stars &&
                        clan.destructionPercentage >
                            opponent.destructionPercentage))
                : null;

            DateTime? remainingDateTime;
            final startTime = DateTime.tryParse(war.startTime ?? '');
            final warStartTime = DateTime.tryParse(war.warStartTime ?? '');
            final endTime = DateTime.tryParse(war.endTime ?? '');
            if (endTime != null && war.state == WarStateEnum.inWar.name) {
              remainingDateTime = endTime;
            } else if ((warStartTime != null || startTime != null) &&
                war.state == WarStateEnum.preparation.name) {
              remainingDateTime = warStartTime ?? startTime;
            }

            return Card(
              margin: EdgeInsetsDirectional.zero,
              elevation: 0.0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: InkWell(
                onTap: () {
                  WarDetailScreen(
                    clanTag: widget.clanTag,
                    warTag: warModel.warTag,
                    warType: WarTypeEnum.leagueWar,
                    warStartTime: widget.warStartTime,
                    clanName: clan.name ?? '',
                    opponentName: opponent.name ?? '',
                  ).launch(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInImage.assetNetwork(
                                height: 40,
                                width: 40,
                                image: clan.badgeUrls.large,
                                placeholder: AppConstants.placeholderImage,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                clan.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (remainingDateTime != null)
                                  CountdownTimerWidget(
                                    remainingDateTime: remainingDateTime,
                                  ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (warState == WarStateEnum.inWar ||
                                            warState ==
                                                WarStateEnum.warEnded) ...[
                                          Text(
                                            clan.stars.toString(),
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              color: clanWon == true
                                                  ? Colors.green
                                                  : (clanWon == false
                                                      ? Colors.redAccent
                                                      : null),
                                            ),
                                          ),
                                          Text(
                                              '%${clan.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                        ] else ...[
                                          const Text(
                                            '-',
                                            style: TextStyle(fontSize: 32.0),
                                          ),
                                          const Text(''),
                                        ],
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' : ',
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            color: clanWon == true
                                                ? Colors.green
                                                : (clanWon == false
                                                    ? Colors.redAccent
                                                    : null),
                                          ),
                                        ),
                                        const Text(''),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (warState == WarStateEnum.inWar ||
                                            warState ==
                                                WarStateEnum.warEnded) ...[
                                          Text(
                                            opponent.stars.toString(),
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              color: clanWon == true
                                                  ? Colors.green
                                                  : (clanWon == false
                                                      ? Colors.redAccent
                                                      : null),
                                            ),
                                          ),
                                          Text(
                                              '%${opponent.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                        ] else ...[
                                          const Text(
                                            '-',
                                            style: TextStyle(fontSize: 32.0),
                                          ),
                                          const Text(''),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInImage.assetNetwork(
                                height: 40,
                                width: 40,
                                image: opponent.badgeUrls.large,
                                placeholder: AppConstants.placeholderImage,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                opponent.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
