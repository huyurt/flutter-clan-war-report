import 'package:animate_do/animate_do.dart';
import 'package:collection/collection.dart';
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

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Colors.white24
            : Colors.black26;

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
                  setState(() {
                    _playerDetailFuture =
                        PlayerService.getPlayerDetail(widget.playerTag);
                  });
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _playerDetailFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(tr('search_failed_message')));
            }
            if (snapshot.hasData) {
              final player = snapshot.data;
              clanTag = player?.clan?.tag ?? '';
              final heroes = player?.heroes
                      ?.where((element) => element.village == Village.HOME) ??
                  <PlayerItemLevel>[].where((element) =>
                      ImageHelper.getHeroes().contains(element.name));
              final troops = (player?.troops?.where(
                          (element) => element.village == Village.HOME) ??
                      <PlayerItemLevel>[])
                  .where((element) =>
                      ImageHelper.getTroops().contains(element.name));
              final pets = (player?.troops?.where(
                          (element) => element.village == Village.HOME) ??
                      <PlayerItemLevel>[])
                  .where((element) =>
                      ImageHelper.getPets().contains(element.name));
              final spells = player?.spells
                      ?.where((element) => element.village == Village.HOME) ??
                  <PlayerItemLevel>[].where((element) =>
                      ImageHelper.getSpells().contains(element.name));
              final siegeMachines = player?.troops
                      ?.where((element) => element.village == Village.HOME) ??
                  <PlayerItemLevel>[].where((element) =>
                      ImageHelper.getSiegeMachines().contains(element.name));

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
                                    ? Image.asset(
                                        '${AppConstants.townHallsImagePath}${player?.townHallLevel}.${player?.townHallWeaponLevel}.png',
                                        width: 70,
                                        fit: BoxFit.cover,
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
                                          height: 1, fontSize: 24.0),
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
                                                  AppConstants.placeholderImage,
                                              placeholder:
                                                  AppConstants.placeholderImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            player?.clan?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(height: 1.0),
                                          ),
                                          if (!(player?.role?.isEmptyOrNull ??
                                              true)) ...[
                                            const Text(' - '),
                                            Text(
                                              tr(player?.role ?? ''),
                                              style: const TextStyle(
                                                  fontSize: 12.0),
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
                                            height: 18,
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
                                            player?.league?.iconUrls?.medium !=
                                                    null
                                                ? FadeInImage.assetNetwork(
                                                    height: 20,
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
                                                    height: 18,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr(LocaleKey.heroes)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          children: ImageHelper.getHeroes().map(
                            (heroImage) {
                              PlayerItemLevel? hero = heroes.firstWhereOrNull(
                                  (element) => element.name == heroImage);
                              List<String> tooltipMessage = <String>[];
                              tooltipMessage.add(tr(heroImage));
                              tooltipMessage.add(hero != null
                                  ? '${tr(LocaleKey.level)} ${hero.level}/${hero.maxLevel}'
                                  : tr(LocaleKey.notUnlocked));
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Tooltip(
                                    message: tooltipMessage
                                        .getRange(0, tooltipMessage.length)
                                        .join('\n'),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: true,
                                    child: Stack(
                                      children: [
                                        if (hero != null) ...[
                                          Image.asset(
                                            '${AppConstants.heroesImagePath}$heroImage.png',
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: hero.level < 10
                                                        ? 4.0
                                                        : 2.0),
                                                decoration: BoxDecoration(
                                                  color: hero.level ==
                                                          hero.maxLevel
                                                      ? Colors.amber
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  hero.level.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: hero.level ==
                                                            hero.maxLevel
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.asset(
                                              '${AppConstants.heroesImagePath}$heroImage.png',
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr(LocaleKey.pets)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          children: ImageHelper.getPets().map(
                            (petImage) {
                              PlayerItemLevel? pet = pets.firstWhereOrNull(
                                  (element) => element.name == petImage);
                              List<String> tooltipMessage = <String>[];
                              tooltipMessage.add(tr(petImage));
                              tooltipMessage.add(pet != null
                                  ? '${tr(LocaleKey.level)} ${pet.level}/${pet.maxLevel}'
                                  : tr(LocaleKey.notUnlocked));
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Tooltip(
                                    message: tooltipMessage
                                        .getRange(0, tooltipMessage.length)
                                        .join('\n'),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: true,
                                    child: Stack(
                                      children: [
                                        if (pet != null) ...[
                                          Image.asset(
                                            '${AppConstants.petsImagePath}$petImage.png',
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: pet.level < 10
                                                        ? 4.0
                                                        : 2.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      pet.level == pet.maxLevel
                                                          ? Colors.amber
                                                          : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  pet.level.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: pet.level ==
                                                            pet.maxLevel
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.asset(
                                              '${AppConstants.petsImagePath}$petImage.png',
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr(LocaleKey.troops)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          children: ImageHelper.getTroops().map(
                            (troopImage) {
                              PlayerItemLevel? troop = troops.firstWhereOrNull(
                                  (element) => element.name == troopImage);
                              List<String> tooltipMessage = <String>[];
                              tooltipMessage.add(tr(troopImage));
                              tooltipMessage.add(troop != null
                                  ? '${tr(LocaleKey.level)} ${troop.level}/${troop.maxLevel}'
                                  : tr(LocaleKey.notUnlocked));
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Tooltip(
                                    message: tooltipMessage
                                        .getRange(0, tooltipMessage.length)
                                        .join('\n'),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: true,
                                    child: Stack(
                                      children: [
                                        if (troop != null) ...[
                                          Image.asset(
                                            '${AppConstants.troopsImagePath}$troopImage.png',
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: troop.level < 10
                                                        ? 4.0
                                                        : 2.0),
                                                decoration: BoxDecoration(
                                                  color: troop.level ==
                                                          troop.maxLevel
                                                      ? Colors.amber
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  troop.level.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: troop.level ==
                                                            troop.maxLevel
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.asset(
                                              '${AppConstants.troopsImagePath}$troopImage.png',
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr(LocaleKey.spells)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          children: ImageHelper.getSpells().map(
                            (spellImage) {
                              PlayerItemLevel? spell = spells.firstWhereOrNull(
                                  (element) => element.name == spellImage);
                              List<String> tooltipMessage = <String>[];
                              tooltipMessage.add(tr(spellImage));
                              tooltipMessage.add(spell != null
                                  ? '${tr(LocaleKey.level)} ${spell.level}/${spell.maxLevel}'
                                  : tr(LocaleKey.notUnlocked));
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Tooltip(
                                    message: tooltipMessage
                                        .getRange(0, tooltipMessage.length)
                                        .join('\n'),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: true,
                                    child: Stack(
                                      children: [
                                        if (spell != null) ...[
                                          Image.asset(
                                            '${AppConstants.spellsImagePath}$spellImage.png',
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: spell.level < 10
                                                        ? 4.0
                                                        : 2.0),
                                                decoration: BoxDecoration(
                                                  color: spell.level ==
                                                          spell.maxLevel
                                                      ? Colors.amber
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  spell.level.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: spell.level ==
                                                            spell.maxLevel
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.asset(
                                              '${AppConstants.spellsImagePath}$spellImage.png',
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr(LocaleKey.siegeMachines)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          children: ImageHelper.getSiegeMachines().map(
                            (siegeMachineImage) {
                              PlayerItemLevel? siegeMachine =
                                  siegeMachines.firstWhereOrNull((element) =>
                                      element.name == siegeMachineImage);
                              List<String> tooltipMessage = <String>[];
                              tooltipMessage.add(tr(siegeMachineImage));
                              tooltipMessage.add(siegeMachine != null
                                  ? '${tr(LocaleKey.level)} ${siegeMachine.level}/${siegeMachine.maxLevel}'
                                  : tr(LocaleKey.notUnlocked));
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Tooltip(
                                    message: tooltipMessage
                                        .getRange(0, tooltipMessage.length)
                                        .join('\n'),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: true,
                                    child: Stack(
                                      children: [
                                        if (siegeMachine != null) ...[
                                          Image.asset(
                                            '${AppConstants.siegeMachinesImagePath}$siegeMachineImage.png',
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal:
                                                        siegeMachine.level < 10
                                                            ? 4.0
                                                            : 2.0),
                                                decoration: BoxDecoration(
                                                  color: siegeMachine.level ==
                                                          siegeMachine.maxLevel
                                                      ? Colors.amber
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  siegeMachine.level.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: siegeMachine.level ==
                                                            siegeMachine
                                                                .maxLevel
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.asset(
                                              '${AppConstants.siegeMachinesImagePath}$siegeMachineImage.png',
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
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
    );
  }
}
