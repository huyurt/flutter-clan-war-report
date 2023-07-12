import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:more_useful_clash_of_clans/services/clan_service.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/war_log_screen/war_log_classic_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/war_log_screen/war_log_league_screen.dart';
import 'package:more_useful_clash_of_clans/utils/constants/app_constants.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';

import '../../../../../models/api/response/war_log_response_model.dart';
import '../../../../../models/coc/war_logs_model.dart';
import '../../../../widgets/api_error_widget.dart';

class WarLogScreen extends StatefulWidget {
  const WarLogScreen({super.key, required this.clanTag});

  final String clanTag;

  @override
  State<WarLogScreen> createState() => _WarLogScreenState();
}

class _WarLogScreenState extends State<WarLogScreen> {
  late Future<WarLogsModel> _warLogsFuture;

  @override
  void initState() {
    super.initState();
    _warLogsFuture = ClanService.getWarLogs(widget.clanTag);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKey.warLog)),
      ),
      body: FutureBuilder(
        future: _warLogsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              if (snapshot.error is DioError) {
                final error = snapshot.error as DioError;
                if (error.response?.statusCode == HttpStatus.forbidden) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        MdiIcons.eyeRemove,
                        size: 50.0,
                        color: Colors.amber,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0)),
                      Center(
                        child: Text(
                          tr(LocaleKey.warLogErrorMessageTitle),
                          style: const TextStyle(fontSize: 22.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 75.0),
                        child: Center(
                          child: Text(
                            tr(LocaleKey.warLogErrorMessage),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ApiErrorWidget(
                  error: snapshot.error,
                );
              }
            }
            if (snapshot.hasData) {
              final clan = snapshot.data?.clan;
              final warLogs = snapshot.data?.warLogs ?? <WarLogItem>[];

              return DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            tr(LocaleKey.tabWarLogClassicTitle),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            tr(LocaleKey.tabWarLogLeagueTitle),
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
                          WarLogClassicScreen(
                            key: const Key(LocaleKey.tabWarLogClassicTitle),
                            warLogs: warLogs
                                .where((w) => w.attacksPerMember != 1)
                                .toList(),
                          ),
                          WarLogLeagueScreen(
                            key: const Key(LocaleKey.tabWarLogLeagueTitle),
                            clanWarLeagueId: clan?.warLeague?.id ??
                                AppConstants.warLeagueUnranked,
                            clanWarLeagueName: clan?.warLeague?.name ?? '',
                            warLogs: warLogs
                                .where((w) => w.attacksPerMember == 1)
                                .toList(),
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
