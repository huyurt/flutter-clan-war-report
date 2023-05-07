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

class ClansScreen extends StatefulWidget {
  const ClansScreen({super.key});

  @override
  State<ClansScreen> createState() => _ClansScreenState();
}

class _ClansScreenState extends State<ClansScreen> {
  late BookmarkedClansBloc _bookmarkedClansBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedClansBloc = context.read<BookmarkedClansBloc>();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedClansBloc.add(
      GetBookmarkedClanDetail(
        clanTagList: context.watch<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        key: PageStorageKey(widget.key),
        padding: const EdgeInsets.only(bottom: 75),
        itemCount:
            context.watch<BookmarkedClanTagsCubit>().state.clanTags.length,
        itemBuilder: (BuildContext context, int index) {
          return BlocBuilder<BookmarkedClansBloc, BookmarkedClansState>(
            builder: (context, state) {
              if (state is BookmarkedClansStateLoading) {
                return Container();
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BookmarkedClansStateError) {
                return Container();
                return Center(child: Text(tr('search_failed_message')));
              }
              if (state is BookmarkedClansStateSuccess) {
                if (state.clanDetailList.length - 1 < index) {
                  return Container();
                }
                final clan = state.clanDetailList[index];
                return Card(
                  margin: EdgeInsetsDirectional.zero,
                  elevation: 0.0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      ClanDetailScreen(
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
                            FadeInImage.assetNetwork(
                              height: 60,
                              width: 60,
                              image: clan.badgeUrls?.large ??
                                  AppConstants.placeholderImage,
                              placeholder: AppConstants.placeholderImage,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      clan.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          height: 1.0, fontSize: 16.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(tr("${clan.type}_clan_type")),
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
