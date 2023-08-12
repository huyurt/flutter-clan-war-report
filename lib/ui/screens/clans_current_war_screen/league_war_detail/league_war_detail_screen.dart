import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clan_war_report/services/clan_service.dart';

import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/coc/clan_details_and_league_wars_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
import '../../../widgets/api_error_widget.dart';
import 'league_war_detail_group_screen.dart';
import 'league_war_detail_players_screen.dart';
import 'league_war_detail_rounds_screen.dart';

class LeagueWarDetailScreen extends StatefulWidget {
  const LeagueWarDetailScreen({
    super.key,
    required this.clanTag,
    required this.warType,
    required this.warStartTime,
    required this.clanDetail,
  });

  final String clanTag;
  final WarTypeEnum warType;
  final String warStartTime;
  final ClanDetailResponseModel clanDetail;

  @override
  State<LeagueWarDetailScreen> createState() => _LeagueWarDetailScreenState();
}

class _LeagueWarDetailScreenState extends State<LeagueWarDetailScreen> {
  late Future<ClanDetailsAndLeagueWarsModel> _clanDetailsAndLeagueWarsFuture;

  @override
  void initState() {
    super.initState();
    _clanDetailsAndLeagueWarsFuture =
        ClanService.getClanDetailsAndLeagueWars(widget.clanTag);
  }

  Future<void> _refresh() async {
    setState(() {
      _clanDetailsAndLeagueWarsFuture =
          ClanService.getClanDetailsAndLeagueWars(widget.clanTag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final warStartTime = DateTime.tryParse(widget.warStartTime);
    String season = '';
    if (warStartTime != null) {
      season = DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(warStartTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${tr(LocaleKey.clanWarLeague)} - $season ${tr(LocaleKey.season)}'),
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
        future: _clanDetailsAndLeagueWarsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ApiErrorWidget(
                onRefresh: _refresh,
              );
            }
            if (snapshot.hasData) {
              final totalRoundCount = snapshot.data?.rounds ?? 0;
              final clanLeague = snapshot.data?.clanLeague;
              final clanLeagueWars = snapshot.data?.clanLeagueWars ??
                  <ClansCurrentWarStateModel>[];

              return DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            tr(LocaleKey.group),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.rounds),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.players),
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
                          LeagueWarDetailGroupScreen(
                            key: const Key(LocaleKey.group),
                            clanTag: widget.clanTag,
                            warStartTime: widget.warStartTime,
                            clanDetail: widget.clanDetail,
                            otherClans: snapshot.data?.otherClans ?? [],
                            clanLeague: clanLeague!,
                            clanLeagueWars: clanLeagueWars,
                            totalRoundCount: totalRoundCount,
                            refreshCallback: _refresh,
                          ),
                          LeagueWarDetailRoundsScreen(
                            key: const Key(LocaleKey.rounds),
                            clanTag: widget.clanTag,
                            warStartTime: widget.warStartTime,
                            clanDetail: widget.clanDetail,
                            clanLeague: clanLeague!,
                            clanLeagueWars: clanLeagueWars,
                            refreshCallback: _refresh,
                          ),
                          LeagueWarDetailPlayersScreen(
                            key: const Key(LocaleKey.players),
                            clanTag: widget.clanTag,
                            warStartTime: widget.warStartTime,
                            clanDetail: widget.clanDetail,
                            clanLeague: clanLeague,
                            clanLeagueWars: clanLeagueWars,
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
    );
  }
}
