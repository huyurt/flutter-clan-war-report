import 'package:animate_do/animate_do.dart';
import "package:collection/collection.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/api/response/clan_league_group_response_model.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../widgets/rank_image.dart';
import 'league_war_detail_players_detail_screen.dart';

class ClanLeagueWarsMemberStats {
  ClanLeagueWarsMemberStats({
    required this.attackCount,
    required this.totalDestructionPercentages,
    required this.totalStars,
    required this.member,
    required this.memberAttacks,
    required this.memberDefenceAttacks,
    required this.roundCount,
    required this.clanTag,
    required this.clanName,
  });

  final int attackCount;
  final int totalDestructionPercentages;
  final int totalStars;
  final LeagueGroupMember member;
  final List<Attack> memberAttacks;
  final List<Attack> memberDefenceAttacks;
  final int roundCount;
  final String clanTag;
  final String clanName;
}

class LeagueParticipant {
  LeagueParticipant({
    required this.member,
    required this.clanTag,
  });

  final LeagueGroupMember member;
  final String clanTag;
}

class LeagueWarDetailPlayersScreen extends StatefulWidget {
  const LeagueWarDetailPlayersScreen({
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
  State<LeagueWarDetailPlayersScreen> createState() =>
      _LeagueWarDetailPlayersScreenState();
}

class _LeagueWarDetailPlayersScreenState
    extends State<LeagueWarDetailPlayersScreen>
    with AutomaticKeepAliveClientMixin<LeagueWarDetailPlayersScreen> {
  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() async {
    widget.refreshCallback();
  }

  late LeagueGroupClan _clanFilter =
      LeagueGroupClan(name: tr(LocaleKey.allClans), tag: '', members: []);

  void showClanFilter(BuildContext aContext, StateSetter setState) {
    final clanList = List.of(widget.clanLeague.clans ?? <LeagueGroupClan>[]);
    clanList.sort((a, b) => a.tag.compareTo(b.tag));
    clanList.insert(
        0, LeagueGroupClan(name: tr(LocaleKey.allClans), tag: '', members: []));
    showModalBottomSheet(
      context: aContext,
      backgroundColor: aContext.primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                child: Text(
                  tr(LocaleKey.clans),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              Expanded(
                child: ListView(
                  children: clanList.map(
                    (clan) {
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        color: _clanFilter.tag == clan.tag
                            ? Colors.black12
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _clanFilter = clan;
                            });
                            Navigator.pop(aContext);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                if (clan.badgeUrls != null)
                                  RankImage(
                                    imageUrl: clan.badgeUrls?.large,
                                    height: 16,
                                    width: 16,
                                  ).paddingRight(8.0),
                                Text(
                                  clan.name,
                                  style: const TextStyle(height: 1.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clanMembers = <LeagueGroupMember>[];
    for (var clan in widget.clanLeague.clans ?? <LeagueGroupClan>[]) {
      clanMembers.addAll(clan.members);
    }

    final members = <WarClanMember>[];
    for (final war in widget.clanLeagueWars) {
      final clanMembers = war.war.clan.members ?? <WarClanMember>[];
      final opponentMembers = war.war.opponent.members ?? <WarClanMember>[];
      members.addAll(clanMembers);
      members.addAll(opponentMembers);
    }

    final memberStats = <ClanLeagueWarsMemberStats>[];
    final groupedAttacks = groupBy(members, (member) => member.tag);
    for (final memberTag in groupedAttacks.keys) {
      final member =
          clanMembers.firstWhere((element) => element.tag == memberTag);
      final clan = widget.clanLeague.clans?.firstWhere(
          (element) => element.members.any((e2) => e2.tag == member.tag));

      final memberInPreparationWar = widget.clanLeagueWars.any((w) =>
          w.war.state == WarStateEnum.preparation.name &&
          ((w.war.clan.members?.any((m) => m.tag == member.tag) ?? false) ||
              (w.war.opponent.members?.any((m) => m.tag == member.tag) ??
                  false)));

      int roundCount = 0;
      final memberAttacks = <Attack>[];
      final memberDefenceAttacks = <Attack>[];

      members.where((member) => member.tag == memberTag).forEach((element) {
        roundCount += 1;
        memberAttacks.addAll(element.attacks ?? <Attack>[]);
      });

      members
          .where((member) =>
              member.attacks?.any((e2) => e2.defenderTag == memberTag) ?? false)
          .forEach((element) {
        memberDefenceAttacks.addAll(element.attacks ?? <Attack>[]);
      });

      memberStats.add(ClanLeagueWarsMemberStats(
        attackCount: memberAttacks.length,
        totalDestructionPercentages:
            memberAttacks.sumBy((e) => e.destructionPercentage ?? 0),
        totalStars: memberAttacks.sumBy((e) => e.stars ?? 0),
        member: member,
        memberAttacks: memberAttacks,
        memberDefenceAttacks: memberDefenceAttacks,
        roundCount: memberInPreparationWar ? roundCount - 1 : roundCount,
        clanTag: clan?.tag ?? '',
        clanName: clan?.name ?? '',
      ));
    }
    memberStats.sort((a, b) => <Comparator<ClanLeagueWarsMemberStats>>[
          (o1, o2) => o2.totalStars.compareTo(o1.totalStars),
          (o1, o2) => o2.totalDestructionPercentages
              .compareTo(o1.totalDestructionPercentages),
          (o1, o2) => o2.attackCount.compareTo(o1.attackCount),
          (o1, o2) =>
              o2.member.townHallLevel.compareTo(o1.member.townHallLevel),
          (o1, o2) => o1.clanName.compareTo(o2.clanName),
          (o1, o2) => o1.member.name.compareTo(o2.member.name),
        ].map((e) => e(a, b)).firstWhere((e) => e != 0, orElse: () => 0));

    final leagueParticipants = <LeagueParticipant>[];
    for (final clan in widget.clanLeague.clans ?? <LeagueGroupClan>[]) {
      leagueParticipants.addAll(clan.members
          .where((element) => !members.any((e2) => e2.tag == element.tag))
          .map((e) => LeagueParticipant(
                member: e,
                clanTag: clan.tag,
              )));
    }
    leagueParticipants.sort((a, b) => <Comparator<LeagueParticipant>>[
          (o1, o2) =>
              o2.member.townHallLevel.compareTo(o1.member.townHallLevel),
        ].map((e) => e(a, b)).firstWhere((e) => e != 0, orElse: () => 0));

    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: _refresh,
      child: ListView(
        key: PageStorageKey(widget.key),
        shrinkWrap: true,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            elevation: 0.0,
            color: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {
                showClanFilter(context, setState);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 18.0),
                child: Row(
                  children: [
                    if (_clanFilter.badgeUrls != null)
                      RankImage(
                        imageUrl: _clanFilter.badgeUrls?.large,
                        height: 16,
                        width: 16,
                      ).paddingRight(8.0),
                    Text(
                      _clanFilter.name,
                      style: const TextStyle(height: 1.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...(_clanFilter.tag.isEmptyOrNull
                  ? memberStats
                  : memberStats.where((m) => m.clanTag == _clanFilter.tag))
              .map(
            (memberStat) {
              final index = memberStats.indexOf(memberStat);
              final member = memberStat.member;
              final clan = widget.clanLeague.clans?.firstWhere(
                  (e1) => e1.members.any((e2) => e2.tag == member.tag));

              final clanMemberTownHallLevel = (member.townHallLevel) > 11
                  ? '${member.townHallLevel}.5'
                  : (member.townHallLevel).toString();

              Color? bgColor;
              if (context
                  .watch<BookmarkedPlayerTagsCubit>()
                  .state
                  .playerTags
                  .contains(member.tag)) {
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
                    LeagueWarDetailPlayersDetailScreen(
                      clanTag: widget.clanTag,
                      warStartTime: widget.warStartTime,
                      clan: clan,
                      member: member,
                      memberAttacks: memberStat.memberAttacks,
                      memberDefenceAttacks: memberStat.memberDefenceAttacks,
                      roundCount: memberStat.roundCount,
                    ).launch(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: SizedBox(
                      height: 60.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text('${index + 1}.'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FadeIn(
                              animate: true,
                              duration: const Duration(milliseconds: 250),
                              child: Image.asset(
                                '${AppConstants.townHallsImagePath}$clanMemberTownHallLevel.png',
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    member.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(height: 1.2),
                                  ),
                                ),
                                Row(
                                  children: [
                                    RankImage(
                                      imageUrl: clan?.badgeUrls?.large,
                                      height: 12,
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' ${clan?.name}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(height: 1.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 60,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        '${AppConstants.clashResourceImagePath}${AppConstants.star2Image}',
                                        height: 12.0,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(' ${memberStat.totalStars}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 70,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '%${memberStat.totalDestructionPercentages}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 55,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${memberStat.attackCount}/${memberStat.roundCount}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          ...(_clanFilter.tag.isEmptyOrNull
                  ? leagueParticipants
                  : leagueParticipants
                      .where((m) => m.clanTag == _clanFilter.tag))
              .map(
            (participant) {
              final index = leagueParticipants.indexOf(participant);
              final clan = widget.clanLeague.clans?.firstWhere((e1) =>
                  e1.members.any((e2) => e2.tag == participant.member.tag));

              final clanMemberTownHallLevel =
                  (participant.member.townHallLevel) > 11
                      ? '${participant.member.townHallLevel}.5'
                      : (participant.member.townHallLevel).toString();

              return Card(
                margin: EdgeInsets.zero,
                elevation: 0.0,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: InkWell(
                  onTap: () {
                    LeagueWarDetailPlayersDetailScreen(
                      clanTag: widget.clanTag,
                      warStartTime: widget.warStartTime,
                      clan: clan,
                      member: participant.member,
                      memberAttacks: const <Attack>[],
                      memberDefenceAttacks: const <Attack>[],
                      roundCount: 0,
                    ).launch(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 14.0),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${index + 1 + memberStats.length}.'),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FadeIn(
                              animate: true,
                              duration: const Duration(milliseconds: 250),
                              child: Image.asset(
                                '${AppConstants.townHallsImagePath}$clanMemberTownHallLevel.png',
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    participant.member.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(height: 1.2),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: RankImage(
                                        imageUrl: clan?.badgeUrls?.large,
                                        height: 12,
                                        width: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        clan?.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(height: 1.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 60,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        '${AppConstants.clashResourceImagePath}${AppConstants.star2Image}',
                                        height: 12.0,
                                        fit: BoxFit.cover,
                                      ),
                                      const Text(' 0'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 70,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('%0'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: SizedBox(
                              height: 50,
                              width: 55,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('0/0'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
