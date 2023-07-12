import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_attacks_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_events_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_stats_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/api/response/clan_war_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../services/clan_service.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../../widgets/api_error_widget.dart';
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
  late Future<ClanDetailResponseModel> _clanDetailFuture;
  late Future<ClansCurrentWarStateModel> _currentWarDetailFuture;

  @override
  void initState() {
    super.initState();
    if (widget.showFloatingButton == true &&
        widget.warType == WarTypeEnum.leagueWar) {
      _clanDetailFuture = ClanService.getClanDetail(widget.clanTag);
    }
    _currentWarDetailFuture =
        ClanService.getCurrentWarDetail(widget.clanTag, widget.warTag);
  }

  Future<void> _refresh() async {
    setState(() {
      _currentWarDetailFuture =
          ClanService.getCurrentWarDetail(widget.clanTag, widget.warTag);
    });
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
            onSelected: (value) async {
              switch (value) {
                case LocaleKey.refresh:
                  await _refresh();
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _currentWarDetailFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ApiErrorWidget(
                onRefresh: _refresh,
              );
            }
            if (snapshot.hasData) {
              final clansCurrentWar = snapshot.data;
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
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.tabEventsTitle),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.tabMyTeamTitle),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.tabEnemyTeamTitle),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
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
                            refreshCallback: _refresh,
                          ),
                          WarDetailEventsScreen(
                            key: const Key(LocaleKey.tabEventsTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: clan,
                            opponent: opponent,
                            refreshCallback: _refresh,
                          ),
                          WarDetailAttacksScreen(
                            key: const Key(LocaleKey.tabMyTeamTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: clan,
                            opponent: opponent,
                            refreshCallback: _refresh,
                          ),
                          WarDetailAttacksScreen(
                            key: const Key(LocaleKey.tabEnemyTeamTitle),
                            clanCurrentWar: clansCurrentWar,
                            clan: opponent,
                            opponent: clan,
                            refreshCallback: _refresh,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.showFloatingButton == true &&
              widget.warType == WarTypeEnum.leagueWar
          ? FutureBuilder(
              future: _clanDetailFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final clanDetail = snapshot.data;
                    return FloatingActionButton.extended(
                      label: Text(
                        tr(LocaleKey.viewLeague),
                        style: const TextStyle(fontSize: 10.0),
                      ),
                      onPressed: () {
                        LeagueWarDetailScreen(
                          clanTag: widget.clanTag,
                          warType: widget.warType,
                          warStartTime: widget.warStartTime,
                          clanDetail: clanDetail!,
                        ).launch(context);
                      },
                    );
                  }
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
