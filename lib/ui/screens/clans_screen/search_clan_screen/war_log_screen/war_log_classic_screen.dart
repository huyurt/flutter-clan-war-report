import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../models/api/response/war_log_response_model.dart';
import '../../../../../utils/constants/app_constants.dart';

class WarLogClassicScreen extends StatefulWidget {
  const WarLogClassicScreen({super.key, required this.warLogs});

  final List<WarLogItem> warLogs;

  @override
  State<WarLogClassicScreen> createState() => _WarLogClassicScreenState();
}

class _WarLogClassicScreenState extends State<WarLogClassicScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        key: PageStorageKey(widget.key),
        children: [
          ...widget.warLogs.map(
            (warLog) {
              final clan = warLog.clan;
              final opponent = warLog.opponent;

              String? endTimeText = null;
              final endTime = DateTime.tryParse(warLog.endTime ?? '');
              if (endTime != null) {
                final formatter = DateFormat(
                    'd MMM yyyy', Localizations.localeOf(context).languageCode);
                endTimeText = formatter.format(endTime);
              }

              final clanWon = (clan.stars > opponent.stars ||
                  (clan.stars == opponent.stars &&
                      clan.destructionPercentage >
                          opponent.destructionPercentage));

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInImage.assetNetwork(
                              height: 40,
                              width: 40,
                              image: clan.badgeUrls?.large ?? '',
                              placeholder: AppConstants.placeholderImage,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              clan.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!endTimeText.isEmptyOrNull)
                                Text(endTimeText ?? ''),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        clan.stars.toString(),
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: clanWon
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                      Text(
                                          '%${clan.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ' : ',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: clanWon
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                      const Text(''),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        opponent.stars.toString(),
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: clanWon
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                      Text(
                                          '%${opponent.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInImage.assetNetwork(
                              height: 40,
                              width: 40,
                              image: opponent.badgeUrls?.large ?? '',
                              placeholder: AppConstants.placeholderImage,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              opponent.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
