import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_type_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../clans_screen/clan_detail_screen.dart';
import '../../clans_screen/player_detail_screen.dart';

class WarDetailAttacksScreen extends StatefulWidget {
  const WarDetailAttacksScreen({
    super.key,
    required this.clanCurrentWar,
    required this.clan,
    required this.opponent,
  });

  final ClanWarAndWarTypeResponseModel clanCurrentWar;
  final Clan clan;
  final Clan opponent;

  @override
  State<WarDetailAttacksScreen> createState() => _WarDetailAttacksScreenState();
}

class _WarDetailAttacksScreenState extends State<WarDetailAttacksScreen> {
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
        height: 14,
        fit: BoxFit.cover,
      ));
    }
    for (int index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
        height: 15,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Clan clan = widget.clan;
    Clan opponent = widget.opponent;
    List<Member> members = clan.members ?? <Member>[];
    members
        .sort((item1, item2) => item1.mapPosition.compareTo(item2.mapPosition));

    return ListView(
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
              if (!clan.tag.isEmptyOrNull) {
                ClanDetailScreen(
                  clanTag: clan.tag ?? '',
                ).launch(context);
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: FadeInImage.assetNetwork(
                      height: 50,
                      width: 50,
                      image: clan.badgeUrls.large,
                      placeholder: AppConstants.placeholderImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clan.name ?? '',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      Text(clan.tag ?? ''),
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

            Member? attackDefender1;
            if (attacks.isNotEmpty) {
              attackDefender1 = opponent.members?.firstWhere((opponentMember) =>
                  opponentMember.tag == attacks[0].defenderTag);
            }

            Member? attackDefender2;
            if (attacks.length > 1) {
              attackDefender2 = opponent.members?.firstWhere((opponentMember) =>
                  opponentMember.tag == attacks[1].defenderTag);
            }

            Member? defenderAttacker;
            if (member.bestOpponentAttack != null) {
              defenderAttacker = opponent.members?.firstWhere(
                  (opponentMember) =>
                      opponentMember.tag ==
                      member.bestOpponentAttack?.attackerTag);
            }

            final clanMemberTownhallLevel = (member.townhallLevel) > 11
                ? '${member.townhallLevel}.5'
                : (member.townhallLevel).toString();

            Color? bgColor;
            if (_bookmarkedPlayerTagsCubit.state.playerTags
                .contains(member.tag)) {
              bgColor = AppConstants.attackerClanBackgroundColor;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 175,
                      child: Card(
                        margin: EdgeInsetsDirectional.zero,
                        elevation: 0.0,
                        color: bgColor ?? Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (!member.tag.isEmptyOrNull) {
                              PlayerDetailScreen(
                                playerTag: member.tag,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${member.mapPosition}. ${member.name}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          height: 1, fontSize: 18),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        member.tag,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: FadeIn(
                                        animate: true,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        child: Image.asset(
                                          '${AppConstants.townHallsImagePath}$clanMemberTownhallLevel.png',
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          const RotatedBox(
                                                            quarterTurns: 1,
                                                            child: Icon(
                                                                MdiIcons.sword,
                                                                size: 14.0),
                                                          ),
                                                          Text(
                                                            ' ${tr(LocaleKey.attack)} 1',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    attackDefender1 != null
                                                        ? Text(
                                                            '${attackDefender1.mapPosition}. ${attackDefender1.name}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                                    height: 1),
                                                          )
                                                        : Text(tr(
                                                            LocaleKey.notUsed)),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  if (attackDefender1 !=
                                                      null) ...[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: getStarsWidget(
                                                            member.attacks?[0]
                                                                    .stars ??
                                                                0),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            const RotatedBox(
                                                              quarterTurns: 1,
                                                              child: Icon(
                                                                  MdiIcons
                                                                      .sword,
                                                                  size: 14.0),
                                                            ),
                                                            Text(
                                                              ' ${tr(LocaleKey.attack)} 2',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      attackDefender2 != null
                                                          ? Text(
                                                              '${attackDefender2.mapPosition}. ${attackDefender2.name}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style:
                                                                  const TextStyle(
                                                                      height:
                                                                          1),
                                                            )
                                                          : Text(tr(LocaleKey
                                                              .notUsed)),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    if (attackDefender2 !=
                                                        null) ...[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: getStarsWidget(
                                                              member.attacks?[1]
                                                                      .stars ??
                                                                  0),
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              MdiIcons.shield,
                                                              size: 14.0),
                                                          Text(
                                                            ' ${tr(LocaleKey.defence)}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    defenderAttacker != null
                                                        ? Text(
                                                            '${defenderAttacker.mapPosition}. ${defenderAttacker.name}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                                    height: 1),
                                                          )
                                                        : Text(tr(
                                                            LocaleKey.notUsed)),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  if (defenderAttacker !=
                                                      null) ...[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: getStarsWidget(
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
    );
  }
}
