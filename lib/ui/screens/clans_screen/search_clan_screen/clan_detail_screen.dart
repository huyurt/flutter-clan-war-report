import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_current_war_screen/war_detail/war_detail_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/player_detail_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/war_log_screen/war_log_screen.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/response/clan_detail_response_model.dart';
import '../../../../models/coc/clans_current_war_state_model.dart';
import '../../../../services/clan_service.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/war_type_enum.dart';

class ClanDetailScreen extends StatefulWidget {
  const ClanDetailScreen({
    super.key,
    required this.viewWarButton,
    required this.clanTag,
  });

  final bool viewWarButton;
  final String clanTag;

  @override
  State<ClanDetailScreen> createState() => _ClanDetailScreenState();
}

class _ClanDetailScreenState extends State<ClanDetailScreen> {
  late BookmarkedClanTagsCubit _bookmarkedClanTagsCubit;

  late Future<ClanDetailResponseModel> _clanDetailFuture;
  late Future<ClansCurrentWarStateModel> _currentWarDetailFuture;

  @override
  void initState() {
    super.initState();
    _bookmarkedClanTagsCubit = context.read<BookmarkedClanTagsCubit>();
    _clanDetailFuture = ClanService.getClanDetail(widget.clanTag);
    if (widget.viewWarButton) {
      _currentWarDetailFuture =
          ClanService.getCurrentWarDetail(widget.clanTag, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(context
                    .watch<BookmarkedClanTagsCubit>()
                    .state
                    .clanTags
                    .contains(widget.clanTag)
                ? Icons.bookmark
                : Icons.bookmark_outline),
            onPressed: () async => await _bookmarkedClanTagsCubit
                .changeBookmarkedClanTags(widget.clanTag),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: LocaleKey.warLog,
                  child: Text(tr(LocaleKey.warLog)),
                ),
                PopupMenuItem(
                  value: LocaleKey.openInGame,
                  child: Text(tr(LocaleKey.openInGame)),
                ),
                PopupMenuItem(
                  value: LocaleKey.copyClanTag,
                  child: Text(tr(LocaleKey.copyClanTag)),
                ),
                PopupMenuItem(
                  value: LocaleKey.refresh,
                  child: Text(tr(LocaleKey.refresh)),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case LocaleKey.warLog:
                  WarLogScreen(
                    clanTag: widget.clanTag,
                  ).launch(context);
                  break;
                case LocaleKey.openInGame:
                  await launchUrl(
                    Uri.parse(
                        '${AppConstants.cocAppClanProfileUrl}${widget.clanTag}'),
                    mode: LaunchMode.externalApplication,
                  );
                  break;
                case LocaleKey.copyClanTag:
                  await Clipboard.setData(
                    ClipboardData(text: widget.clanTag),
                  );
                  break;
                case LocaleKey.refresh:
                  setState(() {
                    _clanDetailFuture =
                        ClanService.getClanDetail(widget.clanTag);
                  });
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _clanDetailFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(tr('search_failed_message')));
            }
            if (snapshot.hasData) {
              final clan = snapshot.data;
              final members = clan?.memberList ?? <MemberList>[];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FadeInImage.assetNetwork(
                              height: 70,
                              image: clan?.badgeUrls?.large ??
                                  AppConstants.placeholderImage,
                              placeholder: AppConstants.placeholderImage,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      clan?.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          height: 1.0, fontSize: 24.0),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(clan?.tag ?? ''),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 14.0,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                const Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                  color: Colors.green,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    child: Icon(
                                      Icons.trending_up,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                    ' ${(clan?.warWins ?? 0).toString()} ${tr(LocaleKey.wins)}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                const Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                  color: Colors.blue,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    child: Icon(
                                      Icons.trending_neutral,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                    ' ${(clan?.warTies ?? 0).toString()} ${tr(LocaleKey.ties)}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                const Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                  color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      Icons.trending_down,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                    ' ${(clan?.warLosses ?? 0).toString()} ${tr(LocaleKey.losses)}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                const Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                  color: Colors.grey,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      MdiIcons.chartLineVariant,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                    ' ${(clan?.warWinStreak ?? 0).toString()} ${tr(LocaleKey.warWinStreak)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                children: [
                                  Text(tr(LocaleKey.country)),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          (clan?.location != null &&
                                                  (clan?.location?.isCountry ??
                                                      false))
                                              ? CountryFlag.fromCountryCode(
                                                  clan?.location?.countryCode ??
                                                      '',
                                                  height: 16.0,
                                                  width: 24.0,
                                                  borderRadius: 4.0,
                                                )
                                              : const Icon(
                                                  Icons.public,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                          Text(
                                              ' ${tr(clan?.location?.name ?? LocaleKey.notSet)}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                children: [
                                  Text(tr(LocaleKey.warLeague)),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          if ((clan?.warLeague?.id ?? 0) >
                                              AppConstants.warLeagueUnranked)
                                            Image.asset(
                                              '${AppConstants.clanWarLeaguesImagePath}${clan?.warLeague?.id}.png',
                                              height: 18,
                                              fit: BoxFit.cover,
                                            )
                                          else if (clan?.warLeague?.id ==
                                              AppConstants.warLeagueUnranked)
                                            Image.asset(
                                              '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                                              height: 18,
                                              fit: BoxFit.cover,
                                            ),
                                          Text(
                                              ' ${tr(clan?.warLeague?.name ?? '')}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!(clan?.description?.isEmptyOrNull ?? true)) ...[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            clan?.description ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    if (members.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ...members
                          .map(
                            (member) => SizedBox(
                              height: 70,
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 0.0,
                                color: context
                                        .watch<BookmarkedPlayerTagsCubit>()
                                        .state
                                        .playerTags
                                        .contains(member.tag)
                                    ? AppConstants.attackerClanBackgroundColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    PlayerDetailScreen(
                                      playerTag: member.tag,
                                    ).launch(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 5.0),
                                    child: SizedBox(
                                      height: 70,
                                      child: Row(
                                        children: [
                                          member.league?.iconUrls?.medium !=
                                                  null
                                              ? FadeInImage.assetNetwork(
                                                  width: 50,
                                                  image: member.league?.iconUrls
                                                          ?.medium ??
                                                      AppConstants
                                                          .placeholderImage,
                                                  placeholder: AppConstants
                                                      .placeholderImage,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    member.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        height: 1,
                                                        fontSize: 16.0),
                                                  ),
                                                  Text(tr(member.role)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 105,
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0,
                                                        horizontal: 12.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        '${(member.trophies ?? 0).toString()} '),
                                                    Image.asset(
                                                      '${AppConstants.clashResourceImagePath}${AppConstants.cup1Image}',
                                                      height: 20,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                    const SizedBox(height: 72.0),
                  ],
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.viewWarButton
          ? FutureBuilder(
              future: _currentWarDetailFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final currentWarDetail = snapshot.data;
                    return Visibility(
                      visible: currentWarDetail?.war.state !=
                          WarStateEnum.notInWar.name,
                      child: FloatingActionButton.extended(
                        label: Text(tr(LocaleKey.viewWar)),
                        onPressed: () {
                          WarDetailScreen(
                            clanTag: widget.clanTag,
                            warTag: currentWarDetail?.warTag ?? '',
                            warType: currentWarDetail?.warType ??
                                WarTypeEnum.clanWar,
                            warStartTime:
                                currentWarDetail?.war.warStartTime ?? '',
                            clanName: currentWarDetail?.war.clan.name ?? '',
                            opponentName:
                                currentWarDetail?.war.opponent.name ?? '',
                            showFloatingButton: true,
                          ).launch(context);
                        },
                      ),
                    );
                  }
                }
                return Visibility(
                  visible: false,
                  child: FloatingActionButton(onPressed: () {}),
                );
              },
            )
          : null,
    );
  }
}
