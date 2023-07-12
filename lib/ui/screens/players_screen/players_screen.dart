import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_bloc.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_event.dart';
import '../../../bloc/widgets/bookmarked_players/bookmarked_players_state.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/enums/bloc_status_enum.dart';
import '../../../utils/enums/process_type_enum.dart';
import '../../widgets/bottom_progression_indicator.dart';
import '../../widgets/app_widgets/rank_image.dart';
import '../../widgets/api_error_widget.dart';
import '../clans_screen/search_clan_screen/player_detail_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late BookmarkedPlayerTagsCubit _bookmarkedPlayerTagsCubit;
  late BookmarkedPlayersBloc _bookmarkedPlayersBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedPlayerTagsCubit = context.read<BookmarkedPlayerTagsCubit>();
    _bookmarkedPlayersBloc = context.read<BookmarkedPlayersBloc>();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedPlayersBloc.add(
      GetBookmarkedPlayerDetail(
        process: ProcessType.list,
        playerTagList:
            context.watch<BookmarkedPlayerTagsCubit>().state.playerTags,
      ),
    );
    super.didChangeDependencies();
  }

  Future<void> _refreshList() async {
    _bookmarkedPlayersBloc.add(
      GetBookmarkedPlayerDetail(
        process: ProcessType.refresh,
        playerTagList:
            context.read<BookmarkedPlayerTagsCubit>().state.playerTags,
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) async {
    _bookmarkedPlayersBloc.add(
      ReorderBookmarkedPlayerDetail(
        oldIndex: oldIndex,
        newIndex: newIndex,
        bookmarkedPlayerTagsCubit: _bookmarkedPlayerTagsCubit,
      ),
    );
  }

  Widget _emptyList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              AkarIcons.people_multiple,
              size: 64.0,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                tr(LocaleKey.noBookmarkedPlayers),
                style: const TextStyle(fontSize: 18.0),
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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<BookmarkedPlayersBloc, BookmarkedPlayersState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return ApiErrorWidget(
                onRefresh: _refreshList,
                isTimeout: state.isTimeout,
                errorMessage: state.errorMessage,
              );
            case BlocStatusEnum.loading:
            case BlocStatusEnum.success:
              if (state.status == BlocStatusEnum.loading &&
                  state.items.isEmpty) {
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
                      child: ReorderableListView.builder(
                        key: PageStorageKey(widget.key),
                        padding: const EdgeInsets.only(bottom: 75.0),
                        onReorder: _onReorder,
                        itemCount: state.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final player = state.items[index];
                          if (player == null) {
                            return Container(key: const PageStorageKey(''));
                          }

                          return Card(
                            key: PageStorageKey(player.tag),
                            margin: EdgeInsets.zero,
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
                                      RankImage(
                                        imageUrl:
                                            player.league?.iconUrls?.medium,
                                        height: 50,
                                        width: 50,
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
                                              Text(
                                                player.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    height: 1.2,
                                                    fontSize: 14.0),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        width: 16.0,
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              height: 1.2),
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
                                        width: 110,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
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
