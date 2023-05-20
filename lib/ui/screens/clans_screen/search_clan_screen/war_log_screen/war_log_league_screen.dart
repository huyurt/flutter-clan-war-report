import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../models/api/response/war_log_response_model.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/locale_key.dart';

class WarLogLeagueScreen extends StatefulWidget {
  const WarLogLeagueScreen({
    super.key,
    required this.clanWarLeagueId,
    required this.clanWarLeagueName,
    required this.warLogs,
  });

  final int clanWarLeagueId;
  final String clanWarLeagueName;
  final List<WarLogItem> warLogs;

  @override
  State<WarLogLeagueScreen> createState() => _WarLogLeagueScreenState();
}

class _WarLogLeagueScreenState extends State<WarLogLeagueScreen> {
  @override
  Widget build(BuildContext context) {
    int leagueCounter = 0;
    return Material(
      child: ListView(
        key: PageStorageKey(widget.key),
        children: widget.warLogs.map(
          (warLog) {
            final clan = warLog.clan;

            String? endTimeText = null;
            final endTime = DateTime.tryParse(warLog.endTime ?? '');
            if (endTime != null) {
              final formatter = DateFormat(
                  'MMMM yyyy', Localizations.localeOf(context).languageCode);
              endTimeText = formatter.format(endTime);
            }

            IconData resultIcon = MdiIcons.equal;
            Color resultIconColor = Colors.blue;
            switch (warLog.result) {
              case 'tie':
                resultIcon = MdiIcons.chevronDown;
                resultIconColor = Colors.red;
                leagueCounter += 1;
                break;
              case 'win':
                resultIcon = MdiIcons.chevronUp;
                resultIconColor = Colors.green;
                leagueCounter -= 1;
                break;
            }
            int clanWarLeagueId = widget.clanWarLeagueId + leagueCounter;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: SizedBox(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(endTimeText ?? ''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          resultIcon,
                          size: 24.0,
                          color: resultIconColor,
                        ),
                        Image.asset(
                          '${AppConstants.clanWarLeaguesImagePath}$clanWarLeagueId.png',
                          height: 28.0,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          ' ${tr('warLeague$clanWarLeagueId')}',
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${tr(LocaleKey.stars)}: ${clan.stars}')
                            .paddingRight(24.0),
                        Text(
                            '${tr(LocaleKey.destruction)}: %${(clan.destructionPercentage * (warLog.teamSize ?? 0)).toStringAsFixed(0)}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
