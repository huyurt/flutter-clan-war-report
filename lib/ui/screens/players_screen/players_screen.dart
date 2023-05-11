import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_event.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_state.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/locale_key.dart';
import '../../widgets/bottom_progression_indicator.dart';
import '../clans_screen/search_clan_screen/player_detail_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late BookmarkedPlayersBloc _bookmarkedPlayersBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedPlayersBloc = context.read<BookmarkedPlayersBloc>();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedPlayersBloc.add(
      GetBookmarkedPlayerDetail(
        playerTagList:
            context.watch<BookmarkedPlayerTagsCubit>().state.playerTags,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<BookmarkedPlayersBloc, BookmarkedPlayersState>(
        builder: (context, state) {
          if (state is BookmarkedPlayersStateError) {
            return Container();
          }
          if (state is BookmarkedPlayersStateSuccess) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    key: PageStorageKey(widget.key),
                    padding: const EdgeInsets.only(bottom: 75.0),
                    itemCount: state.playerDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final player = state.playerDetailList[index];
                      if (player == null) {
                        return Container();
                      }

                      return Card(
                        margin: EdgeInsetsDirectional.zero,
                        elevation: 0.0,
                        color: Colors.transparent,
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
                              height: 70,
                              child: Row(
                                children: [
                                  FadeInImage.assetNetwork(
                                    height: 60,
                                    width: 60,
                                    image: player.league?.iconUrls?.medium ??
                                        AppConstants.placeholderImage,
                                    placeholder: AppConstants.placeholderImage,
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
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            player.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                height: 1.0, fontSize: 16.0),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4.0),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    width: 16,
                                                    image: player
                                                            .clan
                                                            ?.badgeUrls
                                                            ?.large ??
                                                        AppConstants
                                                            .placeholderImage,
                                                    placeholder: AppConstants
                                                        .placeholderImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Text(
                                                  player.clan?.name ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      height: 1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 105,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 12.0),
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
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: !state.fetchingCompleted,
                  child: const BottomProgressionIndicator(),
                ),
              ],
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AkarIcons.people_multiple,
                    size: 96.0,
                    color: Colors.amber,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      tr(LocaleKey.noBookmarkedPlayers),
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Text(
                    tr(LocaleKey.noBookmarkedPlayersMessage),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
