import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/clans_current_war_screen/war_detail_stats_screen.dart';

import '../../../models/api/clan_war_response_model.dart';
import '../../../utils/constants/locale_key.dart';

class WarDetailScreen extends StatefulWidget {
  const WarDetailScreen(
      {super.key, required this.clanTag, required this.clanCurrentWar});

  final String clanTag;
  final ClanWarResponseModel clanCurrentWar;

  @override
  State<WarDetailScreen> createState() => _WarDetailScreenState();
}

class _WarDetailScreenState extends State<WarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Clan clan;
    Clan opponent;
    if (widget.clanCurrentWar.clan.tag == widget.clanTag) {
      clan = widget.clanCurrentWar.clan;
      opponent = widget.clanCurrentWar.opponent;
    } else {
      clan = widget.clanCurrentWar.opponent;
      opponent = widget.clanCurrentWar.clan;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${clan.name} vs ${opponent.name}'),
      ),
      body: DefaultTabController(
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
                      clanCurrentWar: widget.clanCurrentWar,
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
      ),
    );
  }
}
