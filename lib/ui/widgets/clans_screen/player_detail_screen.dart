import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/widgets/player_detail/player_detail_bloc.dart';
import '../../../bloc/widgets/player_detail/player_detail_event.dart';
import '../../../bloc/widgets/player_detail/player_detail_state.dart';
import '../../../models/api/player_detail_response_model.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/helpers/image_helper.dart';

class PlayerDetailScreen extends StatefulWidget {
  const PlayerDetailScreen({super.key, required this.playerTag});

  final String playerTag;

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late PlayerDetailBloc _playerDetailBloc;

  @override
  void initState() {
    super.initState();
    _playerDetailBloc = context.read<PlayerDetailBloc>();
    _playerDetailBloc.add(
      GetPlayerDetail(
        playerTag: widget.playerTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(tr(LocaleKey.viewClan)),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(tr(LocaleKey.openInGame)),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(tr(LocaleKey.copyPlayerTag)),
                ),
                PopupMenuItem<int>(
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
      body: BlocBuilder<PlayerDetailBloc, PlayerDetailState>(
        builder: (context, state) {
          if (state is PlayerDetailStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlayerDetailStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is PlayerDetailStateSuccess) {
            PlayerDetailResponseModel player = state.playerDetail;
            Iterable<PlayerItemLevel> heroes = player.heroes
                    ?.where((element) => element.village == Village.HOME) ??
                <PlayerItemLevel>[].where((element) =>
                    ImageHelper.getHeroes().contains(element.name));
            Iterable<PlayerItemLevel> troops = (player.troops
                        ?.where((element) => element.village == Village.HOME) ??
                    <PlayerItemLevel>[])
                .where((element) =>
                    ImageHelper.getTroops().contains(element.name));
            Iterable<PlayerItemLevel> pets = (player.troops
                        ?.where((element) => element.village == Village.HOME) ??
                    <PlayerItemLevel>[])
                .where(
                    (element) => ImageHelper.getPets().contains(element.name));
            Iterable<PlayerItemLevel> spells = player.spells
                    ?.where((element) => element.village == Village.HOME) ??
                <PlayerItemLevel>[].where((element) =>
                    ImageHelper.getSpells().contains(element.name));
            Iterable<PlayerItemLevel> siegeMachines = player.troops
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
                          player.townHallWeaponLevel != null
                              ? Image.asset(
                                  '${AppConstants.townHallsImagePath}${player.townHallLevel}.${player.townHallWeaponLevel}.png',
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  '${AppConstants.townHallsImagePath}${player.townHallLevel}.png',
                                  height: 70,
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
                                    player.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(player.tag),
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
                                          height: 20,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(' ${player.warStars ?? 0}'),
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
                                Text(tr(LocaleKey.warLeague)),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        player.league?.iconUrls?.medium != null
                                            ? FadeInImage.assetNetwork(
                                                height: 20,
                                                image: player.league?.iconUrls
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
                                        Text(' ${player.trophies ?? 0}'),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr(LocaleKey.heroes)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 4.0,
                      children: ImageHelper.getHeroes().map(
                        (heroImage) {
                          PlayerItemLevel? hero = heroes.firstWhereOrNull(
                              (element) => element.name == heroImage);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
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
                                              horizontal:
                                                  hero.level < 10 ? 4.0 : 2.0),
                                          decoration: BoxDecoration(
                                            color: hero.level == hero.maxLevel
                                                ? Colors.amber
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            hero.level.toString(),
                                            style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold,
                                              color: hero.level == hero.maxLevel
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
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr(LocaleKey.pets)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 4.0,
                      children: ImageHelper.getPets().map(
                        (petImage) {
                          PlayerItemLevel? pet = pets.firstWhereOrNull(
                              (element) => element.name == petImage);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
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
                                              horizontal:
                                                  pet.level < 10 ? 4.0 : 2.0),
                                          decoration: BoxDecoration(
                                            color: pet.level == pet.maxLevel
                                                ? Colors.amber
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            pet.level.toString(),
                                            style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold,
                                              color: pet.level == pet.maxLevel
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
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr(LocaleKey.troops)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 4.0,
                      children: ImageHelper.getTroops().map(
                        (troopImage) {
                          PlayerItemLevel? troop = troops.firstWhereOrNull(
                              (element) => element.name == troopImage);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
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
                                              horizontal:
                                                  troop.level < 10 ? 4.0 : 2.0),
                                          decoration: BoxDecoration(
                                            color: troop.level == troop.maxLevel
                                                ? Colors.amber
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            troop.level.toString(),
                                            style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  troop.level == troop.maxLevel
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
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr(LocaleKey.spells)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 4.0,
                      children: ImageHelper.getSpells().map(
                        (spellImage) {
                          PlayerItemLevel? spell = spells.firstWhereOrNull(
                              (element) => element.name == spellImage);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
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
                                              horizontal:
                                                  spell.level < 10 ? 4.0 : 2.0),
                                          decoration: BoxDecoration(
                                            color: spell.level == spell.maxLevel
                                                ? Colors.amber
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            spell.level.toString(),
                                            style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  spell.level == spell.maxLevel
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
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr(LocaleKey.siegeMachines)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 4.0,
                      children: ImageHelper.getSiegeMachines().map(
                        (siegeMachineImage) {
                          PlayerItemLevel? siegeMachine =
                              siegeMachines.firstWhereOrNull((element) =>
                                  element.name == siegeMachineImage);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
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
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            siegeMachine.level.toString(),
                                            style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold,
                                              color: siegeMachine.level ==
                                                      siegeMachine.maxLevel
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
                          );
                        },
                      ).toList(),
                    ),
                  ),
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
