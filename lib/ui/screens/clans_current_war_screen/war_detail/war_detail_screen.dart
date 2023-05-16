import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_attacks_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_events_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_stats_screen.dart';
import 'package:more_useful_clash_of_clans/utils/enums/bloc_status_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_bloc.dart';
import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_event.dart';
import '../../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_state.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_bloc.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_event.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_state.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../league_war_detail/league_war_detail_screen.dart';

class WarDetailScreen extends StatefulWidget {
  const WarDetailScreen({
    super.key,
    required this.clanTag,
    this.warTag,
    required this.warType,
    required this.warStartTime,
    required this.clanName,
    required this.opponentName,
    this.showFloatingButton,
  });

  final String clanTag;
  final String? warTag;
  final WarTypeEnum warType;
  final String warStartTime;
  final String clanName;
  final String opponentName;
  final bool? showFloatingButton;

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
    _clanDetailBloc = context.read<ClanDetailBloc>();
    _getDetails();
  }

  _getDetails() {
    _clanCurrentWarDetailBloc.add(
      GetClanCurrentWarDetail(
        clanTag: widget.clanTag,
        warTag: widget.warTag,
      ),
    );
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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: LocaleKey.refresh,
                  child: Text(tr(LocaleKey.refresh)),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case LocaleKey.refresh:
                  _getDetails();
                  break;
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ClanCurrentWarDetailBloc, ClanCurrentWarDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return Center(child: Text(tr('search_failed_message')));
            case BlocStatusEnum.success:
              final clansCurrentWar = state.item;
              WarClan clan;
              WarClan opponent;
              if (clansCurrentWar?.war.clan.tag == widget.clanTag) {
                clan = clansCurrentWar!.war.clan;
                opponent = clansCurrentWar.war.opponent;
              } else {
                clan = clansCurrentWar!.war.opponent;
                opponent = clansCurrentWar.war.clan;
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
                            key: const Key(LocaleKey.tabStatsTitle),
                            clanTag: widget.clanTag,
                            clanCurrentWar: clansCurrentWar,
                            clan: clan,
                            opponent: opponent,
                          ),
                          WarDetailEventsScreen(
                            key: const Key(LocaleKey.tabEventsTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: clan,
                            opponent: opponent,
                          ),
                          WarDetailAttacksScreen(
                            key: const Key(LocaleKey.tabMyTeamTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: clan,
                            opponent: opponent,
                          ),
                          WarDetailAttacksScreen(
                            key: const Key(LocaleKey.tabEnemyTeamTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: opponent,
                            opponent: clan,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.showFloatingButton == true &&
              widget.warType == WarTypeEnum.leagueWar
          ? BlocBuilder<ClanDetailBloc, ClanDetailState>(
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatusEnum.success:
                    final clanDetail = state.item;
                    return FloatingActionButton.extended(
                      label: Text(tr(LocaleKey.viewLeague)),
                      onPressed: () {
                        LeagueWarDetailScreen(
                          clanTag: widget.clanTag,
                          warType: widget.warType,
                          warStartTime: widget.warStartTime,
                          clanDetail: clanDetail!,
                        ).launch(context);
                      },
                    );
                  default:
                    return Visibility(
                      visible: false,
                      child: FloatingActionButton(onPressed: () {}),
                    );
                }
              },
            )
          : null,
    );
  }
}
