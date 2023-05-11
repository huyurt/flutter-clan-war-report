import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/widgets/clan_league_wars/clan_league_wars_bloc.dart';
import '../../../../bloc/widgets/clan_league_wars/clan_league_wars_event.dart';
import '../../../../bloc/widgets/clan_league_wars/clan_league_wars_state.dart';
import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';
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
  late ClanLeagueWarsBloc _clanLeagueWarsBloc;

  @override
  void initState() {
    super.initState();
    _clanLeagueWarsBloc = context.read<ClanLeagueWarsBloc>();
    _getDetails();
  }

  _getDetails() {
    _clanLeagueWarsBloc.add(
      GetClanLeagueWars(
        clanTag: widget.clanTag,
      ),
    );
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
                  value: 0,
                  child: Text(tr(LocaleKey.refresh)),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  _getDetails();
                  break;
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ClanLeagueWarsBloc, ClanLeagueWarsState>(
        builder: (context, state) {
          if (state is ClanLeagueWarsStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClanLeagueWarsStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is ClanLeagueWarsStateSuccess) {
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
                        ),
                      ),
                      Tab(
                        child: Text(
                          tr(LocaleKey.rounds),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Tab(
                        child: Text(
                          tr(LocaleKey.players),
                          textAlign: TextAlign.center,
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
                          clanLeagueWars: state.clanLeagueWars,
                          totalRoundCount: state.totalRoundCount,
                        ),
                        LeagueWarDetailRoundsScreen(
                          key: const Key(LocaleKey.rounds),
                          clanTag: widget.clanTag,
                          warStartTime: widget.warStartTime,
                          clanDetail: widget.clanDetail,
                          clanLeague: state.clanLeague,
                          clanLeagueWars: state.clanLeagueWars,
                        ),
                        LeagueWarDetailPlayersScreen(
                          key: const Key(LocaleKey.players),
                          clanTag: widget.clanTag,
                          warStartTime: widget.warStartTime,
                          clanDetail: widget.clanDetail,
                          clanLeague: state.clanLeague,
                          clanLeagueWars: state.clanLeagueWars,
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
    );
  }
}
