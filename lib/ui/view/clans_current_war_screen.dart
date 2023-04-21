import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import '../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_event.dart';
import '../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_state.dart';
import '../../models/api/clan_war_response_model.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/enums/war_state_enum.dart';
import '../widgets/clans_current_war_screen/war_detail_screen.dart';
import '../widgets/countdown_timer/countdown_timer_widget.dart';

class ClansCurrentWarScreen extends StatefulWidget {
  const ClansCurrentWarScreen({super.key});

  @override
  State<ClansCurrentWarScreen> createState() => _ClansCurrentWarScreenState();
}

class _ClansCurrentWarScreenState extends State<ClansCurrentWarScreen> {
  late BookmarkedClansCurrentWarBloc _bookmarkedClansCurrentWarBloc;
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();
    _bookmarkedClansCurrentWarBloc =
        context.read<BookmarkedClansCurrentWarBloc>();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedClansCurrentWarBloc.add(
      GetBookmarkedClansCurrentWar(
        clanTagList: context.watch<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount:
            context.watch<BookmarkedClanTagsCubit>().state.clanTags.length,
        itemBuilder: (BuildContext context, int index) {
          return BlocBuilder<BookmarkedClansCurrentWarBloc,
              BookmarkedClansCurrentWarState>(
            builder: (context, state) {
              if (state is BookmarkedClansCurrentWarStateLoading) {
                return Container();
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BookmarkedClansCurrentWarStateError) {
                return Container();
                return Center(child: Text(tr('search_failed_message')));
              }
              if (state is BookmarkedClansCurrentWarStateSuccess) {
                if (state.clansCurrentWar.length - 1 < index) {
                  return Container();
                }
                final clanTag = state.clanTags[index];
                final clanCurrentWar = state.clansCurrentWar[index];
                if (clanCurrentWar == null ||
                    clanCurrentWar.state == WarStateEnum.notInWar.name) {
                  return Container();
                }

                DateTime? remainingDateTime;
                final startTime =
                    DateTime.tryParse(clanCurrentWar.startTime ?? '');
                final endTime = DateTime.tryParse(clanCurrentWar.endTime ?? '');
                if (endTime != null &&
                    clanCurrentWar.state == WarStateEnum.inWar.name) {
                  remainingDateTime = endTime;
                } else if (startTime != null &&
                    clanCurrentWar.state == WarStateEnum.preparation.name) {
                  remainingDateTime = startTime;
                }

                Clan clan;
                Clan opponent;
                if (clanCurrentWar.clan.tag == clanTag) {
                  clan = clanCurrentWar.clan;
                  opponent = clanCurrentWar.opponent;
                } else {
                  clan = clanCurrentWar.opponent;
                  opponent = clanCurrentWar.clan;
                }
                final warState = WarStateEnum.values.firstWhere(
                    (element) => element.name == clanCurrentWar.state);
                bool? clanWon = warState == WarStateEnum.warEnded
                    ? (clan.stars > opponent.stars ||
                        (clan.stars == opponent.stars &&
                            clan.destructionPercentage >
                                opponent.destructionPercentage))
                    : null;

                return Card(
                  margin: const EdgeInsets.all(0.0),
                  elevation: 0.0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      WarDetailScreen(
                        clanTag: clanTag,
                        clanName: clan.name ?? '',
                        opponentName: opponent.name ?? '',
                      ).launch(context);
                    },
                    child: Padding(
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
                                    image: clan.badgeUrls.large,
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
                                    if (remainingDateTime != null)
                                      CountdownTimerWidget(
                                        remainingDateTime: remainingDateTime,
                                      ),
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
                                            if (warState ==
                                                    WarStateEnum.inWar ||
                                                warState ==
                                                    WarStateEnum.warEnded) ...[
                                              Text(
                                                clan.stars.toString(),
                                                style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: clanWon == true
                                                      ? Colors.green
                                                      : (clanWon == false
                                                          ? Colors.redAccent
                                                          : null),
                                                ),
                                              ),
                                              Text(
                                                  '%${clan.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                            ] else ...[
                                              const Text(
                                                '-',
                                                style:
                                                    TextStyle(fontSize: 32.0),
                                              ),
                                              const Text(''),
                                            ],
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
                                                color: clanWon == true
                                                    ? Colors.green
                                                    : (clanWon == false
                                                        ? Colors.redAccent
                                                        : null),
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
                                            if (warState ==
                                                    WarStateEnum.inWar ||
                                                warState ==
                                                    WarStateEnum.warEnded) ...[
                                              Text(
                                                opponent.stars.toString(),
                                                style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: clanWon == true
                                                      ? Colors.green
                                                      : (clanWon == false
                                                          ? Colors.redAccent
                                                          : null),
                                                ),
                                              ),
                                              Text(
                                                  '%${opponent.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                            ] else ...[
                                              const Text(
                                                '-',
                                                style:
                                                    TextStyle(fontSize: 32.0),
                                              ),
                                              const Text(''),
                                            ],
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
                                    image: opponent.badgeUrls.large,
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
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
