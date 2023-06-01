import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/screens/clans_screen/search_clan_screen/clan_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_clans/bookmarked_clans_bloc.dart';
import '../../../bloc/widgets/bookmarked_clans/bookmarked_clans_event.dart';
import '../../../bloc/widgets/bookmarked_clans/bookmarked_clans_state.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/enums/bloc_status_enum.dart';
import '../../../utils/enums/process_type_enum.dart';
import '../../widgets/bottom_progression_indicator.dart';
import '../../widgets/rank_image.dart';

class ClansScreen extends StatefulWidget {
  const ClansScreen({super.key});

  @override
  State<ClansScreen> createState() => _ClansScreenState();
}

class _ClansScreenState extends State<ClansScreen> {
  late BookmarkedClanTagsCubit _bookmarkedClanTagsCubit;
  late BookmarkedClansBloc _bookmarkedClansBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedClanTagsCubit = context.read<BookmarkedClanTagsCubit>();
    _bookmarkedClansBloc = context.read<BookmarkedClansBloc>();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedClansBloc.add(
      GetBookmarkedClanDetail(
        process: ProcessType.list,
        clanTagList: context.watch<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
    super.didChangeDependencies();
  }

  Future<void> _refreshList() async {
    _bookmarkedClansBloc.add(
      GetBookmarkedClanDetail(
        process: ProcessType.refresh,
        clanTagList: context.read<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) async {
    _bookmarkedClansBloc.add(
      ReorderBookmarkedClanDetail(
        oldIndex: oldIndex,
        newIndex: newIndex,
        bookmarkedClanTagsCubit: _bookmarkedClanTagsCubit,
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
              AkarIcons.shield,
              size: 64.0,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                tr(LocaleKey.noBookmarkedClans),
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            Text(
              tr(LocaleKey.noBookmarkedClansMessage),
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
      child: BlocBuilder<BookmarkedClansBloc, BookmarkedClansState>(
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
                          final clan = state.items[index];
                          if (clan == null) {
                            return Container(key: const PageStorageKey(''));
                          }

                          return Card(
                            key: PageStorageKey(clan.tag),
                            margin: EdgeInsets.zero,
                            elevation: 0.0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                ClanDetailScreen(
                                  viewWarButton: true,
                                  clanTag: clan.tag,
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
                                        imageUrl: clan.badgeUrls?.large,
                                        height: 50,
                                        width: 50,
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
                                                clan.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    height: 1.2,
                                                    fontSize: 14.0),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  tr("${clan.type}_clan_type"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: 120,
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
                                                    '${(clan.clanPoints ?? 0).toString()} '),
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
