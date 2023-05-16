import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../bloc/widgets/war_log/war_log_bloc.dart';
import '../../../../../bloc/widgets/war_log/war_log_event.dart';
import '../../../../../bloc/widgets/war_log/war_log_state.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/enums/bloc_status_enum.dart';

class WarLogScreen extends StatefulWidget {
  const WarLogScreen({super.key, required this.clanTag});

  final String clanTag;

  @override
  State<WarLogScreen> createState() => _WarLogScreenState();
}

class _WarLogScreenState extends State<WarLogScreen> {
  late WarLogBloc _warLogBloc;

  @override
  void initState() {
    super.initState();
    _warLogBloc = context.read<WarLogBloc>();
    _warLogBloc.add(
      GetWarLog(
        clanTag: widget.clanTag,
      ),
    );
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
      body: BlocBuilder<WarLogBloc, WarLogState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return Center(child: Text(tr('search_failed_message')));
            case BlocStatusEnum.success:
              return ListView(
                children: state.items
                    .where((e) =>
                        !e.result.isEmptyOrNull &&
                        !e.opponent.name.isEmptyOrNull)
                    .map(
                  (warLog) {
                    final clan = warLog.clan;
                    final opponent = warLog.opponent;

                    String? endTimeText = null;
                    final endTime = DateTime.tryParse(warLog.endTime ?? '');
                    if (endTime != null) {
                      final formatter = DateFormat('d MMM yyyy',
                          Localizations.localeOf(context).languageCode);
                      endTimeText = formatter.format(endTime);
                    }

                    final clanWon = (clan.stars > opponent.stars ||
                        (clan.stars == opponent.stars &&
                            clan.destructionPercentage >
                                opponent.destructionPercentage));

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
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
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!endTimeText.isEmptyOrNull)
                                      Text(endTimeText ?? ''),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              clan.stars.toString(),
                                              style: TextStyle(
                                                fontSize: 24.0,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                fontSize: 24.0,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              opponent.stars.toString(),
                                              style: TextStyle(
                                                fontSize: 24.0,
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
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
