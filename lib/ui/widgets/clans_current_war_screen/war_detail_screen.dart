import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/clans_current_war_screen/war_detail_stats_screen.dart';

import '../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_bloc.dart';
import '../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_event.dart';
import '../../../bloc/widgets/clan_current_war_detail/clan_current_war_detail_state.dart';
import '../../../models/api/clan_war_response_model.dart';
import '../../../utils/constants/locale_key.dart';

class WarDetailScreen extends StatefulWidget {
  const WarDetailScreen({
    super.key,
    required this.clanTag,
    required this.clanName,
    required this.opponentName,
  });

  final String clanTag;
  final String clanName;
  final String opponentName;

  @override
  State<WarDetailScreen> createState() => _WarDetailScreenState();
}

class _WarDetailScreenState extends State<WarDetailScreen> {
  late ClanCurrentWarDetailBloc _clanCurrentWarDetailBloc;

  @override
  void initState() {
    super.initState();
    _clanCurrentWarDetailBloc = context.read<ClanCurrentWarDetailBloc>();
    _clanCurrentWarDetailBloc.add(
      GetClanCurrentWarDetail(
        clanTag: widget.clanTag,
      ),
    );
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
            if (state.clanCurrentWarDetail.clan.tag == widget.clanTag) {
              clan = state.clanCurrentWarDetail.clan;
              opponent = state.clanCurrentWarDetail.opponent;
            } else {
              clan = state.clanCurrentWarDetail.opponent;
              opponent = state.clanCurrentWarDetail.clan;
            }
            return DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    tabs: [
                      Tab(child: Text(tr(LocaleKey.tabStatsTitle))),
                      Tab(child: Text(tr(LocaleKey.tabEventsTitle))),
                      Tab(child: Text(tr(LocaleKey.tabMyTeamTitle))),
                      Tab(child: Text(tr(LocaleKey.tabEnemyTeamTitle))),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TabBarView(
                        children: [
                          WarDetailStatsScreen(
                            clanTag: widget.clanTag,
                            clanCurrentWar: state.clanCurrentWarDetail,
                            clan: clan,
                            opponent: opponent,
                          ),
                          Container(),
                          Container(),
                          Container(),
                        ],
                      ),
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
