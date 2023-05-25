import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../clans_screen/search_clan_screen/player_detail_screen.dart';
import '../../../widgets/attacker_painter.dart';

class WarDetailEventsScreen extends StatefulWidget {
  const WarDetailEventsScreen({
    super.key,
    required this.clanCurrentWar,
    required this.clan,
    required this.opponent,
    required this.refreshCallback,
  });

  final ClansCurrentWarStateModel clanCurrentWar;
  final WarClan clan;
  final WarClan opponent;
  final VoidCallback refreshCallback;

  @override
  State<WarDetailEventsScreen> createState() => _WarDetailEventsScreenState();
}

class _WarDetailEventsScreenState extends State<WarDetailEventsScreen> {
  Future<void> _refresh() async {
    widget.refreshCallback();
  }

  List<Widget> getStarsWidget(int stars, int beforeGainedStars) {
    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (int index = 0; index < min(stars, beforeGainedStars); index++) {
      widgets.add(Opacity(
        opacity: 0.3,
        child: Image.asset(
          '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
          height: 16,
          fit: BoxFit.cover,
        ),
      ));
    }
    for (int index = 0; index < stars - beforeGainedStars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }
    for (int index = 0; index < zeroStar; index++) {
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
    final clan = widget.clan;
    final opponent = widget.opponent;
    final attacks = <Attack>[];
    clan.members?.forEach((e) => attacks.addAll(e.attacks ?? <Attack>[]));
    opponent.members?.forEach((e) => attacks.addAll(e.attacks ?? <Attack>[]));
    attacks
        .sort((item1, item2) => (item2.order ?? 0).compareTo(item1.order ?? 0));

    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: _refresh,
      child: attacks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.paste,
                  size: 54.0,
                  color: Colors.amber,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(tr(LocaleKey.noAttacksYet)),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    key: PageStorageKey(widget.key),
                    shrinkWrap: true,
                    children: [
                      ...attacks.map(
                        (attack) {
                          final clanMember = clan.members?.firstWhere(
                              (member) =>
                                  member.tag == attack.attackerTag ||
                                  member.tag == attack.defenderTag);
                          final opponentMember = opponent.members?.firstWhere(
                              (member) =>
                                  member.tag == attack.attackerTag ||
                                  member.tag == attack.defenderTag);
                          final clanAttacker =
                              clanMember?.tag == attack.attackerTag;

                          final clanMemberTownHallLevel =
                              (clanMember?.townhallLevel ?? 1) > 11
                                  ? '${clanMember?.townhallLevel}.5'
                                  : (clanMember?.townhallLevel ?? 1).toString();
                          final opponentMemberTownHallLevel =
                              (opponentMember?.townhallLevel ?? 1) > 11
                                  ? '${opponentMember?.townhallLevel}.5'
                                  : (opponentMember?.townhallLevel ?? 1)
                                      .toString();

                          Color? bgColor;
                          if (clanAttacker) {
                            if (context
                                .watch<BookmarkedPlayerTagsCubit>()
                                .state
                                .playerTags
                                .contains(clanMember?.tag)) {
                              bgColor =
                                  AppConstants.attackerClanBackgroundColor;
                            } else if (context
                                .watch<BookmarkedPlayerTagsCubit>()
                                .state
                                .playerTags
                                .contains(opponentMember?.tag)) {
                              bgColor =
                                  AppConstants.attackerOpponentBackgroundColor;
                            }
                          } else {
                            if (context
                                .watch<BookmarkedPlayerTagsCubit>()
                                .state
                                .playerTags
                                .contains(opponentMember?.tag)) {
                              bgColor =
                                  AppConstants.attackerClanBackgroundColor;
                            } else if (context
                                .watch<BookmarkedPlayerTagsCubit>()
                                .state
                                .playerTags
                                .contains(clanMember?.tag)) {
                              bgColor =
                                  AppConstants.attackerOpponentBackgroundColor;
                            }
                          }

                          final beforeAttacks = attacks.where((element) =>
                              element.defenderTag == attack.defenderTag &&
                              (element.order ?? 0) < (attack.order ?? 0));
                          int beforeGainedStars = 0;
                          for (final beforeAttack in beforeAttacks) {
                            final stars = beforeAttack.stars ?? 0;
                            if (stars > beforeGainedStars) {
                              beforeGainedStars = stars;
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
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: clanAttacker
                                          ? bgColor ??
                                              AppConstants
                                                  .attackerDefaultBackgroundColor
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
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
                                                child: Text(
                                                  '${clanMember?.mapPosition}. ${clanMember?.name}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              FadeIn(
                                                animate: true,
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                child: Image.asset(
                                                  '${AppConstants.townHallsImagePath}$clanMemberTownHallLevel.png',
                                                  width: 40,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: getStarsWidget(
                                                attack.stars ?? 0,
                                                beforeGainedStars),
                                          ),
                                          Text(
                                              '%${attack.destructionPercentage ?? 0}'),
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
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: !clanAttacker
                                          ? bgColor ??
                                              AppConstants
                                                  .attackerDefaultBackgroundColor
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (!(opponentMember
                                                  ?.tag.isEmptyOrNull ??
                                              true)) {
                                            PlayerDetailScreen(
                                              playerTag:
                                                  opponentMember?.tag ?? '',
                                            ).launch(context);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${opponentMember?.mapPosition}. ${opponentMember?.name}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              FadeIn(
                                                animate: true,
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                child: Image.asset(
                                                  '${AppConstants.townHallsImagePath}$opponentMemberTownHallLevel.png',
                                                  width: 40,
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
                      widget.clanCurrentWar.warType == WarTypeEnum.leagueWar
                          ? const SizedBox(height: 72.0)
                          : const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
