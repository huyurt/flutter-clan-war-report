import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/clan_detail_response_model.dart';
import '../../../../models/api/clan_league_group_response_model.dart';
import '../../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/enums/war_state_enum.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../war_detail/war_detail_screen.dart';

class LeagueWarDetailRoundsScreen extends StatefulWidget {
  const LeagueWarDetailRoundsScreen({
    super.key,
    required this.clanTag,
    required this.warStartTime,
    required this.clanDetail,
    required this.clanLeague,
    required this.clanLeagueWars,
  });

  final String clanTag;
  final String warStartTime;
  final ClanDetailResponseModel clanDetail;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClanWarAndWarTypeResponseModel> clanLeagueWars;

  @override
  State<LeagueWarDetailRoundsScreen> createState() =>
      _LeagueWarDetailRoundsScreenState();
}

class _LeagueWarDetailRoundsScreenState
    extends State<LeagueWarDetailRoundsScreen> {
  @override
  Widget build(BuildContext context) {
    final warsByRound = <int, List<ClanWarAndWarTypeResponseModel>>{};
    final rounds = (widget.clanLeague.rounds ?? <Round>[])
        .where((element) =>
            (element.warTags?.isNotEmpty ?? false) &&
            (element.warTags?.any((e2) => e2 != '#0') ?? false))
        .toList();

    int roundNo = 1;
    for (final round in rounds) {
      final wars = <ClanWarAndWarTypeResponseModel>[];
      for (final warTag in round.warTags ?? <String>[]) {
        final war = widget.clanLeagueWars
            .firstWhere((element) => element.warTag == warTag);
        wars.add(war);
      }
      warsByRound[roundNo++] = wars;
    }

    return ListView(
      key: PageStorageKey(widget.key),
      shrinkWrap: true,
      children: [
        ...warsByRound.keys.map(
          (round) {
            final warsData =
                warsByRound[round] ?? <ClanWarAndWarTypeResponseModel>[];
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
                      final war = warData.clanWarResponseModel;
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
                                vertical: 8.0, horizontal: 14.0),
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
                                        FadeInImage.assetNetwork(
                                          height: 40,
                                          width: 40,
                                          image: clan.badgeUrls.large,
                                          placeholder:
                                              AppConstants.placeholderImage,
                                          fit: BoxFit.cover,
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 8.0),
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
                                                              ? Colors.redAccent
                                                              : null),
                                                    ),
                                                  )
                                                : const Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontSize: 28.0),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 8.0),
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
                                                              ? Colors.redAccent
                                                              : null),
                                                    ),
                                                  )
                                                : const Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontSize: 28.0),
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
                                        FadeInImage.assetNetwork(
                                          height: 40,
                                          width: 40,
                                          image: opponent.badgeUrls.large,
                                          placeholder:
                                              AppConstants.placeholderImage,
                                          fit: BoxFit.cover,
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
      ],
    );
  }
}
