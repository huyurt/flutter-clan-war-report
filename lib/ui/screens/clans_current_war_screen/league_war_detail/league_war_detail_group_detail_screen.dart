import "package:collection/collection.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clan_league_wars_stat_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../widgets/app_widgets/rank_image.dart';
import '../../../widgets/app_widgets/star_stats_widget.dart';
import '../../../widgets/app_widgets/war_info_card.dart';
import '../../clans_screen/search_clan_screen/clan_detail_screen.dart';

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
            margin: EdgeInsets.zero,
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
                      child: RankImage(
                        imageUrl: widget.clan?.badgeUrls.large,
                        height: 75,
                        width: 75,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            widget.clan?.name ?? '',
                            style: const TextStyle(fontSize: 22.0),
                          ),
                        ),
                        Text(
                          widget.clan?.tag ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          StarStatWidget(
            stars: stars,
            totalStarCount: totalStarCount,
          ),
          ...widget.clanLeagueWars.map((warModel) {
            return WarInfoCard(
              clanTag: warModel.clanTag,
              warTag: warModel.warTag ?? '',
              warType: warModel.warType,
              war: warModel.war,
            );
          }).toList(),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
