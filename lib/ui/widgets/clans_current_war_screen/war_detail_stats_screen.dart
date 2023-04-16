import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/api/clan_war_response_model.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/enums/war_state_enum.dart';

class WarDetailStatsScreen extends StatefulWidget {
  const WarDetailStatsScreen(
      {super.key, required this.clanTag, required this.clanCurrentWar});

  final String clanTag;
  final ClanWarResponseModel clanCurrentWar;

  @override
  State<WarDetailStatsScreen> createState() => _WarDetailStatsScreenState();
}

class _WarDetailStatsScreenState extends State<WarDetailStatsScreen> {
  @override
  Widget build(BuildContext context) {
    final clanCurrentWar = widget.clanCurrentWar;
    Clan clan;
    Clan opponent;
    if (clanCurrentWar.clan.tag == widget.clanTag) {
      clan = clanCurrentWar.clan;
      opponent = clanCurrentWar.opponent;
    } else {
      clan = clanCurrentWar.opponent;
      opponent = clanCurrentWar.clan;
    }

    int clan3StarCount = 0;
    int clan2StarCount = 0;
    int clan1StarCount = 0;
    int clan0StarCount = 0;
    int clanTotalDestruction = 0;
    int clanTotalDuration = 0;
    clan.members?.forEach((e) {
      clan3StarCount += e.attacks?.where((e) => e.stars == 3).length ?? 0;
      clan2StarCount += e.attacks?.where((e) => e.stars == 2).length ?? 0;
      clan1StarCount += e.attacks?.where((e) => e.stars == 1).length ?? 0;
      clan0StarCount += e.attacks?.where((e) => e.stars == 0).length ?? 0;
      clanTotalDestruction +=
          e.attacks.sumBy((e) => e.destructionPercentage ?? 0);
      clanTotalDuration += e.attacks.sumBy((e) => e.duration ?? 0);
    });
    final clanAverageStars =
        (clan3StarCount * 3 + clan2StarCount * 2 + clan1StarCount * 1) /
            (clan3StarCount + clan2StarCount + clan1StarCount + clan0StarCount);
    final clanAverageDuration =
        Duration(seconds: (clanTotalDuration / clan.attacks).floor());

    int opponent3StarCount = 0;
    int opponent2StarCount = 0;
    int opponent1StarCount = 0;
    int opponent0StarCount = 0;
    int opponentTotalDestruction = 0;
    int opponentTotalDuration = 0;
    opponent.members?.forEach((e) {
      opponent3StarCount += e.attacks?.where((e) => e.stars == 3).length ?? 0;
      opponent2StarCount += e.attacks?.where((e) => e.stars == 2).length ?? 0;
      opponent1StarCount += e.attacks?.where((e) => e.stars == 1).length ?? 0;
      opponent0StarCount += e.attacks?.where((e) => e.stars == 0).length ?? 0;
      opponentTotalDestruction +=
          e.attacks.sumBy((e) => e.destructionPercentage ?? 0);
      opponentTotalDuration += e.attacks.sumBy((e) => e.duration ?? 0);
    });
    final opponentAverageStars = (opponent3StarCount * 3 +
            opponent2StarCount * 2 +
            opponent1StarCount * 1) /
        (opponent3StarCount +
            opponent2StarCount +
            opponent1StarCount +
            opponent0StarCount);
    final opponentAverageDuration =
        Duration(seconds: (opponentTotalDuration / opponent.attacks).floor());

    final durationLocale =
        DurationLocale.fromLanguageCode(context.locale.languageCode);
    final clanAverageDurationText = durationLocale != null
        ? printDuration(
            clanAverageDuration,
            abbreviated: true,
            conjugation: ' ',
            tersity: DurationTersity.second,
            upperTersity: DurationTersity.minute,
            locale: durationLocale,
          )
        : printDuration(
            clanAverageDuration,
            abbreviated: true,
            conjugation: ' ',
            tersity: DurationTersity.second,
            upperTersity: DurationTersity.minute,
          );
    final opponentAverageDurationText = durationLocale != null
        ? printDuration(
            opponentAverageDuration,
            abbreviated: true,
            conjugation: ' ',
            locale: durationLocale,
          )
        : printDuration(
            opponentAverageDuration,
            abbreviated: true,
            conjugation: ' ',
          );

    final startTime = DateTime.tryParse(clanCurrentWar.startTime ?? '');
    final endTime = DateTime.tryParse(clanCurrentWar.endTime ?? '');
    String? remainingTimeText;
    Duration? remainingEndTime;
    if (endTime != null && clanCurrentWar.state == WarStateEnum.inWar.name) {
      remainingEndTime = endTime.difference(DateTime.now().toUtc());
    } else if (startTime != null &&
        clanCurrentWar.state == WarStateEnum.preparation.name) {
      remainingEndTime = startTime.difference(DateTime.now().toUtc());
    }
    if (remainingEndTime != null) {
      final durationLocale =
          DurationLocale.fromLanguageCode(context.locale.languageCode);
      remainingTimeText = durationLocale != null
          ? printDuration(
              remainingEndTime,
              abbreviated: true,
              tersity: DurationTersity.minute,
              upperTersity: DurationTersity.hour,
              conjugation: ' ',
              locale: durationLocale,
            )
          : printDuration(
              remainingEndTime,
              abbreviated: true,
              tersity: DurationTersity.minute,
              upperTersity: DurationTersity.hour,
              conjugation: ' ',
            );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage.assetNetwork(
                height: 50,
                width: 50,
                image: clan.badgeUrls.large,
                placeholder: AppConstants.placeholderImage,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr('${clanCurrentWar.state}_description'),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    if (!remainingTimeText.isEmptyOrNull)
                      Text(remainingTimeText!),
                  ],
                ),
              ),
              FadeInImage.assetNetwork(
                height: 50,
                width: 50,
                image: opponent.badgeUrls.large,
                placeholder: AppConstants.placeholderImage,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Text(tr(LocaleKey.stars)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(clan.stars.toString()),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LinearProgressIndicator(
                        value: clan.stars / (clan.stars + opponent.stars),
                        backgroundColor: Colors.red,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(opponent.stars.toString()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Text(tr(LocaleKey.totalDestruction)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '%${clan.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LinearProgressIndicator(
                        value: clan.destructionPercentage /
                            (clan.destructionPercentage +
                                opponent.destructionPercentage),
                        backgroundColor: Colors.red,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '%${opponent.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${clan.attacks}/${(clanCurrentWar.teamSize ?? 0) * (clanCurrentWar.attacksPerMember ?? 0)}'),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        tr(LocaleKey.attacksUsed),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${opponent.attacks}/${(clanCurrentWar.teamSize ?? 0) * (clanCurrentWar.attacksPerMember ?? 0)}'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clan3StarCount.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponent3StarCount.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clan2StarCount.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponent2StarCount.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clan1StarCount.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponent1StarCount.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clan0StarCount.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              '${AppConstants.clashResourceImagePath}${AppConstants.star3_0Image}',
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponent0StarCount.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clanAverageStars
                            .toStringAsFixed(2)
                            .padLeft(2, '0')),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          tr(LocaleKey.averageStars),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponentAverageStars
                            .toStringAsFixed(2)
                            .padLeft(2, '0')),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            '%${(clanTotalDestruction / clan.attacks).toStringAsFixed(2).padLeft(2, '0')}'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          tr(LocaleKey.averageDestruction),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '%${(opponentTotalDestruction / opponent.attacks).toStringAsFixed(2).padLeft(2, '0')}'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(clanAverageDurationText),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          tr(LocaleKey.averageAttackDuration),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(opponentAverageDurationText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
