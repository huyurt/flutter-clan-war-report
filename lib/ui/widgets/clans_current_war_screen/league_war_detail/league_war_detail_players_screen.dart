import 'package:animate_do/animate_do.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/clan_detail_response_model.dart';
import '../../../../models/api/clan_league_group_response_model.dart';
import '../../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
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
    required this.clanName,
  });

  final int attackCount;
  final int totalDestructionPercentages;
  final int totalStars;
  final Member member;
  final List<Attack> memberAttacks;
  final List<Attack> memberDefenceAttacks;
  final int roundCount;
  final String clanName;
}

class LeagueWarDetailPlayersScreen extends StatefulWidget {
  const LeagueWarDetailPlayersScreen({
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
  State<LeagueWarDetailPlayersScreen> createState() =>
      _LeagueWarDetailPlayersScreenState();
}

class _LeagueWarDetailPlayersScreenState
    extends State<LeagueWarDetailPlayersScreen> {
  @override
  Widget build(BuildContext context) {
    WarStateEnum lastWarState = WarStateEnum.notInWar;
    final members = <Member>[];
    for (final war in widget.clanLeagueWars) {
      final clanMembers = war.clanWarResponseModel.clan.members ?? <Member>[];
      final opponentMembers =
          war.clanWarResponseModel.opponent.members ?? <Member>[];
      members.addAll(clanMembers);
      members.addAll(opponentMembers);
      lastWarState = WarStateEnum.values.firstWhere(
          (element) => element.name == war.clanWarResponseModel.state);
    }

    final memberStats = <ClanLeagueWarsMemberStats>[];
    final groupedAttacks = groupBy(members, (member) => member.tag);
    for (final memberTag in groupedAttacks.keys) {
      final member = members.firstWhere((element) => element.tag == memberTag);
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
      final clan = widget.clanLeague.clans?.firstWhere((element) =>
          element.members?.any((e2) => e2.tag == member.tag) ?? false);
      memberStats.add(ClanLeagueWarsMemberStats(
        attackCount: memberAttacks.length,
        totalDestructionPercentages:
            memberAttacks.sumBy((e) => e.destructionPercentage ?? 0),
        totalStars: memberAttacks.sumBy((e) => e.stars ?? 0),
        member: member,
        memberAttacks: memberAttacks,
        memberDefenceAttacks: memberDefenceAttacks,
        roundCount: lastWarState == WarStateEnum.preparation
            ? roundCount - 1
            : roundCount,
        clanName: clan?.name ?? '',
      ));
    }
    memberStats.sort((a, b) => <Comparator<ClanLeagueWarsMemberStats>>[
          (o1, o2) => o2.totalStars.compareTo(o1.totalStars),
          (o1, o2) => o2.totalDestructionPercentages
              .compareTo(o1.totalDestructionPercentages),
          (o1, o2) => o2.attackCount.compareTo(o1.attackCount),
          (o1, o2) =>
              o2.member.townhallLevel.compareTo(o1.member.townhallLevel),
          (o1, o2) => o1.clanName.compareTo(o2.clanName),
          (o1, o2) => o1.member.name.compareTo(o2.member.name),
        ].map((e) => e(a, b)).firstWhere((e) => e != 0, orElse: () => 0));

    final leagueParticipants = <LeagueGroupMember>[];
    for (final clan in widget.clanLeague.clans ?? <LeagueGroupClan>[]) {
      leagueParticipants.addAll(clan.members?.where(
              (element) => !members.any((e2) => e2.tag == element.tag)) ??
          <LeagueGroupMember>[]);
    }
    leagueParticipants.sort((a, b) => <Comparator<LeagueGroupMember>>[
          (o1, o2) => o2.townHallLevel.compareTo(o1.townHallLevel),
        ].map((e) => e(a, b)).firstWhere((e) => e != 0, orElse: () => 0));

    return ListView(
      key: PageStorageKey(widget.key),
      shrinkWrap: true,
      children: [
        ...memberStats.map(
          (memberStat) {
            final index = memberStats.indexOf(memberStat);
            final member = memberStat.member;
            final clan = widget.clanLeague.clans?.firstWhere(
                (e1) => e1.members?.any((e2) => e2.tag == member.tag) ?? false);

            final clanMemberTownHallLevel = (member.townhallLevel) > 11
                ? '${member.townhallLevel}.5'
                : (member.townhallLevel).toString();

            Color? bgColor;
            if (context
                .watch<BookmarkedPlayerTagsCubit>()
                .state
                .playerTags
                .contains(member.tag)) {
              bgColor = AppConstants.attackerClanBackgroundColor;
            }

            return Card(
              margin: EdgeInsetsDirectional.zero,
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
                      vertical: 8.0, horizontal: 14.0),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${index + 1}.'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: FadeInImage.assetNetwork(
                                      height: 12,
                                      width: 12,
                                      image: clan?.badgeUrls?.large ??
                                          AppConstants.placeholderImage,
                                      placeholder:
                                          AppConstants.placeholderImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    clan?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                      height: 14,
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
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                    Text(
                                        '%${memberStat.totalDestructionPercentages}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
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
        ...leagueParticipants.map(
          (member) {
            final index = leagueParticipants.indexOf(member);
            final clan = widget.clanLeague.clans?.firstWhere(
                (e1) => e1.members?.any((e2) => e2.tag == member.tag) ?? false);

            final clanMemberTownHallLevel = (member.townHallLevel) > 11
                ? '${member.townHallLevel}.5'
                : (member.townHallLevel).toString();

            return Card(
              margin: EdgeInsetsDirectional.zero,
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
                    member: Member(
                      tag: member.tag,
                      name: member.name,
                      townhallLevel: member.townHallLevel,
                      mapPosition: 0,
                      opponentAttacks: 0,
                    ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: FadeInImage.assetNetwork(
                                      height: 12,
                                      width: 12,
                                      image: clan?.badgeUrls?.large ??
                                          AppConstants.placeholderImage,
                                      placeholder:
                                          AppConstants.placeholderImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    clan?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                      height: 14,
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(' 0'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                  children: const [
                                    Text('%0'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
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
      ],
    );
  }
}
