import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../../bloc/widgets/search_player/search_player_bloc.dart';
import '../../../../bloc/widgets/search_player/search_player_event.dart';
import '../../../../bloc/widgets/search_player/search_player_state.dart';
import '../../../../models/api/response/player_detail_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../widgets/bottom_loader.dart';
import '../../clans_screen/search_clan_screen/player_detail_screen.dart';

class SearchPlayerScreen extends StatefulWidget {
  const SearchPlayerScreen({super.key});

  @override
  State<SearchPlayerScreen> createState() => _SearchPlayerScreenState();
}

class _SearchPlayerScreenState extends State<SearchPlayerScreen> {
  late SearchPlayerBloc _searchPlayerBloc;

  final TextEditingController _clanFilterController = TextEditingController();
  String? _prevClanFilter;

  @override
  void initState() {
    super.initState();
    _searchPlayerBloc = context.read<SearchPlayerBloc>();
    _searchPlayerBloc.add(ClearFilter());

    _clanFilterController.addListener(() {
      if (_prevClanFilter != _clanFilterController.text) {
        _prevClanFilter = _clanFilterController.text;
        _performSearch();
      }
    });
  }

  @override
  void dispose() {
    _clanFilterController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _performSearch() {
    _searchPlayerBloc.add(
      TextChanged(
        searchTerm: _clanFilterController.text,
      ),
    );
  }

  //void _onClearTapped() {
  //  _clanFilterController.text = '';
  //  _SearchPlayerBloc.add(
  //    FilterChanged(
  //      searchTerm: String(
  //        clanName: '',
  //        minMembers: _members.start.round(),
  //        maxMembers: _members.end.round(),
  //        minClanLevel: _minClanLevel.round(),
  //      ),
  //    ),
  //  );
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: tr(LocaleKey.search),
            //suffixIcon: GestureDetector(
            //  onTap: _onClearTapped,
            //  child: const Icon(Icons.clear),
            //),
          ),
          controller: _clanFilterController,
        ),
      ),
      body: BlocBuilder<SearchPlayerBloc, SearchPlayerState>(
        builder: (context, state) {
          if (state is SearchStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is SearchStateSuccess) {
            if (state.items.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 50.0),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Center(
                    child: Text(
                      tr(LocaleKey.noClanFound),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 75.0),
                    child: Center(
                      child: Text(
                        tr(LocaleKey.searchPlayerMessage),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (BuildContext context, int index) {
                if (index >= state.items.length) {
                  return const BottomLoader();
                }
                PlayerDetailResponseModel player = state.items[index];
                return Card(
                  margin: EdgeInsetsDirectional.zero,
                  elevation: 0.0,
                  color: context
                          .watch<BookmarkedClanTagsCubit>()
                          .state
                          .clanTags
                          .contains(player.tag)
                      ? Theme.of(context).colorScheme.secondary
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      player.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(player.clan?.name ?? ''),
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
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 50.0),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Center(
                child: Text(
                  tr(LocaleKey.searchPlayer),
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 75.0),
                child: Center(
                  child: Text(
                    tr(LocaleKey.searchPlayerMessage),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
