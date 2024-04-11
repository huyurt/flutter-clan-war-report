import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:clan_war_report/ui/screens/clans_current_war_screen/war_detail/war_detail_screen.dart';
import 'package:clan_war_report/ui/screens/clans_screen/search_clan_screen/player_detail_screen.dart';
import 'package:clan_war_report/ui/screens/clans_screen/search_clan_screen/war_log_screen/war_log_screen.dart';
import 'package:clan_war_report/utils/enums/war_state_enum.dart';
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
import '../../../widgets/api_error_widget.dart';
import '../../../widgets/app_widgets/rank_image.dart';

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

  Future<void> _refresh() async {
    setState(() {
      _clanDetailFuture = ClanService.getClanDetail(widget.clanTag);
    });
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
                  await _refresh();
                  break;
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.amber,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _clanDetailFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ApiErrorWidget(
                  onRefresh: _refresh,
                );
              }
              if (snapshot.hasData) {
                final clan = snapshot.data;
                final players = clan?.memberList ?? <MemberList>[];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 75.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RankImage(
                                imageUrl: clan?.badgeUrls?.large,
                                height: 70,
                                width: 70,
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
                                            height: 1.2, fontSize: 20.0),
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
                        child: Center(
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            spacing: 14.0,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    const Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: Colors.green,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(
                                          Icons.trending_up,
                                          size: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(clan?.warWins ?? 0).toString()} ${tr(LocaleKey.wins)}',
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    const Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(
                                          Icons.trending_neutral,
                                          size: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(clan?.warTies ?? 0).toString()} ${tr(LocaleKey.ties)}',
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    const Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(
                                          Icons.trending_down,
                                          size: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(clan?.warLosses ?? 0).toString()} ${tr(LocaleKey.losses)}',
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0.0,
                                      color: Colors.grey,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(
                                          MdiIcons.chartLineVariant,
                                          size: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(clan?.warWinStreak ?? 0).toString()} ${tr(LocaleKey.warWinStreak)}',
                                      style: const TextStyle(fontSize: 10.0),
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
                                                    (clan?.location
                                                            ?.isCountry ??
                                                        false))
                                                ? CountryFlag.fromCountryCode(
                                                    clan?.location
                                                            ?.countryCode ??
                                                        '',
                                                    height: 18.0,
                                                    width: 24.0,
                                                    borderRadius: 4.0,
                                                  )
                                                : const Icon(
                                                    Icons.public,
                                                    size: 18.0,
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
                                                height: 18.0,
                                                fit: BoxFit.cover,
                                              )
                                            else if (clan?.warLeague?.id ==
                                                AppConstants.warLeagueUnranked)
                                              Image.asset(
                                                '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                                                height: 18.0,
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
                              style: const TextStyle(height: 1.3),
                            ),
                          ),
                        ),
                      ],
                      if (players.isNotEmpty) ...[
                        const SizedBox(height: 14.0),
                        ...players.map(
                          (player) => SizedBox(
                            height: 70,
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0.0,
                              color: context
                                      .watch<BookmarkedPlayerTagsCubit>()
                                      .state
                                      .playerTags
                                      .contains(player.tag)
                                  ? AppConstants.attackerClanBackgroundColor
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  PlayerDetailScreen(
                                    playerTag: player.tag,
                                  ).launch(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 5.0),
                                  child: SizedBox(
                                    height: 70.0,
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            player.league?.iconUrls?.medium !=
                                                    null
                                                ? FadeInImage.assetNetwork(
                                                    width: 45.0,
                                                    image: player
                                                            .league
                                                            ?.iconUrls
                                                            ?.medium ??
                                                        AppConstants
                                                            .placeholderImage,
                                                    placeholder: AppConstants
                                                        .placeholderImage,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                                                    height: 45.0,
                                                    width: 45.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Visibility(
                                              visible: (player.clanRank ?? 0) !=
                                                  (player.previousClanRank ??
                                                      0),
                                              child: Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: (player.clanRank ??
                                                              0) >
                                                          (player.previousClanRank ??
                                                              0)
                                                      ? const Icon(
                                                          Icons
                                                              .keyboard_arrow_up,
                                                          size: 24.0,
                                                          color: Colors.green,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 24.0,
                                                          color: Colors.red,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                '${AppConstants.clashResourceImagePath}${AppConstants.levelImage}',
                                                height: 30.0,
                                                width: 30.0,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      (player.expLevel ?? 0)
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Text(
                                                    player.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        height: 1.2,
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                                Text(
                                                  tr(player.role),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 110,
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
                                                      '${(player.trophies ?? 0).toString()} '),
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
                        ),
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
                        label: Text(
                          tr(LocaleKey.viewWar),
                          style: const TextStyle(fontSize: 10.0),
                        ),
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
