import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../models/api/response/player_detail_response_model.dart';
import '../../../../services/player_service.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/helpers/image_helper.dart';
import '../../../widgets/api_error_widget.dart';
import '../../../widgets/app_widgets/player_item_widget.dart';
import 'clan_detail_screen.dart';

class PlayerDetailScreen extends StatefulWidget {
  const PlayerDetailScreen({
    super.key,
    required this.playerTag,
  });

  final String playerTag;

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late BookmarkedPlayerTagsCubit _bookmarkedPlayerTagsCubit;

  late Future<PlayerDetailResponseModel> _playerDetailFuture;
  late String clanTag = '';

  @override
  void initState() {
    super.initState();
    _bookmarkedPlayerTagsCubit = context.read<BookmarkedPlayerTagsCubit>();
    _playerDetailFuture = PlayerService.getPlayerDetail(widget.playerTag);
  }

  Future<void> _refresh() async {
    setState(() {
      _playerDetailFuture = PlayerService.getPlayerDetail(widget.playerTag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(context
                    .watch<BookmarkedPlayerTagsCubit>()
                    .state
                    .playerTags
                    .contains(widget.playerTag)
                ? Icons.bookmark
                : Icons.bookmark_outline),
            onPressed: () async => await _bookmarkedPlayerTagsCubit
                .changeBookmarkedPlayerTags(widget.playerTag),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                if (!clanTag.isEmptyOrNull)
                  PopupMenuItem(
                    value: LocaleKey.viewClan,
                    child: Text(tr(LocaleKey.viewClan)),
                  ),
                PopupMenuItem(
                  value: LocaleKey.openInGame,
                  child: Text(tr(LocaleKey.openInGame)),
                ),
                PopupMenuItem(
                  value: LocaleKey.copyPlayerTag,
                  child: Text(tr(LocaleKey.copyPlayerTag)),
                ),
                PopupMenuItem(
                  value: LocaleKey.refresh,
                  child: Text(tr(LocaleKey.refresh)),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case LocaleKey.viewClan:
                  ClanDetailScreen(
                    viewWarButton: true,
                    clanTag: clanTag,
                  ).launch(context);
                  break;
                case LocaleKey.openInGame:
                  await launchUrl(
                    Uri.parse(
                        '${AppConstants.cocAppPlayerProfileUrl}${widget.playerTag}'),
                    mode: LaunchMode.externalApplication,
                  );
                  break;
                case LocaleKey.copyPlayerTag:
                  await Clipboard.setData(
                    ClipboardData(text: widget.playerTag),
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
          future: _playerDetailFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ApiErrorWidget(
                  onRefresh: _refresh,
                );
              }
              if (snapshot.hasData) {
                final player = snapshot.data;
                clanTag = player?.clan?.tag ?? '';

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Tooltip(
                                message:
                                    '${tr(LocaleKey.level)} ${player?.townHallLevel}',
                                triggerMode: TooltipTriggerMode.tap,
                                child: FadeIn(
                                  animate: true,
                                  duration: const Duration(milliseconds: 250),
                                  child: player?.townHallWeaponLevel != null
                                      ? Stack(
                                          children: [
                                            Image.asset(
                                              '${AppConstants.townHallsImagePath}${ImageHelper.getTownhallImage(player?.townHallLevel, player?.townHallWeaponLevel)}.png',
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  child: Icon(
                                                    AkarIcons.double_sword,
                                                    size: 16.0,
                                                    color:
                                                        player?.warPreference == 'in'
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Image.asset(
                                          '${AppConstants.townHallsImagePath}${player?.townHallLevel}.png',
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                ),
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
                                        player?.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            height: 1.2, fontSize: 20.0),
                                      ),
                                    ),
                                    if (player?.clan != null) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: FadeInImage.assetNetwork(
                                                width: 16,
                                                image: player?.clan?.badgeUrls
                                                        ?.large ??
                                                    AppConstants
                                                        .placeholderImage,
                                                placeholder: AppConstants
                                                    .placeholderImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text(
                                              player?.clan?.name ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:
                                                  const TextStyle(height: 1.2),
                                            ),
                                            if (!(player?.role?.isEmptyOrNull ??
                                                true)) ...[
                                              const Text(' - '),
                                              Text(
                                                tr(player?.role ?? ''),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Image.asset(
                                        '${AppConstants.clashResourceImagePath}${AppConstants.levelImage}',
                                        height: 14.0,
                                        width: 14.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      ' ${(player?.expLevel ?? 0).toString()} ${tr(LocaleKey.level)}',
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
                                      color: Colors.green,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: RotationTransition(
                                          turns: AlwaysStoppedAnimation(0.75),
                                          child: Icon(
                                            Icons.trending_neutral,
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(player?.donations ?? 0).toString()} ${tr(LocaleKey.donatedTroops)}',
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
                                      color: Colors.orange,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: RotationTransition(
                                          turns: AlwaysStoppedAnimation(0.25),
                                          child: Icon(
                                            Icons.trending_neutral,
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${(player?.donationsReceived ?? 0).toString()} ${tr(LocaleKey.troopsReceived)}',
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
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Column(
                                  children: [
                                    Text(tr(LocaleKey.warStars)),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              '${AppConstants.clashResourceImagePath}${AppConstants.star2Image}',
                                              height: 16.0,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(' ${player?.warStars ?? 0}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Column(
                                  children: [
                                    Text(tr(LocaleKey.trophies)),
                                    Card(
                                      child: Tooltip(
                                        message: tr(player?.league?.name ??
                                            LocaleKey.unranked),
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              player?.league?.iconUrls
                                                          ?.medium !=
                                                      null
                                                  ? FadeInImage.assetNetwork(
                                                      height: 16.0,
                                                      image: player
                                                              ?.league
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
                                                      height: 16.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                              Text(' ${player?.trophies ?? 0}'),
                                            ],
                                          ),
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
                      PlayerItemWidget(
                        title: tr(LocaleKey.heroes),
                        imagePath: AppConstants.heroesImagePath,
                        itemImages: ImageHelper.getHeroes(),
                        itemLevels: player?.heroes,
                      ),
                      PlayerItemWidget(
                        title: tr(LocaleKey.pets),
                        imagePath: AppConstants.petsImagePath,
                        itemImages: ImageHelper.getPets(),
                        itemLevels: player?.troops,
                      ),
                      PlayerItemWidget(
                        title: tr(LocaleKey.troops),
                        imagePath: AppConstants.troopsImagePath,
                        itemImages: ImageHelper.getTroops(),
                        itemLevels: player?.troops,
                      ),
                      PlayerItemWidget(
                        title: tr(LocaleKey.spells),
                        imagePath: AppConstants.spellsImagePath,
                        itemImages: ImageHelper.getSpells(),
                        itemLevels: player?.spells,
                      ),
                      PlayerItemWidget(
                        title: tr(LocaleKey.siegeMachines),
                        imagePath: AppConstants.siegeMachinesImagePath,
                        itemImages: ImageHelper.getSiegeMachines(),
                        itemLevels: player?.troops,
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
