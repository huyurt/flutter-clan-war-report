import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/clans_current_war_screen/war_detail/war_detail_attacks_screen.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/clans_current_war_screen/war_detail/war_detail_events_screen.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/clans_current_war_screen/war_detail/war_detail_stats_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_bloc.dart';
import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_event.dart';
import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_state.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_bloc.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_event.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_state.dart';
import '../../../../models/api/clan_war_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../league_war_detail/league_war_detail_screen.dart';

class WarDetailScreen extends StatefulWidget {
  const WarDetailScreen({
    super.key,
    required this.clanTag,
    required this.warType,
    required this.warStartTime,
    required this.clanName,
    required this.opponentName,
  });

  final String clanTag;
  final WarTypeEnum warType;
  final String warStartTime;
  final String clanName;
  final String opponentName;

  @override
  State<WarDetailScreen> createState() => _WarDetailScreenState();
}

class _WarDetailScreenState extends State<WarDetailScreen> {
  late ClanCurrentWarDetailBloc _clanCurrentWarDetailBloc;
  late ClanDetailBloc _clanDetailBloc;

  @override
  void initState() {
    super.initState();
    _clanCurrentWarDetailBloc = context.read<ClanCurrentWarDetailBloc>();
    _clanCurrentWarDetailBloc.add(
      GetClanCurrentWarDetail(
        clanTag: widget.clanTag,
      ),
    );
    _clanDetailBloc = context.read<ClanDetailBloc>();
    if (widget.warType == WarTypeEnum.leagueWar) {
      _clanDetailBloc.add(
        GetClanDetail(
          clanTag: widget.clanTag,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clanName} vs ${widget.opponentName}'),
      ),
      body: BlocBuilder<ClanCurrentWarDetailBloc, ClanCurrentWarDetailState>(
        builder: (context, state) {
          if (state is ClanCurrentWarDetailStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClanCurrentWarDetailStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is ClanCurrentWarDetailStateSuccess) {
            Clan clan;
            Clan opponent;
            if (state.clanCurrentWarDetail.clanWarResponseModel.clan.tag ==
                widget.clanTag) {
              clan = state.clanCurrentWarDetail.clanWarResponseModel.clan;
              opponent =
                  state.clanCurrentWarDetail.clanWarResponseModel.opponent;
            } else {
              clan = state.clanCurrentWarDetail.clanWarResponseModel.opponent;
              opponent = state.clanCurrentWarDetail.clanWarResponseModel.clan;
            }
            return DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          tr(LocaleKey.tabStatsTitle),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          tr(LocaleKey.tabEventsTitle),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          tr(LocaleKey.tabMyTeamTitle),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          tr(LocaleKey.tabEnemyTeamTitle),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        WarDetailStatsScreen(
                          clanTag: widget.clanTag,
                          clanCurrentWar: state.clanCurrentWarDetail,
                          clan: clan,
                          opponent: opponent,
                        ),
                        WarDetailEventsScreen(
                          clanCurrentWar: state.clanCurrentWarDetail,
                          clan: clan,
                          opponent: opponent,
                        ),
                        WarDetailAttacksScreen(
                          clanCurrentWar: state.clanCurrentWarDetail,
                          clan: clan,
                          opponent: opponent,
                        ),
                        WarDetailAttacksScreen(
                          clanCurrentWar: state.clanCurrentWarDetail,
                          clan: opponent,
                          opponent: clan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.warType == WarTypeEnum.leagueWar
          ? BlocBuilder<ClanDetailBloc, ClanDetailState>(
              builder: (context, state) {
              if (state is ClanDetailStateSuccess) {
                final clanDetail = state.clanDetail;
                return FloatingActionButton.extended(
                  label: Row(
                    children: [
                      if ((clanDetail.warLeague?.id ?? 0) >
                          AppConstants.warLeagueUnranked)
                        Image.asset(
                          '${AppConstants.clanWarLeaguesImagePath}${clanDetail.warLeague?.id}.png',
                          height: 24,
                          fit: BoxFit.cover,
                        )
                      else if (clanDetail.warLeague?.id ==
                          AppConstants.warLeagueUnranked)
                        Image.asset(
                          '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      Text(' ${tr(LocaleKey.viewLeague)}'),
                    ],
                  ),
                  onPressed: () {
                    LeagueWarDetailScreen(
                      clanTag: widget.clanTag,
                      warType: widget.warType,
                      warStartTime: widget.warStartTime,
                      clanDetail: clanDetail,
                    ).launch(context);
                  },
                );
              }
              return Visibility(
                visible: false,
                child: FloatingActionButton(onPressed: () {}),
              );
            })
          : null,
    );
  }
}
