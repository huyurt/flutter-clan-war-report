import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clan_war_report/utils/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/api/response/clan_league_group_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/enums/war_state_enum.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../../widgets/app_widgets/rank_image.dart';
import '../war_detail/war_detail_screen.dart';

class LeagueWarDetailRoundsScreen extends StatefulWidget {
  const LeagueWarDetailRoundsScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clanDetail,
    required this.clanLeague,
    required this.clanLeagueWars,
    required this.refreshCallback,
  });

  final String clanTag;
  final String warStartTime;
  final ClanDetailResponseModel clanDetail;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;
  final VoidCallback refreshCallback;

  @override
  State<LeagueWarDetailRoundsScreen> createState() =>
      _LeagueWarDetailRoundsScreenState();
}

class _LeagueWarDetailRoundsScreenState
    extends State<LeagueWarDetailRoundsScreen> {
  Future<void> _refresh() async {
    widget.refreshCallback();
  }

  @override
  Widget build(BuildContext context) {
    final warsByRound = <int, List<ClansCurrentWarStateModel>>{};
    final rounds = (widget.clanLeague.rounds ?? <LeagueGroupRound>[])
        .where((element) =>
            (element.warTags?.isNotEmpty ?? false) &&
            (element.warTags?.any((e2) => e2 != '#0') ?? false))
        .toList();

    int roundNo = 1;
    for (final round in rounds) {
      final wars = <ClansCurrentWarStateModel>[];
      for (final warTag in round.warTags ?? <String>[]) {
        final war = widget.clanLeagueWars
            .firstWhere((element) => element.warTag == warTag);
        wars.add(war);
      }
      warsByRound[roundNo++] = wars;
    }

    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: _refresh,
      child: ListView(
        key: PageStorageKey(widget.key),
        shrinkWrap: true,
        children: [
          ...warsByRound.keys.map(
            (round) {
              final warsData =
                  warsByRound[round] ?? <ClansCurrentWarStateModel>[];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        tr(LocaleKey.nthRound, args: [
                          round.toString(),
                        ]),
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    ...warsData.map(
                      (warData) {
                        final war = warData.war;
                        final clan = war.clan;
                        final opponent = war.opponent;
                        final warState = WarStateEnum.values
                            .firstWhere((element) => element.name == war.state);
                        bool? clanWon = warState == WarStateEnum.warEnded
                            ? (clan.stars > opponent.stars ||
                                (clan.stars == opponent.stars &&
                                    clan.destructionPercentage >
                                        opponent.destructionPercentage))
                            : null;

                        Color? bgColor;
                        if (context
                                .watch<BookmarkedClanTagsCubit>()
                                .state
                                .clanTags
                                .contains(clan.tag) ||
                            context
                                .watch<BookmarkedClanTagsCubit>()
                                .state
                                .clanTags
                                .contains(opponent.tag)) {
                          bgColor = AppConstants.attackerClanBackgroundColor;
                        }

                        return Card(
                          margin: EdgeInsets.zero,
                          elevation: 0.0,
                          color: bgColor ?? Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              WarDetailScreen(
                                clanTag: clan.tag ?? '',
                                warTag: warData.warTag,
                                warType: WarTypeEnum.leagueWar,
                                warStartTime: war.warStartTime ?? '',
                                clanName: clan.name ?? '',
                                opponentName: opponent.name ?? '',
                              ).launch(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4.0),
                              child: SizedBox(
                                height: 70,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                clan.name ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          RankImage(
                                            imageUrl: clan.badgeUrls.large,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 8.0),
                                              child: (warState ==
                                                          WarStateEnum.inWar ||
                                                      warState ==
                                                          WarStateEnum.warEnded)
                                                  ? Text(
                                                      clan.stars.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: clanWon == true
                                                            ? Colors.green
                                                            : (clanWon == false
                                                                ? Colors
                                                                    .redAccent
                                                                : null),
                                                      ),
                                                    )
                                                  : const Text(
                                                      '-',
                                                      style: TextStyle(
                                                          fontSize: 26.0),
                                                    ),
                                            ),
                                          ),
                                          const Text(
                                            ' : ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 8.0),
                                              child: (warState ==
                                                          WarStateEnum.inWar ||
                                                      warState ==
                                                          WarStateEnum.warEnded)
                                                  ? Text(
                                                      opponent.stars.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: clanWon == false
                                                            ? Colors.green
                                                            : (clanWon == true
                                                                ? Colors
                                                                    .redAccent
                                                                : null),
                                                      ),
                                                    )
                                                  : const Text(
                                                      '-',
                                                      style: TextStyle(
                                                          fontSize: 26.0),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RankImage(
                                            imageUrl: opponent.badgeUrls.large,
                                            height: 40,
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                opponent.name ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
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
                      },
                    ),
                  ],
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
