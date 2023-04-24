import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../clans_screen/player_detail_screen.dart';
import '../attacker_painter.dart';

class WarDetailEventsScreen extends StatefulWidget {
  const WarDetailEventsScreen({
    super.key,
    required this.clanCurrentWar,
    required this.clan,
    required this.opponent,
  });

  final ClanWarAndWarTypeResponseModel clanCurrentWar;
  final Clan clan;
  final Clan opponent;

  @override
  State<WarDetailEventsScreen> createState() => _WarDetailEventsScreenState();
}

class _WarDetailEventsScreenState extends State<WarDetailEventsScreen> {
  late BookmarkedPlayerTagsCubit _bookmarkedPlayerTagsCubit;

  @override
  void initState() {
    super.initState();
    _bookmarkedPlayerTagsCubit = context.read<BookmarkedPlayerTagsCubit>();
  }

  List<Widget> getStarsWidget(int stars) {
    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (int index = 0; index < stars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }
    for (int index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
        height: 17,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Clan clan = widget.clan;
    Clan opponent = widget.opponent;
    List<Attack> attacks = <Attack>[];
    clan.members?.forEach((e) => attacks.addAll(e.attacks ?? <Attack>[]));
    opponent.members?.forEach((e) => attacks.addAll(e.attacks ?? <Attack>[]));
    attacks
        .sort((item1, item2) => (item2.order ?? 0).compareTo(item1.order ?? 0));

    return Column(
      children: [
        Expanded(
          child: ListView(
            key: PageStorageKey(widget.key),
            shrinkWrap: true,
            children: [
              ...attacks.map(
                (attack) {
                  final clanMember = clan.members?.firstWhere((member) =>
                      member.tag == attack.attackerTag ||
                      member.tag == attack.defenderTag);
                  final opponentMember = opponent.members?.firstWhere(
                      (member) =>
                          member.tag == attack.attackerTag ||
                          member.tag == attack.defenderTag);
                  final clanAttacker = clanMember?.tag == attack.attackerTag;

                  final clanMemberTownhallLevel =
                      (clanMember?.townhallLevel ?? 1) > 11
                          ? '${clanMember?.townhallLevel}.5'
                          : (clanMember?.townhallLevel ?? 1).toString();
                  final opponentMemberTownhallLevel =
                      (opponentMember?.townhallLevel ?? 1) > 11
                          ? '${opponentMember?.townhallLevel}.5'
                          : (opponentMember?.townhallLevel ?? 1).toString();

                  Color? bgColor;
                  if (clanAttacker) {
                    if (_bookmarkedPlayerTagsCubit.state.playerTags
                        .contains(clanMember?.tag)) {
                      bgColor = AppConstants.attackerClanBackgroundColor;
                    }
                  } else {
                    if (_bookmarkedPlayerTagsCubit.state.playerTags
                        .contains(opponentMember?.tag)) {
                      bgColor = AppConstants.attackerClanBackgroundColor;
                    } else if (_bookmarkedPlayerTagsCubit.state.playerTags
                        .contains(clanMember?.tag)) {
                      bgColor = AppConstants.attackerOpponentBackgroundColor;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: Card(
                              margin: EdgeInsetsDirectional.zero,
                              elevation: 0.0,
                              color: clanAttacker
                                  ? bgColor ??
                                      AppConstants
                                          .attackerDefaultBackgroundColor
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!(clanMember?.tag.isEmptyOrNull ??
                                      true)) {
                                    PlayerDetailScreen(
                                      playerTag: clanMember?.tag ?? '',
                                    ).launch(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${clanMember?.mapPosition}. ${clanMember?.name}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      FadeIn(
                                        animate: true,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        child: Image.asset(
                                          '${AppConstants.townHallsImagePath}$clanMemberTownhallLevel.png',
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: CustomPaint(
                            painter: AttackerPainter(
                              color: bgColor,
                              rightDirection: clanAttacker,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: getStarsWidget(attack.stars ?? 0),
                                  ),
                                  Text('%${attack.destructionPercentage ?? 0}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: Card(
                              margin: EdgeInsetsDirectional.zero,
                              elevation: 0.0,
                              color: !clanAttacker
                                  ? bgColor ??
                                      AppConstants
                                          .attackerDefaultBackgroundColor
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!(opponentMember?.tag.isEmptyOrNull ??
                                      true)) {
                                    PlayerDetailScreen(
                                      playerTag: opponentMember?.tag ?? '',
                                    ).launch(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${opponentMember?.mapPosition}. ${opponentMember?.name}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      FadeIn(
                                        animate: true,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        child: Image.asset(
                                          '${AppConstants.townHallsImagePath}$opponentMemberTownhallLevel.png',
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (widget.clanCurrentWar.warType == WarTypeEnum.leagueWar)
                const SizedBox(height: 64.0),
            ],
          ),
        ),
      ],
    );
  }
}
