import 'dart:math';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:clan_war_report/ui/screens/clans_current_war_screen/war_detail/war_detail_attacks_detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:clan_war_report/utils/constants/locale_key.dart';
import 'package:clan_war_report/utils/enums/war_type_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/image_helper.dart';
import '../../../widgets/app_widgets/rank_image.dart';
import '../../clans_screen/search_clan_screen/clan_detail_screen.dart';

class WarDetailAttacksScreen extends StatefulWidget {
  const WarDetailAttacksScreen({
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
  State<WarDetailAttacksScreen> createState() => _WarDetailAttacksScreenState();
}

class _WarDetailAttacksScreenState extends State<WarDetailAttacksScreen> {
  Future<void> _refresh() async {
    widget.refreshCallback();
  }

  List<Widget> getStarsWidget(List<Attack> attacks, Attack? attack) {
    int stars = attack?.stars ?? 0;
    final beforeAttacks = attacks.where((element) =>
        element.defenderTag == attack?.defenderTag &&
        (element.order ?? 0) < (attack?.order ?? 0));
    int beforeGainedStars = 0;
    for (final beforeAttack in beforeAttacks) {
      final stars = beforeAttack.stars ?? 0;
      if (stars > beforeGainedStars) {
        beforeGainedStars = stars;
      }
    }

    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (int index = 0; index < min(stars, beforeGainedStars); index++) {
      widgets.add(Opacity(
        opacity: 0.3,
        child: Image.asset(
          '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
          height: 14.0,
          fit: BoxFit.cover,
        ),
      ));
    }
    for (int index = 0; index < stars - beforeGainedStars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 14.0,
        fit: BoxFit.cover,
      ));
    }
    for (int index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_3Image}',
        height: 14.0,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  List<Widget> getOpponentStarsWidget(int stars) {
    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (int index = 0; index < stars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 14.0,
        fit: BoxFit.cover,
      ));
    }
    for (int index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_3Image}',
        height: 14.0,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final clan = widget.clan;
    final opponent = widget.opponent;
    final members = clan.members ?? <WarClanMember>[];
    members
        .sort((item1, item2) => item1.mapPosition.compareTo(item2.mapPosition));

    final allAttacks = <Attack>[];
    clan.members?.forEach((e) => allAttacks.addAll(e.attacks ?? <Attack>[]));
    allAttacks
        .sort((item1, item2) => (item2.order ?? 0).compareTo(item1.order ?? 0));

    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: _refresh,
      child: ListView(
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
                if (!clan.tag.isEmptyOrNull) {
                  ClanDetailScreen(
                    viewWarButton: false,
                    clanTag: clan.tag ?? '',
                  ).launch(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: RankImage(
                        imageUrl: clan.badgeUrls.large,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            clan.name ?? '',
                            style: const TextStyle(height: 1.2, fontSize: 16.0),
                          ),
                        ),
                        Text(
                          clan.tag ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...members.map(
            (member) {
              final attacks = member.attacks ?? <Attack>[];

              WarClanMember? attackDefender1;
              if (attacks.isNotEmpty) {
                attackDefender1 = opponent.members?.firstWhere(
                    (opponentMember) =>
                        opponentMember.tag == attacks[0].defenderTag);
              }

              WarClanMember? attackDefender2;
              if (attacks.length > 1) {
                attackDefender2 = opponent.members?.firstWhere(
                    (opponentMember) =>
                        opponentMember.tag == attacks[1].defenderTag);
              }

              WarClanMember? defenderAttacker;
              if (member.bestOpponentAttack != null) {
                defenderAttacker = opponent.members?.firstWhere(
                    (opponentMember) =>
                        opponentMember.tag ==
                        member.bestOpponentAttack?.attackerTag);
              }

              final clanMemberTownHallLevel =
                  ImageHelper.getTownhallImage(member.townhallLevel, 1);

              Color? bgColor;
              if (context
                  .watch<BookmarkedPlayerTagsCubit>()
                  .state
                  .playerTags
                  .contains(member.tag)) {
                bgColor = AppConstants.attackerClanBackgroundColor;
              }

              return SizedBox(
                height: 160,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0.0,
                  color: bgColor ?? Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!member.tag.isEmptyOrNull) {
                        WarDetailAttacksDetailScreen(
                          clan: clan,
                          member: member,
                          memberAttacks: member.attacks ?? <Attack>[],
                          memberDefenceAttacks:
                              member.bestOpponentAttack != null
                                  ? <Attack>[member.bestOpponentAttack!]
                                  : <Attack>[],
                          roundCount: 2,
                        ).launch(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${member.mapPosition}. ${member.name}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(height: 1.2, fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: FadeIn(
                                  animate: true,
                                  duration: const Duration(milliseconds: 250),
                                  child: Image.asset(
                                    '${AppConstants.townHallsImagePath}$clanMemberTownHallLevel.png',
                                    width: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(AkarIcons.sword,
                                                        size: 14.0),
                                                    Text(
                                                      ' ${tr(LocaleKey.attack)} 1',
                                                      style: const TextStyle(
                                                          fontSize: 10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              attackDefender1 != null
                                                  ? Text(
                                                      '${attackDefender1.mapPosition}. ${attackDefender1.name}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          height: 1),
                                                    )
                                                  : Text(tr(LocaleKey.notUsed)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            if (attackDefender1 != null) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: getStarsWidget(
                                                      allAttacks,
                                                      member.attacks?[0]),
                                                ),
                                              ),
                                              Text(
                                                  '%${attacks[0].destructionPercentage}'),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (widget.clanCurrentWar.warType ==
                                        WarTypeEnum.clanWar)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          AkarIcons.sword,
                                                          size: 14.0),
                                                      Text(
                                                        ' ${tr(LocaleKey.attack)} 2',
                                                        style: const TextStyle(
                                                            fontSize: 10.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                attackDefender2 != null
                                                    ? Text(
                                                        '${attackDefender2.mapPosition}. ${attackDefender2.name}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            height: 1),
                                                      )
                                                    : Text(
                                                        tr(LocaleKey.notUsed)),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              if (attackDefender2 != null) ...[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: getStarsWidget(
                                                        allAttacks,
                                                        member.attacks?[1]),
                                                  ),
                                                ),
                                                Text(
                                                    '%${attacks[1].destructionPercentage}'),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  children: [
                                                    Icon(MdiIcons.shield,
                                                        size: 14.0),
                                                    Text(
                                                      ' ${tr(LocaleKey.defence)}',
                                                      style: const TextStyle(
                                                          fontSize: 10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              defenderAttacker != null
                                                  ? Text(
                                                      '${defenderAttacker.mapPosition}. ${defenderAttacker.name}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          height: 1),
                                                    )
                                                  : Text(tr(LocaleKey.notUsed)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            if (defenderAttacker != null) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: getOpponentStarsWidget(
                                                      member.bestOpponentAttack
                                                              ?.stars ??
                                                          0),
                                                ),
                                              ),
                                              Text(
                                                  '%${member.bestOpponentAttack?.destructionPercentage ?? 0}'),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          widget.clanCurrentWar.warType == WarTypeEnum.leagueWar
              ? const SizedBox(height: 72.0)
              : const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
