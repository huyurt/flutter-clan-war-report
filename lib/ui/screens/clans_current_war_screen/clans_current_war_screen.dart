import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_screen.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_type_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_event.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_state.dart';
import '../../../models/api/response/clan_war_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';
import '../../../utils/enums/process_type_enum.dart';
import '../../../utils/enums/war_state_enum.dart';
import '../../widgets/countdown_timer/countdown_timer_widget.dart';
import '../../widgets/bottom_progression_indicator.dart';
import '../../widgets/rank_image.dart';

class ClansCurrentWarScreen extends StatefulWidget {
  const ClansCurrentWarScreen({super.key});

  @override
  State<ClansCurrentWarScreen> createState() => _ClansCurrentWarScreenState();
}

class _ClansCurrentWarScreenState extends State<ClansCurrentWarScreen> {
  late BookmarkedClansCurrentWarBloc _bookmarkedClansCurrentWarBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedClansCurrentWarBloc =
        context.read<BookmarkedClansCurrentWarBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedClansCurrentWarBloc.add(
      GetBookmarkedClansCurrentWar(
        process: ProcessType.list,
        clanTagList: context.watch<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
    super.didChangeDependencies();
  }

  Future<void> _refreshList() async {
    _bookmarkedClansCurrentWarBloc.add(
      GetBookmarkedClansCurrentWar(
        process: ProcessType.refresh,
        clanTagList: context.read<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
  }

  Widget _emptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(AkarIcons.double_sword, size: 64.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr(LocaleKey.noClansInWar),
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        Text(
          tr(LocaleKey.noClansInWarMessage),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<BookmarkedClansCurrentWarBloc,
          BookmarkedClansCurrentWarState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      AkarIcons.face_sad,
                      size: 56.0,
                      color: Colors.amber,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        state.errorMessage ?? tr(LocaleKey.cocApiErrorMessage),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              );
            case BlocStatusEnum.loading:
            case BlocStatusEnum.success:
              if (state.status == BlocStatusEnum.loading &&
                  (state.items.isEmpty || !state.items.any((e) => e != null))) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.items.isEmpty || !state.items.any((e) => e != null)) {
                return _emptyList();
              }
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.amber,
                      onRefresh: _refreshList,
                      child: ListView.builder(
                        key: PageStorageKey(widget.key),
                        itemCount: state.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final clanCurrentWarData = state.items[index];
                          final clanTag = clanCurrentWarData?.clanTag;
                          final clanCurrentWar = clanCurrentWarData?.war;
                          if (clanCurrentWar == null ||
                              clanCurrentWar.state ==
                                  WarStateEnum.notInWar.name) {
                            return Container();
                          }
                          final warType = clanCurrentWarData?.warType;

                          DateTime? remainingDateTime;
                          final startTime =
                              DateTime.tryParse(clanCurrentWar.startTime ?? '');
                          final warStartTime = DateTime.tryParse(
                              clanCurrentWar.warStartTime ?? '');
                          final endTime =
                              DateTime.tryParse(clanCurrentWar.endTime ?? '');
                          if (endTime != null &&
                              clanCurrentWar.state == WarStateEnum.inWar.name) {
                            remainingDateTime = endTime;
                          } else if ((warStartTime != null ||
                                  startTime != null) &&
                              clanCurrentWar.state ==
                                  WarStateEnum.preparation.name) {
                            remainingDateTime = warStartTime ?? startTime;
                          }

                          WarClan clan;
                          WarClan opponent;
                          if (clanCurrentWar.clan.tag == clanTag) {
                            clan = clanCurrentWar.clan;
                            opponent = clanCurrentWar.opponent;
                          } else {
                            clan = clanCurrentWar.opponent;
                            opponent = clanCurrentWar.clan;
                          }
                          final warState = WarStateEnum.values.firstWhere(
                              (element) =>
                                  element.name == clanCurrentWar.state);
                          bool? clanWon = warState == WarStateEnum.warEnded
                              ? (clan.stars > opponent.stars ||
                                  (clan.stars == opponent.stars &&
                                      clan.destructionPercentage >
                                          opponent.destructionPercentage))
                              : null;

                          return Card(
                            margin: EdgeInsets.zero,
                            elevation: 0.0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                WarDetailScreen(
                                  clanTag: clanTag ?? '',
                                  warTag: clanCurrentWarData?.warTag ?? '',
                                  warType: warType ?? WarTypeEnum.clanWar,
                                  warStartTime:
                                      clanCurrentWar.warStartTime ?? '',
                                  clanName: clan.name ?? '',
                                  opponentName: opponent.name ?? '',
                                  showFloatingButton: true,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            RankImage(
                                              imageUrl: clan.badgeUrls.large,
                                              height: 40,
                                              width: 40,
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
                                        width: 155,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (remainingDateTime != null)
                                                CountdownTimerWidget(
                                                  remainingDateTime:
                                                      remainingDateTime,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (warState ==
                                                              WarStateEnum
                                                                  .inWar ||
                                                          warState ==
                                                              WarStateEnum
                                                                  .warEnded) ...[
                                                        Text(
                                                          clan.stars.toString(),
                                                          style: TextStyle(
                                                            fontSize: 22.0,
                                                            color: clanWon ==
                                                                    true
                                                                ? Colors.green
                                                                : (clanWon ==
                                                                        false
                                                                    ? Colors
                                                                        .redAccent
                                                                    : null),
                                                          ),
                                                        ),
                                                        Text(
                                                            '%${clan.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                                      ] else ...[
                                                        const Text(
                                                          '-',
                                                          style: TextStyle(
                                                              fontSize: 32.0),
                                                        ),
                                                        const Text(''),
                                                      ],
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                          fontSize: 22.0,
                                                          color: clanWon == true
                                                              ? Colors.green
                                                              : (clanWon ==
                                                                      false
                                                                  ? Colors
                                                                      .redAccent
                                                                  : null),
                                                        ),
                                                      ),
                                                      const Text(''),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (warState ==
                                                              WarStateEnum
                                                                  .inWar ||
                                                          warState ==
                                                              WarStateEnum
                                                                  .warEnded) ...[
                                                        Text(
                                                          opponent.stars
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 22.0,
                                                            color: clanWon ==
                                                                    true
                                                                ? Colors.green
                                                                : (clanWon ==
                                                                        false
                                                                    ? Colors
                                                                        .redAccent
                                                                    : null),
                                                          ),
                                                        ),
                                                        Text(
                                                            '%${opponent.destructionPercentage.toStringAsFixed(2).padLeft(2, '0')}'),
                                                      ] else ...[
                                                        const Text(
                                                          '-',
                                                          style: TextStyle(
                                                              fontSize: 32.0),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            RankImage(
                                              imageUrl:
                                                  opponent.badgeUrls.large,
                                              height: 40,
                                              width: 40,
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
                        },
                      ),
                    ),
                  ),
                  if (state.status == BlocStatusEnum.loading) ...[
                    const BottomProgressionIndicator(),
                  ],
                ],
              );
            default:
              return _emptyList();
          }
        },
      ),
    );
  }
}
