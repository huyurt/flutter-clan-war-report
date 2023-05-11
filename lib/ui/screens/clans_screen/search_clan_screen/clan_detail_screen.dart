import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/player_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_bloc.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_event.dart';
import '../../../../bloc/widgets/clan_detail/clan_detail_state.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';

class ClanDetailScreen extends StatefulWidget {
  const ClanDetailScreen({super.key, required this.clanTag});

  final String clanTag;

  @override
  State<ClanDetailScreen> createState() => _ClanDetailScreenState();
}

class _ClanDetailScreenState extends State<ClanDetailScreen> {
  late BookmarkedClanTagsCubit _bookmarkedClanTagsCubit;
  late ClanDetailBloc _clanDetailBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedClanTagsCubit = context.read<BookmarkedClanTagsCubit>();
    _clanDetailBloc = context.read<ClanDetailBloc>();
    _clanDetailBloc.add(
      GetClanDetail(
        clanTag: widget.clanTag,
      ),
    );
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
                  value: 0,
                  child: Text(tr(LocaleKey.warLog)),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text(tr(LocaleKey.openInGame)),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(tr(LocaleKey.copyClanTag)),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text(tr(LocaleKey.shareLink)),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  break;
                case 1:
                  break;
                case 2:
                  break;
                case 3:
                  break;
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ClanDetailBloc, ClanDetailState>(
        builder: (context, state) {
          if (state is ClanDetailStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClanDetailStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is ClanDetailStateSuccess) {
            final clan = state.clanDetail;
            final members = clan.memberList;
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
                            image: clan.badgeUrls?.large ??
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
                                    clan.name,
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
                                    child: Text(clan.tag),
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
                              const Icon(
                                Icons.public,
                                size: 18,
                                color: Colors.blue,
                              ),
                              Text(
                                  ' ${(clan.warWins ?? 0).toString()} ${tr(LocaleKey.wins)}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              const Icon(
                                Icons.public,
                                size: 18,
                                color: Colors.blue,
                              ),
                              Text(
                                  ' ${(clan.warTies ?? 0).toString()} ${tr(LocaleKey.ties)}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              const Icon(
                                Icons.public,
                                size: 18,
                                color: Colors.blue,
                              ),
                              Text(
                                  ' ${(clan.warLosses ?? 0).toString()} ${tr(LocaleKey.losses)}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              const Icon(
                                Icons.public,
                                size: 18,
                                color: Colors.blue,
                              ),
                              Text(
                                  ' ${(clan.warWinStreak ?? 0).toString()} ${tr(LocaleKey.warWinStreak)}'),
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
                                        (clan.location != null &&
                                                (clan.location?.isCountry ??
                                                    false))
                                            ? CountryFlags.flag(
                                                clan.location?.countryCode ??
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
                                            ' ${tr(clan.location?.name ?? LocaleKey.notSet)}'),
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
                                        if ((clan.warLeague?.id ?? 0) >
                                            AppConstants.warLeagueUnranked)
                                          Image.asset(
                                            '${AppConstants.clanWarLeaguesImagePath}${clan.warLeague?.id}.png',
                                            height: 18,
                                            fit: BoxFit.cover,
                                          )
                                        else if (clan.warLeague?.id ==
                                            AppConstants.warLeagueUnranked)
                                          Image.asset(
                                            '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
                                            height: 18,
                                            fit: BoxFit.cover,
                                          ),
                                        Text(
                                            ' ${tr(clan.warLeague?.name ?? '')}'),
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
                  if (!clan.description.isEmptyOrNull) ...[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          clan.description ?? '',
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
                              margin: EdgeInsetsDirectional.zero,
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
                                        member.league?.iconUrls?.medium != null
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
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
                                          width: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Card(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 12.0),
                                                  child: Text(member.trophies
                                                      .toString()),
                                                ),
                                              ),
                                            ],
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
                  const SizedBox(height: 24.0),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
