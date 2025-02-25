import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clan_war_report/utils/constants/locale_key.dart';
import 'package:clan_war_report/utils/enums/bloc_status_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import '../../../../bloc/widgets/search_player/search_player_bloc.dart';
import '../../../../bloc/widgets/search_player/search_player_event.dart';
import '../../../../bloc/widgets/search_player/search_player_state.dart';
import '../../../../models/api/response/player_detail_response_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../widgets/bottom_loader.dart';
import '../../../widgets/app_widgets/rank_image.dart';
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
          ),
          controller: _clanFilterController,
        ),
      ),
      body: BlocBuilder<SearchPlayerBloc, SearchPlayerState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return Center(child: Text(tr('search_failed_message')));
            case BlocStatusEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case BlocStatusEnum.success:
              if (state.items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 50.0),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    Center(
                      child: Text(
                        tr(LocaleKey.noPlayerFound),
                        style: const TextStyle(fontSize: 18.0),
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
                          playerTag: player.tag ?? '',
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
                                imageUrl: player.league?.iconUrls?.medium,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        player.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            height: 1.2, fontSize: 14.0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
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
            default:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, size: 64.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      tr(LocaleKey.searchPlayer),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        tr(LocaleKey.searchPlayerMessage),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
