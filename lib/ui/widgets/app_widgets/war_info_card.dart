import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/app_widgets/rank_image.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/api/response/clan_war_response_model.dart';
import '../../../utils/enums/war_state_enum.dart';
import '../../../utils/enums/war_type_enum.dart';
import '../../screens/clans_current_war_screen/war_detail/war_detail_screen.dart';
import '../countdown_timer/countdown_timer_widget.dart';

class WarInfoCard extends StatefulWidget {
  const WarInfoCard({
    super.key,
    required this.clanTag,
    required this.warTag,
    this.warType,
    this.war,
  });

  final String clanTag;
  final String warTag;
  final WarTypeEnum? warType;
  final ClanWarResponseModel? war;

  @override
  State<WarInfoCard> createState() => _WarInfoCardState();
}

class _WarInfoCardState extends State<WarInfoCard> {
  @override
  Widget build(BuildContext context) {
    final war = widget.war;
    if (war == null || war.state == WarStateEnum.notInWar.name) {
      return Container();
    }

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

    WarClan clan;
    WarClan opponent;
    if (war.clan.tag == widget.clanTag) {
      clan = war.clan;
      opponent = war.opponent;
    } else {
      clan = war.opponent;
      opponent = war.clan;
    }
    final warState =
        WarStateEnum.values.firstWhere((element) => element.name == war.state);
    bool? clanWon = warState == WarStateEnum.warEnded
        ? (clan.stars > opponent.stars ||
            (clan.stars == opponent.stars &&
                clan.destructionPercentage > opponent.destructionPercentage))
        : null;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: InkWell(
        onTap: () {
          WarDetailScreen(
            clanTag: widget.clanTag,
            warTag: widget.warTag,
            warType: widget.warType ?? WarTypeEnum.clanWar,
            warStartTime: war.warStartTime ?? '',
            clanName: clan.name ?? '',
            opponentName: opponent.name ?? '',
            showFloatingButton: true,
          ).launch(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
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
                      RankImage(
                        imageUrl: clan.badgeUrls.large,
                        height: 40,
                        width: 40,
                      ),
                      Text(
                        clan.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 155,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (warState == WarStateEnum.inWar ||
                                    warState == WarStateEnum.warEnded) ...[
                                  Text(
                                    clan.stars.toString(),
                                    style: TextStyle(
                                      fontSize: 22.0,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' : ',
                                  style: TextStyle(
                                    fontSize: 22.0,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (warState == WarStateEnum.inWar ||
                                    warState == WarStateEnum.warEnded) ...[
                                  Text(
                                    opponent.stars.toString(),
                                    style: TextStyle(
                                      fontSize: 22.0,
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
                      RankImage(
                        imageUrl: opponent.badgeUrls.large,
                        height: 40,
                        width: 40,
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
  }
}
